import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

/// Controller for the Camera module.
class PickSelfieCameraController extends GetxController {
  /// File for preview
  Rx<File> previewFile = File('').obs;

  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments['seconds_left'] != null) {
        secondsLeft.value = Get.arguments['seconds_left'] as int;
        secondsLeft.refresh();
        startTimer();
      }

      if (Get.arguments['prompt'] != null) {
        prompt = Get.arguments['prompt'] as String;
      }
    }
    _setupCamera();
    super.onInit();
  }

  /// On ready
  @override
  void onReady() {
    super.onReady();
  }

  /// On close
  @override
  void onClose() {
    cameraController?.dispose();
    stopTimer();
    _retakeTimer?.cancel();
    super.onClose();
  }

  /// Camera controller instance
  CameraController? cameraController;

  /// Future to handle camera initialization
  late Future<void> initializeControllerFuture;

  /// Prompt for the selfie
  String prompt = '';

  /// Observable variables to track camera state
  final RxBool isCameraInitialized = false.obs;

  /// Observable variable to track if a picture is being captured
  final RxBool isCapturing = false.obs;

  /// Seconds left for the timer
  RxInt secondsLeft = 0.obs;

  /// Seconds left for retake timer
  RxInt retakeSecondsLeft = 0.obs;

  /// Timer for countdown
  Timer? _timer;

  /// Retake timer
  Timer? _retakeTimer;

  /// Can show retake button
  RxBool canShowRetake = false.obs;

  /// Start Retake timer
  void _startRetakeTimer() {
    _retakeTimer?.cancel();
    _retakeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (retakeSecondsLeft.value > 0) {
          retakeSecondsLeft.value--;
        } else {
          timer.cancel();
          canShowRetake(true);
        }
      },
    );
  }

  /// Starts the timer for 5 minutes (300 seconds)
  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (secondsLeft.value > 0) {
          secondsLeft.value--;
        } else {
          timer.cancel();
          onTimerFinished();
        }
      },
    );
  }

  /// Stops the timer
  void stopTimer() {
    _timer?.cancel();
  }

  /// Checks if the camera is initialized.
  Future<void> _setupCamera() async {
    isCameraInitialized(false);
    try {
      final List<CameraDescription> cameras = await availableCameras();

      final CameraDescription frontCamera = cameras.firstWhere(
        (CameraDescription cam) =>
            cam.lensDirection == CameraLensDirection.front,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      initializeControllerFuture = cameraController!.initialize();

      await initializeControllerFuture;
      isCameraInitialized.value = true;
    } on Exception catch (e) {
      logE('Camera setup error: $e');
      isCameraInitialized(false);
    }
  }

  /// On Retake
  Future<void> onRetake() async {
    previewFile(File(''));
    isCameraInitialized(false);
    isCapturing(false);
    if (cameraController != null) {
      await cameraController!.dispose();
      cameraController = null;
    }
    await _setupCamera();
  }

  /// Called when timer finishes
  void onTimerFinished() {
    Get.back(
      result: previewFile().path.isNotEmpty ? XFile(previewFile().path) : null,
    );
  }

  /// Take picture
  Future<void> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      logE('Camera not ready');
      return;
    }

    try {
      isCapturing(true);
      final XFile picture = await cameraController!.takePicture();

      final File file = File(picture.path);

      if (cameraController!.description.lensDirection ==
          CameraLensDirection.front) {
        final Uint8List bytes = await file.readAsBytes();
        final img.Image? capturedImage = img.decodeImage(bytes);

        if (capturedImage != null) {
          final img.Image fixedImage = img.flipHorizontal(capturedImage);

          await file.writeAsBytes(img.encodeJpg(fixedImage));
        }
      }

      _startRetakeTimer();

      previewFile(file);
      isCapturing(false);
    } on Exception catch (e) {
      logE('Capture failed: $e');
      isCapturing(false);
    }
  }

  /// Flip camera
  Future<void> flipCamera() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      logE('Camera not ready');
      return;
    }

    try {
      final CameraLensDirection currentDirection =
          cameraController!.description.lensDirection;

      final List<CameraDescription> cameras = await availableCameras();

      CameraDescription newCamera;

      if (currentDirection == CameraLensDirection.front) {
        newCamera = cameras.firstWhere(
          (CameraDescription cam) =>
              cam.lensDirection == CameraLensDirection.back,
        );
      } else {
        newCamera = cameras.firstWhere(
          (CameraDescription cam) =>
              cam.lensDirection == CameraLensDirection.front,
        );
      }

      cameraController = CameraController(
        newCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      initializeControllerFuture = cameraController!.initialize();

      await initializeControllerFuture;
      isCameraInitialized.value = true;
    } on Exception catch (e) {
      logE('Flip camera error: $e');
    }
  }
}
