// ignore_for_file: non_constant_identifier_names

class ApiLink {
  static String baseurl = "https://staging-api.huzz.africa//api/v1/";
  static String v2baseurl = "https://staging-api.huzz.africa//api/v2/";
  static String sendSmsOtp = v2baseurl + "otp/send/sms";

  static String sendVoiceOtp = v2baseurl + "otp/send/voice";
  static String verifyOtp = baseurl + "otp/verify";
  static String signupUser = baseurl + "auth/signup";
  static String signinUser = baseurl + "auth/login";
  static String getUser = baseurl + "user/me";
  static String createBusiness = baseurl + "business";
  static String updateBusiness = baseurl + "business/";
  static String getUserBusiness = baseurl + "business";
  static String getBusinessTransaction = baseurl + "business/transactions";
  static String updateProfile = baseurl + "user/update-profile";
  static String dashboardOverview = baseurl + "business/transactions/overview";
  static String addCustomer = baseurl + "business/customer";
  static String uploadFile = baseurl + "file-store/upload";
  static String getBusinessProduct = baseurl + "business/product";
  static String addProduct = baseurl + "business/product";
  static String getBusinessCustomer = baseurl + "business/customer";
  static String add_customer = baseurl + "business/customer";
  static String addBankInfo = baseurl + "bank-info";
  static String addDebtor = baseurl + "business/debtor";
  static String forgetPin = baseurl + "user/forgot-pin";
  static String invoiceLink = baseurl + "business/invoice";
  static String deleteUser = baseurl + "user/delete";
  static String userReferral = baseurl + "user/referral";
  static String deleteBusiness = baseurl + "business/";
  static String miscellaneous = baseurl + "miscellaneous";
  static String createTeam = baseurl + 'business/team/';
  static String getTeamMember = baseurl + 'business/team-member/all';
  static String getTeamMemberData = baseurl + 'business/team-member';
  static String inviteTeamMember = baseurl + 'business/team-member';
  static String updateInviteTeamStatus = baseurl + 'business/team-member';
  static String deleteTeamMember = baseurl + 'business/team-member';
}
