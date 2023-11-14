import 'package:digimartbox/src/pages/delivery/orders/list/current/delivery_order_current_page.dart';
import 'package:digimartbox/src/pages/delivery/orders/list/delivery_orders_list_controller.dart';
import 'package:digimartbox/src/pages/delivery/orders/list/history/delivery_order_history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOrdersListPage extends StatelessWidget {
  DeliveryOrdersListPage({Key? key}) : super(key: key);
  final DeliveryOrdersListController deliveryController = Get.put(DeliveryOrdersListController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: deliveryController.listStatus.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            bottom: TabBar(
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelColor: Colors.black87,
                indicatorColor: Colors.white,
                tabs: List<Widget>.generate(deliveryController.listStatus.length, (index) {
                  return Tab(
                    child: Text(deliveryController.listStatus[index]),
                  );
                })
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            DeliveryOrderCurrentPage(),
            DeliveryOrderHistoryPage(),
            // TabTwo(),
          ],
        ),
      ),
    );
  }
}