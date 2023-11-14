class Environment {
  static const String apiUrl = "http://192.168.1.34:3069/";
  static const String apiVersion = 'api/v1';
  static const String urlUser = '$apiUrl$apiVersion/users';
  static const String urlAuth = '$apiUrl$apiVersion/auth';
  static const String urlProduct = '$apiUrl$apiVersion/products';
  static const String urlSupermarket = '$apiUrl$apiVersion/supermarket';
  static const String urlUbication = '$apiUrl$apiVersion/ubication';
  static const String urlCommission = '$apiUrl$apiVersion/commission';
  static const String urlOrder = '$apiUrl$apiVersion/order';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}