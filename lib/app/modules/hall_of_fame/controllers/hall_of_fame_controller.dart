import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:get/get.dart';

import '../models/md_hall_of_fame.dart';

/// Hall of fame controller
class HallOfFameController extends GetxController {
  /// On init
  @override
  void onInit() {
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


  /// Hall of fame list
  List<MdHallOfFame> hallOfFameList = <MdHallOfFame>[
    MdHallOfFame(
      id: '1',
      name: 'Bronze',
      description: 'Everyone starts here',
      imageUrl: AppImages.bronze,
      isActive: true,
    ),
    MdHallOfFame(
      id: '2',
      name: 'Silver',
      description: 'Top 50%',
      imageUrl: AppImages.silverBadge,
      isActive: true,
    ),
    MdHallOfFame(
      id: '3',
      name: 'Gold',
      description: 'Top 25%',
      imageUrl: AppImages.goldBadge,
      isActive: true,
      isCurrent: true,
    ),
    MdHallOfFame(
      id: '4',
      name: 'Platinum',
      description: 'Top 10%',
      imageUrl: AppImages.platinumBadge,
      isActive: false,
    ),
    MdHallOfFame(
      id: '5',
      name: 'Icon',
      description: 'Elite 5%',
      imageUrl: AppImages.iconBadge,
      isActive: false,
    ),
    MdHallOfFame(
      id: '5',
      name: 'BDE',
      description: 'Only legends',
      imageUrl: AppImages.bdeBadge,
      isActive: false,
    ),
  ];
}
