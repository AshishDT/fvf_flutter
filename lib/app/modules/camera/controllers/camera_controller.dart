import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import '../../../data/config/logger.dart';

/// Controller for handling selfie camera actions
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
    _autoFinishTimer?.cancel();
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

  /// Auto-finish timer after capture
  Timer? _autoFinishTimer;

  /// Can show retake button
  RxBool canShowRetake = false.obs;

  /// Is retake loading
  RxBool isRetakeLoading = false.obs;

  /// Starts the timer for countdown
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
    if (isRetakeLoading()) {
      return;
    }

    isRetakeLoading(true);

    _autoFinishTimer?.cancel();
    _autoFinishTimer = null;

    try {
      previewFile(File(''));
      isCameraInitialized(false);
      isCapturing(false);
      canShowRetake(false);
      if (cameraController != null) {
        await cameraController!.dispose();
        cameraController = null;
      }
      await _setupCamera();
    } finally {
      isRetakeLoading(false);
    }
  }

  /// Called when timer finishes
  Future<void> onTimerFinished() async {
    if (isCapturing()) {
      return;
    }

    await cameraController?.dispose();
    cameraController = null;
    isCameraInitialized(false);

    if (Get.currentRoute == Routes.CAMERA) {
      Get.back(
        result:
            previewFile().path.isNotEmpty ? XFile(previewFile().path) : null,
      );
    }
  }

  /// Take picture
  Future<void> takePicture() async {
    final CameraController? controller = cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (controller.value.isTakingPicture || isCapturing()) {
      return;
    }

    try {
      isCapturing(true);
      canShowRetake(true);

      final XFile xFile = await controller.takePicture();
      final File file = File(xFile.path);

      if (controller.description.lensDirection == CameraLensDirection.front) {
        final Uint8List bytes = await file.readAsBytes();
        final img.Image? imgDecoded = img.decodeImage(bytes);
        if (imgDecoded != null) {
          final img.Image fixed = img.flipHorizontal(imgDecoded);
          await file.writeAsBytes(img.encodeJpg(fixed));
        }
      }

      previewFile(file);

      _autoFinishTimer?.cancel();

      _autoFinishTimer = Timer(
        const Duration(seconds: 3),
        () {
          if (!isRetakeLoading() && previewFile().path.isNotEmpty) {
            canShowRetake(false);
            onTimerFinished();
          }
        },
      );
    } on CameraException catch (e) {
      logE('Capture failed: $e');
      canShowRetake(false);
    } finally {
      isCapturing(false);
    }
  }

  /// Flip camera
  Future<void> flipCamera() async {
    final CameraController? old = cameraController;
    if (old == null || !old.value.isInitialized) {
      logE('Camera not ready');
      return;
    }

    isCameraInitialized(false);

    try {
      final CameraLensDirection current = old.description.lensDirection;
      final List<CameraDescription> cams = await availableCameras();
      final CameraDescription target = cams.firstWhere(
        (c) =>
            c.lensDirection ==
            (current == CameraLensDirection.front
                ? CameraLensDirection.back
                : CameraLensDirection.front),
      );

      await old.dispose();

      final CameraController next = CameraController(
        target,
        ResolutionPreset.high,
        enableAudio: false,
      );

      cameraController = next;

      next.addListener(
        () {
          if (next.value.hasError) {
            logE('Camera error: ${next.value.errorDescription}');
          }
        },
      );

      initializeControllerFuture = next.initialize();
      await initializeControllerFuture;

      isCameraInitialized(true);
    } on CameraException catch (e) {
      logE('Flip camera error: $e');
      isCameraInitialized(false);
    } on Exception catch (e) {
      logE('Flip camera error: $e');
      isCameraInitialized(false);
    }
  }
}
