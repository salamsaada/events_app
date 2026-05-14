class EndPoint {
  static const String baseUrl = "http://192.168.1.102:8000/api/"; 
  // static const String baseUrl = "http://10.0.2.2:8000/api/";
  // static const String baseUrl = "http://127.0.0.1:8000/api/";

  static const String signIn = "login";
  static const String signUp = "register";

  static const String getUserDataEndPoint = "user";
}

class ApiKey {
  static const String status = "status";
  static const String errorMessage = "ErrorMessage";
  static const String email = "email";
  static const String password = "password";

  static const String token = "access_token";
  static const String accessToken = "access_token";
  static const String tokenType = "token_type";

  static const String message = "message";
  static const String id = "id";
  static const String name1 = "first_name";
  static const String name2 = "last_name";

  static const String phone = "phone";

  // لارافل يتوقع حقل تأكيد كلمة المرور بهذا الاسم بالتحديد
  static const String confirmPassword = "password_confirmation";

  static const String location = "location";
  static const String profilePic = "profilePic";
}
