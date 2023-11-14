import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/models/order/order_list_user.dart';
import 'package:digimartbox/src/pages/client/orders/list/client_orders_list_controller.dart';
import 'package:digimartbox/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ClientOrdersListPage extends StatelessWidget {
  ClientOrdersListPage({Key? key}) : super(key: key);
  final ClientOrdersListController con = Get.put(ClientOrdersListController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: con.listStatus.length,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              bottom: TabBar(
                onTap: (index) => con.selectedTabIndex.value = index,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                isScrollable: true,
                indicatorColor: Constants.colorGreenPrimary,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                tabs: List<Widget>.generate(con.listStatus.length, (index) {
                  return Tab(
                    child: Text(con.listStatus[index]),
                  );
                }),
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            color: Constants.colorGreyBackground,
            child: Obx(() {
              final selectedValue = con.listStatus[con.selectedTabIndex.value];
              return FutureBuilder<List<OrderListUser>>(
                  future: con.getOrderByStatus(selectedValue),
                  builder:
                      (context, AsyncSnapshot<List<OrderListUser>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardOrder(snapshot.data![index]);
                            });
                      } else {
                        return NoDataWidget(textMessage: 'No hay ordenes');
                      }
                    } else {
                      return NoDataWidget(textMessage: 'No hay ordenes');
                    }
                  });
            }),
          )),
    );
  }

  Widget _cardOrder(OrderListUser order) {
    return GestureDetector(
      onTap: () => con.goToOrderDetail(order),
      child: Column(
        children: [
          Container(
            height: 105,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(
                      0, 1), // Desplazamiento en horizontal y vertical
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                          color: HexColor(con.getColorByStatus(order.status)),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                        height: 55,
                        width: 55,
                        margin: const EdgeInsets.only(right: 15),
                        child: Image.asset('assets/img/order_icon.png')),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            order.supermarket.name,
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                          Text(
                            '#${order.idOrder.split('-')[0].toUpperCase()}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                          Text(
                            'L. ${order.total} - ${con.getQuantityProducts(order)} productos',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[800]),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
