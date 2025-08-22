import 'dart:async';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/models/md_user_selfie.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/config/app_images.dart';
import 'dart:math';

import '../repositories/socket_io_repo.dart';

/// Snap Selfies Controller
class SnapSelfiesController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      round.value = Get.arguments as MdRound;
      round.refresh();
    }

    socketIoRepo
      ..initSocket(url: 'http://192.168.29.28:7800')
      ..listenForDateEvent(
        (dynamic data) {
          logI('🎯 Controller got update: $data');
          dataList.add(data.toString());
        },
      )
      ..startAutoEmit(
        {
          'user_id': SupaBaseService.userId,
          'round_id': round().id,
        },
      );

    setUsers();
    super.onInit();
  }

  /// Call emit with custom payload
  void emitDate() {
    final Map<String, dynamic> payload = <String, dynamic>{
      'user_id': SupaBaseService.userId,
      'round_id': round().id,
    };

    logI('👉 Calling emitDate() with payload: $payload');
    socketIoRepo.emitGetDate(payload);
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
    socketIoRepo.dispose();
    super.onClose();
  }

  /// Observable for bet text
  Rx<MdRound> round = MdRound().obs;

  /// Seconds left for the timer
  RxInt secondsLeft = 300.obs;

  /// Timer for countdown
  Timer? _timer;

  /// Current index for texts
  RxInt currentIndex = 0.obs;

  /// Timer for texts
  Timer? _textsTimer;

  /// Indicates if all selfies are taken
  RxBool isTimesUp = false.obs;

  /// Socket IO repository
  final SocketIoRepo socketIoRepo = SocketIoRepo();

  /// List of data (for testing purposes)
  final RxList<String> dataList = <String>[].obs;

  /// List of selfies taken by the user
  RxList<MdUserSelfie> selfies = <MdUserSelfie>[].obs;

  /// Get selfies
  RxBool get isCurrentUserSelfieTaken => selfies()
      .any((MdUserSelfie selfie) =>
          selfie.id == 'current_user' && selfie.selfieUrl != null)
      .obs;

  /// Set users
  Future<void> setUsers() async {
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
      )
      ..refresh();

    final List<String> picsumUrls = <String>[
      'https://picsum.photos/id/237/200/300',
      'https://picsum.photos/seed/picsum/200/300',
      'https://picsum.photos/200/300?grayscale',
      'https://picsum.photos/200',
      'https://picsum.photos/200/300',
    ];

    final Random random = Random();

    for (int i = 0; i < 10; i++) {
      Timer(
        Duration(seconds: 5 * (i + 1)),
        () {
          final String imageUrl = picsumUrls[random.nextInt(picsumUrls.length)];

          selfies
            ..add(
              MdUserSelfie(
                id: 'user_${DateTime.now().millisecondsSinceEpoch}',
                displayName: 'User_${random.nextInt(10000)}',
                userId: 'user_${i + 1}',
                selfieUrl: imageUrl,
                createdAt: DateTime.now(),
              ),
            )
            ..refresh();

          logI('Added selfie $i -> $imageUrl');
        },
      );
    }
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
          if (selfies().isNotEmpty && selfies().length > 3) {
            isTimesUp(true);
          } else {
            Get.back();
            appSnackbar(
              message: 'Time is up! Please start again.',
              snackbarState: SnackbarState.danger,
            );
          }

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
          final MdUserSelfie? currentUser = selfies().firstWhereOrNull(
            (MdUserSelfie selfie) => selfie.id == 'current_user',
          );
          if (currentUser != null) {
            currentUser
              ..selfieUrl = 'https://picsum.photos/seed/picsum/200/300'
              ..assetImage = null;
            selfies.refresh();
          }

          setUpTextTimer();
        }
      },
    );
  }

  /// On let go action
  void onLetGo() {
    final List<MdUserSelfie> _selfies = selfies()
        .where((MdUserSelfie selfie) =>
            selfie.selfieUrl != null && selfie.selfieUrl!.isNotEmpty)
        .toList();

    Get.toNamed(
      Routes.AI_CHOOSING,
      arguments: <String, dynamic>{
        'selfies': _selfies,
        'bet': round().prompt ?? '',
      },
    );
  }

  /// Share uri
  void shareUri() {
    final Uri uri = Uri.parse('https://example.com/some-page');

    SharePlus.instance.share(
      ShareParams(
        uri: uri,
        title: 'Slay Crew',
        subject: 'Slay Crew Invitation',
      ),
    );
  }
}
