import 'package:hexcolor/hexcolor.dart';

class Constants {
  // KEY PARA EL ALMACENAMIENTO LOCAL
  static const String storageUserSession = 'USER_SESSION';
  static const String storageSupermarketUser = 'ID_SUPERMARKET';
  static const String storageShoppingBag = 'SHOPPING_BAG';
  static const String storageAddress = 'ADDRESS';

  // ESTRUCTURA DE ESPUESTA API
  static const String responseApiData = 'data';
  static const String responseApiError = 'message';

  // ROLES USER
  static const String roleClient = 'CLIENTE';
  static const String roleDelivery = 'REPARTIDOR';

  // DISTANCIA VALIDA
  static const double distanceValidSupermarket = 50; // KM - Kilometros

  // COLORES
  static final HexColor colorPrimary = HexColor('#0891B2');
  static final HexColor colorSecondary = HexColor('#128192');
  static final HexColor colorGreenPrimary = HexColor('#9BEF1B');
  static final HexColor colorGreyBackground = HexColor('#FFEDECF2');
  static final HexColor colorBackgroundCardCredit = HexColor('#218197');

  // GOOGLE
  static const String apiKeyMaps = '';

  // PAYMENT_TYPE
  static const String paymentTypeCash = 'CASH';
  static const String paymentTypeCard = 'CREDIT_DEBIT_CARD';

  // STATUS_ORDER
  static const String statusOrderDelivered = 'ENTREGADO';
  static const String statusOrderSend = 'ENVIADO';
  static const String statusOrderPending = 'PENDIENTE';
  static const String statusOrderPreparing = 'PREPARANDO';
  static const String statusOrderCanceled = 'CANCELADO';
}
