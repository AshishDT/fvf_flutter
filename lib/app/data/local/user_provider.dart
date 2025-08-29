import 'dart:convert';
import 'package:fvf_flutter/app/data/local/store/local_store.dart';
import 'package:get/get.dart';
import '../config/encryption.dart';
import '../models/md_user.dart';

/// Current user observable
Rx<MdUser> globalUser = Rx<MdUser>(MdUser());

/// Helper class for local stored User
class UserProvider {
  static MdUser? _userEntity;
  static String? _authToken;
  static late bool _isLoggedIn;

  /// Get currently logged in user
  static MdUser? get currentUser => _userEntity;

  /// Get auth token of the logged in user
  static String? get authToken => _authToken;

  /// If the user is logged in or not
  static bool get isLoggedIn => _isLoggedIn;

  ///Set [currentUser] and [authToken]
  static void onLogin({
    required MdUser user,
    required String userAuthToken,
  }) {
    _isLoggedIn = true;
    _userEntity = user;
    _authToken = userAuthToken;
    globalUser(user);
    LocalStore.user(AppEncryption.encrypt(plainText: user.asString()));
    LocalStore.authToken(userAuthToken);
  }

  ///Load [currentUser] and [authToken]
  static void loadUser() {
    final String? encryptedUserData = LocalStore.user();

    if (encryptedUserData != null) {
      _isLoggedIn = true;
      _userEntity = MdUser.fromJson(
          jsonDecode(AppEncryption.decrypt(cipherText: encryptedUserData))
              as Map<String, dynamic>);
      globalUser(_userEntity);
      _authToken = LocalStore.authToken();
    } else {
      _isLoggedIn = false;
    }
  }

  ///Remove [currentUser] and [authToken] from local storage
  static void onLogout() {
    _isLoggedIn = false;
    _userEntity = null;
    _authToken = null;
    globalUser(MdUser());
    LocalStore.user.erase();
    LocalStore.authToken.erase();
  }
}
