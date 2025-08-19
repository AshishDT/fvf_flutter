import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pick_friends_controller.dart';

/// Pick Friends View
class PickFriendsView extends GetView<PickFriendsController> {
  /// Constructor
  const PickFriendsView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('PickFriendsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PickFriendsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
}
