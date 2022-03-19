class ApiLink {
  static String baseurl = "https://staging-api.huzz.africa//api/v1/";
  static String v2baseurl = "https://staging-api.huzz.africa//api/v2/";
// ignore: non_constant_identifier_names
  static String send_smsOtp = v2baseurl + "otp/send/sms";
// ignore: non_constant_identifier_names
  static String send_voiceOtp = v2baseurl + "otp/send/voice";
// ignore: non_constant_identifier_names
  static String verify_otp = baseurl + "otp/verify";
// ignore: non_constant_identifier_names
  static String signup_user = baseurl + "auth/signup";
// ignore: non_constant_identifier_names
  static String signin_user = baseurl + "auth/login";

  static String getUser = baseurl + "user/me";
// ignore: non_constant_identifier_names
  static String create_business = baseurl + "business";
  // ignore: non_constant_identifier_names
  static String update_business = baseurl + "business/";
// ignore: non_constant_identifier_names
  static String get_user_business = baseurl + "business";
// ignore: non_constant_identifier_names
  static String get_business_transaction = baseurl + "business/transactions";
// ignore: non_constant_identifier_names
  static String update_profile = baseurl + "user/update-profile";
  // ignore: non_constant_identifier_names
  static String dashboard_overview = baseurl + "business/transactions/overview";
  static String addCustomer = baseurl + "business/customer";
// ignore: non_constant_identifier_names
  static String upload_file = baseurl + "file-store/upload";
// ignore: non_constant_identifier_names
  static String get_business_product = baseurl + "business/product";
// ignore: non_constant_identifier_names
  static String add_product = baseurl + "business/product";
// ignore: non_constant_identifier_names
  static String get_business_customer = baseurl + "business/customer";
// ignore: non_constant_identifier_names
  static String add_customer = baseurl + "business/customer";
// ignore: non_constant_identifier_names
  static String add_bank_info = baseurl + "bank-info";
// ignore: non_constant_identifier_names
  static String add_debtor = baseurl + "business/debtor";
// ignore: non_constant_identifier_names
  static String forget_pin = baseurl + "user/forgot-pin";
// ignore: non_constant_identifier_names
  static String invoice_link = baseurl + "business/invoice";
  // ignore: non_constant_identifier_names
  static String delete_user = baseurl + "user/delete";
  // ignore: non_constant_identifier_names

  // ignore: non_constant_identifier_names
  static String delete_business = baseurl + "business/";

  static String miscellaneous = baseurl + "miscellaneous";
}
