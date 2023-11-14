import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/client/address/list/client_address_list_page.dart';
import 'package:digimartbox/src/pages/client/home/client_home_controller.dart';
import 'package:digimartbox/src/pages/client/orders/list/client_orders_list_page.dart';
import 'package:digimartbox/src/pages/client/products/list/client_products_list_page.dart';
import 'package:digimartbox/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ClientHomePage extends StatelessWidget {
  ClientHomePage({Key? key}) : super(key: key);
  final ClientHomeController clientController = Get.put(ClientHomeController());
  final List<Widget> pages = [
    ClientProductsListPage(),
    ClientAddressListPage(),
    ClientOrdersListPage(),
    ClientProfileInfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.colorGreyBackground,
        bottomNavigationBar: _bottomBar(),
        body: Obx(() => pages[clientController.indexTab.value]),
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
          Icon(Icons.location_on, size: 30, color: Colors.white),
          Icon(Icons.shopping_bag, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ]
    );
  }
}