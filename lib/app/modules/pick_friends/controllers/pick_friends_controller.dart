import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

/// Controller for the Pick Friends module
class PickFriendsController extends GetxController {
  /// On init
  @override
  void onInit() {
    getContacts();
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
    super.onClose();
  }

  /// Is loading state
  RxBool isLoading = true.obs;

  /// Search controller for filtering contacts
  TextEditingController searchController = TextEditingController();

  /// List of contacts
  RxList<Contact> contacts = <Contact>[].obs;

  /// Set of selected contact IDs
  RxSet<String> selectedIds = <String>{}.obs;

  /// Selected contacts
  RxList<Contact> get selectedContacts => contacts
      .where((Contact contact) => selectedIds.contains(contact.id))
      .toList()
      .obs;

  /// Requests permission to access contacts
  Future<bool> requestContactsPermission() async {
    PermissionStatus status = await Permission.contacts.status;

    if (status.isDenied) {
      status = await Permission.contacts.request();
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return status.isGranted;
  }

  /// Get contacts from the device
  Future<void> getContacts() async {
    isLoading(true);
    contacts.clear();
    selectedIds.clear();

    try {
      final bool granted = await requestContactsPermission();

      if (!granted) {
        appSnackbar(
          message:
              'Permission to access contacts is denied. Please enable it in settings.',
          snackbarState: SnackbarState.danger,
        );
        return;
      }

      final List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
        withAccounts: true,
      );

      this.contacts(contacts);

      this.contacts.removeWhere((Contact contact) =>
          contact.phones.isEmpty || contact.displayName.isEmpty);
      this.contacts.refresh();
    } on Exception catch (e, stack) {
      appSnackbar(
        message: 'Failed to load contacts: $e',
        snackbarState: SnackbarState.danger,
      );
      logE('getContacts error: $e\n$stack');
    } finally {
      isLoading(false);
    }
  }

  /// Toggles the selection of a contact by ID
  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }

    selectedIds.refresh();
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

  /// On continue button pressed
  void onContinueButtonPressed() {
    if (selectedContacts.isEmpty || selectedContacts.length < 3) {
      appSnackbar(
        message: 'Please select at least 3 friends to continue.',
        snackbarState: SnackbarState.warning,
      );
      return;
    }

    if (selectedContacts.length > 8) {
      appSnackbar(
        message: 'You can select a maximum of 8 friends.',
        snackbarState: SnackbarState.warning,
      );
      return;
    }
  }
}
