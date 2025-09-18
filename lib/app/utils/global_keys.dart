import 'package:get/get.dart';

import '../data/models/md_user.dart';
import '../modules/profile/models/md_profile.dart';

/// Current round observable
Rx<Round> roundData = Rx<Round>(Round());

/// Current user observable
Rx<MdUser> globalUser = Rx<MdUser>(MdUser());

