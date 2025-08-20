import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/models/md_user_selfie.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';

import '../../../data/config/app_images.dart';

/// Snap Selfies Controller
class SnapSelfiesController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      final List<Contact> _contacts = Get.arguments as List<Contact>;
      if (_contacts.isNotEmpty) {
        contacts.value = _contacts;
        contacts.refresh();
        setUsers();
      }
    }
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
    stopTimer();
    _textsTimer?.cancel();
    super.onClose();
  }

  /// Contacts list
  RxList<Contact> contacts = <Contact>[].obs;

  /// Seconds left for the timer
  RxInt secondsLeft = 300.obs;

  /// Timer for countdown
  Timer? _timer;

  /// Current index for texts
  RxInt currentIndex = 0.obs;

  /// Timer for texts
  Timer? _textsTimer;

  /// Indicates if all selfies are taken
  RxBool isAllSelfiesTaken = false.obs;

  /// User picked selfie
  Rx<XFile> pickedSelfie = Rx<XFile>(XFile(''));

  /// List of selfies taken by the user
  RxList<MdUserSelfie> selfies = <MdUserSelfie>[].obs;

  /// Set users
  void setUsers() {
    startTimer();
    selfies
      ..clear()
      ..add(
        MdUserSelfie(
          id: 'current_user',
          displayName: 'You',
          userId: 'current_user',
          assetImage: AppImages.youProfile,
          createdAt: DateTime.now(),
        ),
      );

    for (final Contact contact in contacts) {
      final MdUserSelfie selfie = MdUserSelfie(
        id: contact.id,
        displayName: contact.displayName,
        userId: contact.id,
        createdAt: DateTime.now(),
        isWaiting: true,
      );
      selfies.add(selfie);
    }
    selfies.refresh();
  }

  /// Starts the timer for 5 minutes (300 seconds)
  void startTimer() {
    _timer?.cancel();
    secondsLeft.value = 300;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (secondsLeft.value > 0) {
          secondsLeft.value--;
        } else {
          isAllSelfiesTaken(true);
          appSnackbar(
            message: 'All selfies taken! 🎉 Let\'s see the results.',
            snackbarState: SnackbarState.success,
          );
          timer.cancel();
        }
      },
    );
  }

  /// Stops the timer
  void stopTimer() {
    _timer?.cancel();
  }

  /// Checks if the camera is initialized.
  final List<String> texts = <String>[
    'Clark is still fixing his hair 👀',
    'Lois is adjusting her glasses 🤓',
    'Jimmy is checking his camera settings 📸',
    'Perry is doing quick mack-up 💄',
    'Lex is practicing his smile 😏',
    'Superman is flexing his muscles 💪',
  ];

  ///  Sets up the timer for changing texts
  void setUpTextTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer timer) {
        currentIndex.value = (currentIndex() + 1) % texts.length;
        currentIndex.refresh();
      },
    );
  }

  /// Handles the action when the user snaps a selfie
  Future<void> onSnapSelfie() async {
    await Get.toNamed(
      Routes.CAMERA,
      arguments: secondsLeft(),
    )?.then(
      (dynamic result) {
        if (result != null && result is XFile) {
          pickedSelfie(result);
          pickedSelfie.refresh();

          setUpTextTimer();
        }
      },
    );
  }

  /// On let go action
  void onLetGo() {
    Get.toNamed(
      Routes.AI_CHOOSING,
    );
  }
}
