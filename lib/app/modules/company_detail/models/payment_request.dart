import 'dart:convert';

PaymentRequest paymentRequestFromJson(String str) =>
    PaymentRequest.fromJson(json.decode(str));

String paymentRequestToJson(PaymentRequest data) => json.encode(data.toJson());

class PaymentRequest {
  String? bonus;
  String? deduction;
  String? status;
  String? paymentForMonth;

  PaymentRequest({
    this.bonus,
    this.deduction,
    this.status,
    this.paymentForMonth,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
        bonus: json["bonus"],
        deduction: json["deduction"],
        status: json["status"],
        paymentForMonth: json["payment_for_month"] == null
            ? ''
            : (json["payment_for_month"]),
      );

  Map<String, dynamic> toJson() => {
        "bonus": bonus,
        "deduction": deduction,
        "status": status,
        "payment_for_month":
            paymentForMonth
      };
}
