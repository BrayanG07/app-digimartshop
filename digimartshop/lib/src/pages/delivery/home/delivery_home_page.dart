import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/delivery/home/delivery_home_controller.dart';
import 'package:digimartbox/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:digimartbox/src/pages/delivery/profile/delivery_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class DeliveryHomePage extends StatelessWidget {

  DeliveryHomePage({Key? key}) : super(key: key);
  final DeliveryHomeController clientController = Get.put(DeliveryHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.colorGreyBackground,
        bottomNavigationBar: _bottomBar(),
        body: Obx(() => IndexedStack(
          index: clientController.indexTab.value,
          children: [
            DeliveryOrdersListPage(),
            DeliveryProfilePage(),
          ],
        ))
    );
  }

  Widget _bottomBar() {
    return CurvedNavigationBar(
        height: 60,
        onTap: (index) => clientController.changeTab(index),
        backgroundColor: Colors.transparent,
        color: Constants.colorPrimary,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ]
    );
  }
}