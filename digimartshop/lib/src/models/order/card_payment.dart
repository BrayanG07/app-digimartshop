import 'dart:convert';

CardPayment cardPaymentFromJson(String str) => CardPayment.fromJson(json.decode(str));

String cardPaymentToJson(CardPayment data) => json.encode(data.toJson());

class CardPayment {
  String cardName;
  String cardNumber;
  String cardCvv;
  String monthCard;
  String yearCard;

  CardPayment({
    required this.cardName,
    required this.cardNumber,
    required this.cardCvv,
    required this.monthCard,
    required this.yearCard,
  });

  factory CardPayment.fromJson(Map<String, dynamic> json) => CardPayment(
    cardName: json["cardName"],
    cardNumber: json["cardNumber"],
    cardCvv: json["cardCvv"],
    monthCard: json["monthCard"],
    yearCard: json["yearCard"],
  );

  Map<String, dynamic> toJson() => {
    "cardName": cardName,
    "cardNumber": cardNumber,
    "cardCvv": cardCvv,
    "monthCard": monthCard,
    "yearCard": yearCard,
  };
}
