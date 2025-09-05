import 'package:fvf_flutter/app/data/models/md_join_invitation.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:get/get.dart';

/// CrewStreakController
class CrewStreakController extends GetxController {

  /// List of participants
  List<MdParticipant> participants = <MdParticipant>[
    MdParticipant(
      selfieUrl: 'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGVyc29ufGVufDB8fDB8fHww',
      userData: RoundHost(
        username: 'User 1',
      ),
    ),
    MdParticipant(
      selfieUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cGVyc29ufGVufDB8fDB8fHww',
      userData: RoundHost(
        username: 'User 2',
      ),
    ),
    MdParticipant(
      selfieUrl: 'https://plus.unsplash.com/premium_photo-1678197937465-bdbc4ed95815?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cGVyc29ufGVufDB8fDB8fHww',
      userData: RoundHost(
        username: 'User 3',
      ),
    ),
    MdParticipant(
      selfieUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8cGVyc29ufGVufDB8fDB8fHww',
      userData: RoundHost(
        username: 'User 4',
      ),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
  }
}
