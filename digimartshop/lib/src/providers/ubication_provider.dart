import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/ubication/ubication.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:digimartbox/src/environment/environment.dart';

class UbicationProvider extends GetConnect {
  User userSession = User.fromJson(GetStorage().read(Constants.storageUserSession) ?? {});

  Future<List<Ubication>> listUbicationByIdUser() async {
    Response response = await get(
        '${Environment.urlUbication}/${userSession.idUser}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    List<Ubication> values = Ubication.fromJsonList(response.body);

    return values;
  }

  Future<Response> create(Ubication ubication) async {
    ubication.idUser = userSession.idUser;

    Response response = await post(
        Environment.urlUbication,
        ubication.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    return response;
  }

}