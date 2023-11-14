import 'dart:io';

import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/user/signin-google.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:digimartbox/src/environment/environment.dart';

class UserProvider extends GetConnect {
  User userSession = User.fromJson(GetStorage().read(Constants.storageUserSession) ?? {});

  Future<Response> create(User user) async {
    return createUserOutImage(user);
  }

  Future<Response> update(User user, File? image) async {
    if (image != null) {
      return updateUserWithImage(user, image);
    }

    return updateUserOutImage(user);
  }

  Future<Response> updateUserOutImage(User user) async {
    Response response = await patch(
        '${Environment.urlUser}/${user.idUser}',
        user.toJson(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    return response;
  }

  Future<Response> updateUserWithImage(User user, File image) async {
    FormData form =  FormData({
      'image': MultipartFile(image, filename: basename(image.path)),
      'firstName': user.firstName,
      'lastName': user.lastName,
      'phone': user.phone,
      'dni': user.dni,
    });

    Response response = await patch(
        '${Environment.urlUser}/${user.idUser}',
        form,
        headers: {
          'Authorization': 'Bearer ${userSession.token}'
        }
    );
    return response;
  }

  Future<Response> createUserOutImage(User user) async {
    Response response = await post(
        Environment.urlAuth,
        {
          'password': user.password,
          'confirmationPassword': user.confirmationPassword,
          'phone': user.phone,
          'email': user.email,
          'emailSponsor': user.emailSponsor,
        },
        headers: Environment.headers
    );

    return response;
  }

  Future<Response> createUserWithImage(User user, File image, String codeEmail) async {
    FormData form =  FormData({
      'image': MultipartFile(image, filename: basename(image.path)),
      'firstName': user.firstName,
      'lastName': user.lastName,
      'password': user.password,
      'confirmationPassword': user.confirmationPassword,
      'phone': user.phone,
      'email': user.email,
      'codeEmail': codeEmail,
    });

    Response response = await post(Environment.urlAuth, form);
    return response;
  }
  
  Future<Response> login(String email, String password) async {
    Response response = await post(
        '${Environment.urlAuth}/login',
        {
          'email': email,
          'password': password,
        },
        headers: Environment.headers
    );

    return response;
  }

  Future<Response> signInWithGoogle(SignInGoogle signInGoogle) async {
    Response response = await post(
        '${Environment.urlAuth}/signin-google',
        signInGoogle.toJson(),
        headers: Environment.headers
    );

    return response;
  }

  Future<Response> verifyEmail(String email) async {
    Response response = await get(
        '${Environment.urlAuth}/verify-email/$email',
        headers: Environment.headers
    );

    return response;
  }

  Future<List<User>> findGuestByUser() async {
    Response response = await get(
        '${Environment.urlUser}/guest-users/${userSession.idUser}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    List<User> values = User.fromJsonList(response.body);

    return values;
  }

  Future<Response> findCommissionByUser() async {
    Response response = await get(
        '${Environment.urlCommission}/${userSession.idUser}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userSession.token}'
        }
    );

    return response;
  }

}