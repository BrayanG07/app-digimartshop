import 'package:digimartbox/src/models/user/user.dart';
import 'package:digimartbox/src/providers/user_provider.dart';
import 'package:get/get.dart';

class ClientGuestListController extends GetxController {
  List<User> users = [];
  UserProvider userProvider = UserProvider();

  var radioValue = 0.obs;

  Future<List<User>> getGuests() async {
    users = await userProvider.findGuestByUser();

    return users;
  }
}