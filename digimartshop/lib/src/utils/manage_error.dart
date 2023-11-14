import 'package:digimartbox/src/constants/constants.dart';
import 'package:get/get.dart';

class ManageError {
  static String getErrorMessage(Response response) {
    var message = response.body[Constants.responseApiError];

    if (message is List) {
      // Si es una lista, devolvemos el primer elemento
      return message[0];
    } else if (message is String) {
      // Si es una cadena de texto, devolvemos la cadena tal cual
      return message;
    } else {
      // Si es algo inesperado, lanzamos un error
      return 'Se produjo un error inesperado, lo sentimos';
    }
  }
}