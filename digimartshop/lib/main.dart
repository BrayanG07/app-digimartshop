import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

User userSession = User.fromJson(GetStorage().read(Constants.storageUserSession) ?? {});
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init(); // SIRVE PARA ALMACENAR DATOS EN EL STORAGE, COMO EL TOKEN
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String routeRedirect = _getRouteRedirect();

    return GetMaterialApp(
      title: 'DigimartShop',
      debugShowCheckedModeBanner: false,
      initialRoute: userSession.idUser != null ? routeRedirect : ConfigRoute.keyLogin,
      getPages: ConfigRoute.listRoutes,

      // CAMBIANDO LOS COLORES POR DEFECTO DE LA APLICACION
      theme: ThemeData(
        primaryColor: Constants.colorPrimary,
        colorScheme: ColorScheme(
          primary: Constants.colorPrimary,
          secondary: Constants.colorSecondary,
          brightness: Brightness.light,
          onBackground: Colors.grey,
          onPrimary: Colors.grey,
          surface: Colors.grey,
          onSurface: Colors.grey,
          background: Colors.grey,
          error: Colors.grey,
          onSecondary: Colors.grey,
          onError: Colors.grey,
        )
      ),
      navigatorKey: Get.key,
    );
  }

  String _getRouteRedirect () {
    String routeRedirect = '';

    if (userSession.role == Constants.roleClient) {
      String departmentSelect = GetStorage().read(Constants.storageSupermarketUser) ?? '';
      if (departmentSelect.isNotEmpty) {
        routeRedirect = ConfigRoute.keyClientHome;
      } else {
        routeRedirect = ConfigRoute.keyDepartment;
      }
    } else {
      routeRedirect = ConfigRoute.keyDeliveryHome;
    }

    return routeRedirect;
  }
}