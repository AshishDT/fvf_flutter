import 'dart:async';
import 'dart:ui';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/models/md_user_selfie.dart';
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
    _timer?.cancel();
    super.onClose();
  }

  /// Contacts list
  RxList<Contact> contacts = <Contact>[].obs;

  /// Seconds left for the timer
  RxInt secondsLeft = 300.obs;

  /// Timer for countdown
  Timer? _timer;

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
          timer.cancel();
        }
      },
    );
  }

  /// Stops the timer
  void stopTimer() {
    _timer?.cancel();
  }

  /// Clears all selected contacts
  final List<Color> avatarColors = <Color>[
    const Color(0xFF13C4E5),
    const Color(0xFF8C6BF5),
    const Color(0xFFD353DB),
    const Color(0xFF5B82FF),
    const Color(0xFFFB47CD),
    const Color(0xFF34A1FF),
    const Color(0xFF7C70F9),
  ];

  /// Generates a color for the avatar based on the contact ID
  Color getAvatarColor(String id) {
    final int hash = id.hashCode;
    final int index = hash % avatarColors.length;
    return avatarColors[index];
  }
}
