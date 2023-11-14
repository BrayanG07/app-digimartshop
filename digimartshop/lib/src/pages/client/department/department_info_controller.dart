import 'package:digimartbox/src/config/config_route.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/utils/alert_handler.dart';
import 'package:digimartbox/src/models/supermarket/department.dart';
import 'package:digimartbox/src/models/supermarket/supermarket.dart';
import 'package:digimartbox/src/providers/supermarket_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DepartmentInfoController extends GetxController {
  SupermarketProvider categoryProvider = SupermarketProvider();
  List<Department> departments = <Department>[].obs;
  Position? currentLocation;

  @override
  Future<void> onReady() async {
    super.onReady();
    await getAllDepartments();
    await _getCurrentLocation();
  }

  Future<void> getAllDepartments() async {
    var result  = await categoryProvider.listAllDepartments();
    departments.clear();
    departments.addAll(result);
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 
    
    currentLocation = await Geolocator.getCurrentPosition();
  }

  Future<void> getDepartmentSelected(Department department, BuildContext context) async {
    Supermarket? supermarket = findNearestSupermarket(department.supermarket);
    if (supermarket == null) {
      AlertHandler.getAlertWarning('Selecciona un departamento donde podamos cubrir tu pedido.');
    } else {
      GetStorage().write(Constants.storageSupermarketUser, supermarket.idSupermarket);
      Get.offNamed(ConfigRoute.keyClientHome);
    }
  }

  Supermarket? findNearestSupermarket(List<Supermarket> supermarkets) {
    if (currentLocation == null) return null;
    
    double minDistance = double.infinity;
    Supermarket? nearest;
    double distanceValid = Constants.distanceValidSupermarket * 1000;
    
    for (var supermarket in supermarkets) {
      final distance = Geolocator.distanceBetween(
        currentLocation!.latitude, 
        currentLocation!.longitude,
        double.parse(supermarket.latitude),
        double.parse(supermarket.longitude));
        
      if (distance < minDistance && distance < distanceValid) {
        minDistance = distance;
        nearest = supermarket;  
      }
    }
    
    return nearest;
  }
}