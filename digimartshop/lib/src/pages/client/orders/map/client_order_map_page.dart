import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/client/orders/map/client_order_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientOrdersMapPage extends StatelessWidget {
  ClientOrdersMapPage({Key? key}) : super(key: key);
  final ClientOrdersMapController controller = Get.put(ClientOrdersMapController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientOrdersMapController>(builder: (value) => Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.71,
              child: _googleMaps()
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buttonBack(),
                      _iconCenterLocation(),
                    ]
                ),
                const Spacer(),
                _cardOrderInfo(context),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buttonBack() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 10),
      child: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }

  Widget _iconCenterLocation() {
    return GestureDetector(
      onTap: () => controller.centerPosition(),
      child: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: const CircleBorder(),
          color: Colors.white,
          elevation: 4,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      initialCameraPosition: controller.initialPosition,
      mapType: MapType.normal,
      onMapCreated: controller.onMapCreate,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(controller.markers.values),
      // polylines: controller.polylines, // ES DE PAGA - MEJOR DESAHABILITADO EN DESARROLLO
    );
  }

  Widget _cardOrderInfo(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.29,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]
      ),
      child: Column(
          children: [
            _listTileAddress(
                controller.order.address,
                'Dirección de entrega',
                Icons.my_location
            ),
            _listTileAddress(
                controller.order.addressDetail,
                'Detalles de la dirección',
                Icons.location_on
            ),
            const Divider(color: Colors.grey, endIndent: 30, indent: 30),
            _deliveryInfo(),
          ]
      ),
    );
  }

  Widget _imageDelivery() {
    return SizedBox(
      height: 50,
      width: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FadeInImage(
          image: controller.order.userDelivery!.user.image != null
              ? NetworkImage(controller.order.userDelivery!.user.image)
              : const AssetImage('assets/img/user_profile.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 50),
          placeholder: const AssetImage('assets/img/user_profile.png'),
        ),
      ),
    );
  }

  Widget _deliveryInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          _imageDelivery(),
          const SizedBox(width: 10),
          Text(''
              '${controller.order.userDelivery!.user.firstName} ${controller.order.userDelivery!.user.lastName}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),
            maxLines: 1,
          ),
          const Spacer(),
          Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Constants.colorPrimary,
              ),
              child: IconButton(
                onPressed: () => controller.callNumber(),
                icon: const Icon(Icons.phone, color: Colors.white),
              )
          ),
        ],
      ),
    );
  }

  Widget _listTileAddress(String title, String subtitle, IconData iconData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(iconData, color: Constants.colorPrimary),
      ),
    );
  }
}
