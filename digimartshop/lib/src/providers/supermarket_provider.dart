import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/supermarket/department.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:digimartbox/src/environment/environment.dart';

class SupermarketProvider extends GetConnect {
  User userSession = User.fromJson(GetStorage().read(Constants.storageUserSession) ?? {});

  Future<List<Department>> listAllDepartments() async {
    Response response = await get(
        '${Environment.urlSupermarket}/departments',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    List<Department> values = Department.fromJsonList(response.body);

    return values;
  }

}