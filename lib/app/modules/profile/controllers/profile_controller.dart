import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_highlight.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../snap_selfies/models/md_user_selfie.dart';

/// Profile Controller
class ProfileController extends GetxController with WidgetsBindingObserver {
  /// image
  Rx<File> image = File('').obs;

  /// On init
  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _prevBottomInset.value = View.of(Get.context!).viewInsets.bottom;
      },
    );
    super.onInit();
  }

  /// On close
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    nameInputFocusNode.dispose();
    super.onClose();
  }

  /// Observable to track keyboard visibility
  RxBool isKeyboardVisible = false.obs;

  /// Previous bottom inset for keyboard
  final RxDouble _prevBottomInset = 0.0.obs;

  /// Focus node for chat input field
  final FocusNode nameInputFocusNode = FocusNode();

  /// Text editing controller for chat input field
  TextEditingController nameInputController = TextEditingController();

  /// On ready
  Rx<MdUserSelfie> user = MdUserSelfie(
    id: 'current_user',
    displayName: 'Marri',
    userId: 'current_user',
    selfieUrl: 'https://picsum.photos/seed/picsum/200/300',
    createdAt: DateTime.now(),
  ).obs;

  /// Pick Image Method
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e, st) {
      logE('Error picking image: $e');
      logE(st);
      return null;
    }
  }

  /// highlightCards
  final List<MdHighlight> highlightCards = <MdHighlight>[
    MdHighlight.random(
      title: 'Most likely to start an OF?',
      subtitle: 'That no-nonsense stare made it obvious',
    ),
    MdHighlight.random(
      title: 'Will become president?',
      subtitle: 'All of the indications of a girl that knows how to lie',
    ),
    MdHighlight.random(
      title: 'Most serious?',
      subtitle: 'She’s never heard of smiling',
    ),
    MdHighlight.random(
      title: 'Is the best at XYZ?',
      subtitle: 'The reason why she won goes here!',
    ),
  ];
}
