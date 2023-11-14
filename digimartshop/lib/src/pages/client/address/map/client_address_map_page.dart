import 'package:digimartbox/src/pages/client/address/map/client_address_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientAddressMapPage extends StatelessWidget {

  ClientAddressMapPage({Key? key}) : super(key: key);
  final ClientAddressMapController controller = Get.put(ClientAddressMapController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        title: const Text(
          'Ubica tu dirección en el mapa',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          _googleMaps(),
          _iconMyLocation(),
          _cardAddress(),
          _buttonAccept(context)
        ],
      ),
    ));
  }

  Widget _buttonAccept(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 30),
      child: ElevatedButton(
        onPressed: () => controller.selectRefPoint(context),
        child: Text(
          'SELECCIONAR ESTE PUNTO',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          padding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _cardAddress() {
    return Container(
      width: double.infinity, // OCUPAR TODA LA PANTALLA A LO ANCHO
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            controller.addressName.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconMyLocation() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Center(
        child: Image.asset(
          'assets/img/my_location.png',
          width: 62,
          height: 62,
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
        onCameraMove: (position) {
          controller.initialPosition = position;
        },
        onCameraIdle: () async {
          await controller.setLocationDraggableInfo(); // EMPEZAR A OBTENER LA LAT Y LONGITUDE DE LA POSICION CENTRAL DEL MAPA
        },
    );
  }
}
