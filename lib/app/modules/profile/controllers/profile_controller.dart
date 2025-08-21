import 'package:fvf_flutter/app/modules/profile/models/md_highlight.dart';
import 'package:get/get.dart';

import '../../snap_selfies/models/md_user_selfie.dart';

/// Profile Controller
class ProfileController extends GetxController {
  /// On init
  @override
  void onInit() {
    super.onInit();
  }

  /// On ready
  Rx<MdUserSelfie> user = MdUserSelfie(
    id: 'current_user',
    displayName: 'Marri',
    userId: 'current_user',
    selfieUrl: 'https://picsum.photos/seed/picsum/200/300',
    createdAt: DateTime.now(),
  ).obs;

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
