import 'package:digimartbox/src/pages/client/orders/map/client_order_map_page.dart';
import 'package:get/get.dart';
import 'package:digimartbox/src/pages/client/address/create/client_address_create_page.dart';
import 'package:digimartbox/src/pages/client/address/list/client_address_list_page.dart';
import 'package:digimartbox/src/pages/client/address/select/client_address_select_page.dart';
import 'package:digimartbox/src/pages/client/department/department_info_page.dart';
import 'package:digimartbox/src/pages/client/email/client_email_verification_page.dart';
import 'package:digimartbox/src/pages/client/guests/client_guest_list_page.dart';
import 'package:digimartbox/src/pages/client/home/client_home_page.dart';
import 'package:digimartbox/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:digimartbox/src/pages/client/orders/detail/client_orders_detail_page.dart';
import 'package:digimartbox/src/pages/client/orders/list/client_orders_list_page.dart';
import 'package:digimartbox/src/pages/client/orders/overview/client_order_overview_page.dart';
import 'package:digimartbox/src/pages/client/payments/create/client_payments_create_page.dart';
import 'package:digimartbox/src/pages/client/payments/select/client_select_payment_type_page.dart';
import 'package:digimartbox/src/pages/client/products/list/client_products_list_page.dart';
import 'package:digimartbox/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:digimartbox/src/pages/client/profile/update/client_profile_update_page.dart';
import 'package:digimartbox/src/pages/delivery/home/delivery_home_page.dart';
import 'package:digimartbox/src/pages/delivery/orders/detail/delivery_orders_detail_page.dart';
import 'package:digimartbox/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:digimartbox/src/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:digimartbox/src/pages/delivery/profile/delivery_profile_page.dart';
import 'package:digimartbox/src/pages/login/login_page.dart';
import 'package:digimartbox/src/pages/register/register_page.dart';

class ConfigRoute {
  static const keyLogin = '/';
  static const keyRegister = '/register';
  static const keyDepartment = '/department';

  // ROUTES DELIVERY
  static const keyDeliveryHome = '/delivery/home';
  static const keyDeliveryOrderList = '/delivery/orders/list';
  static const keyDeliveryOrderDetail = '/delivery/orders/detail';
  static const keyDeliveryProfile = '/delivery/profile';
  static const keyDeliveryOrderMap = '/delivery/orders/map';

  // ROUTES CUSTOMER
  static const keyClientProductList = '/client/products/list';
  static const keyClientProfileInfo = '/client/profile/info';
  static const keyClientProfileUpdate = '/client/profile/update';
  static const keyClientHome = '/client/home';
  static const keyClientAddressCreate = '/client/address/create';
  static const keyClientAddressList = '/client/address/list';
  static const keyClientOrderList = '/client/orders/list';
  static const keyClientOrderCreate = '/client/orders/create';
  static const keyClientOrderOverview = '/client/order/overview';
  static const keyClientOrderDetail = '/client/orders/detail';
  static const keyClientOrderMap = '/client/orders/map';
  static const keyClientPaymentsCreate = '/client/payments/create';
  static const keyClientSelectPaymentType = '/client/select/payment/type';
  static const keyEmailVerification = '/email/verification';
  static const keySelectAddress = '/client/select/address';
  static const keyClientGuestsList= '/client/guests/list';

  static final List<GetPage<dynamic>> listRoutes = [
    GetPage(name: keyLogin, page: () => LoginPage()),
    GetPage(name: keyRegister, page: () => RegisterPage()),
    GetPage(name: keyDepartment, page: () => DepartmentInfoPage()),
    GetPage(name: keyClientProductList, page: () => ClientProductsListPage()),
    GetPage(name: keyClientProfileInfo, page: () => ClientProfileInfoPage()),
    GetPage(name: keyClientProfileUpdate, page: () => ClientProfileUpdatePage()),
    GetPage(name: keyClientHome, page: () => ClientHomePage()),
    GetPage(name: keyClientAddressCreate, page: () => ClientAddressCreatePage()),
    GetPage(name: keyClientAddressList, page: () => ClientAddressListPage()),
    GetPage(name: keyClientOrderList, page: () => ClientOrdersListPage()),
    GetPage(name: keyClientOrderCreate, page: () => ClientOrdersCreatePage()),
    GetPage(name: keyClientOrderOverview, page: () => ClientOrderOverviewPage()),
    GetPage(name: keyClientPaymentsCreate, page: () => ClientPaymentsCreatePage()),
    GetPage(name: keyClientSelectPaymentType, page: () => ClientSelectPaymentTypePage()),
    GetPage(name: keyClientOrderDetail, page: () => ClientOrdersDetailPage()),
    GetPage(name: keyClientOrderMap, page: () => ClientOrdersMapPage()),
    GetPage(name: keyEmailVerification, page: () => ClientEmailVerificationPage()),
    GetPage(name: keySelectAddress, page: () => ClientAddressSelectPage()),
    GetPage(name: keyClientGuestsList, page: () => ClientGuestListPage()),
    GetPage(name: keyDeliveryHome, page: () => DeliveryHomePage()),
    GetPage(name: keyDeliveryOrderList, page: () => DeliveryOrdersListPage()),
    GetPage(name: keyDeliveryProfile, page: () => DeliveryProfilePage()),
    GetPage(name: keyDeliveryOrderDetail, page: () => DeliveryOrdersDetailPage()),
    GetPage(name: keyDeliveryOrderMap, page: () => DeliveryOrdersMapPage()),
  ];
}