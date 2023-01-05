import 'dart:convert';

import 'business.dart';


class OfflineBusiness {
  String? businessId;
  Business? business;
  String? userId;
  OfflineBusiness({this.businessId, this.business});
  factory OfflineBusiness.fromJson(Map<String, dynamic> json) =>
      OfflineBusiness(
          businessId: json['BusinessId'],
          business: Business.fromJson(jsonDecode(json['BusinessJson'])));

  Map<String, dynamic> toJson() {
    return {
      "BusinessId": businessId,
      "BusinessJson": jsonEncode(business!.toJson()),
    };
  }
}
