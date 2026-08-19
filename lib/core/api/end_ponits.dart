class EndPoint {
  // static const String baseUrl = "https://preflight-refusal-luminous.ngrok-free.dev/api/";
  static const String baseUrl = "http://192.168.1.105:8000/api/";
  static const String getProviderReviews =
      "providers"; // يجب إضافة هذا الـ Endpoint في كلاس EndPoint
  static const String signIn = "login";
  static const String signUp = "register";
  static const String getlisting =
      "listings"; // يجب إضافة هذا الـ Endpoint في كلاس EndPoint
  static const String getUserDataEndPoint = "user";
  static const String Mybookings = "bookings";
  static const String createBooking = "bookings";
  static const String cancelBooking = "bookings";
  static const String sendReview =
      "reviews/provider"; // يجب إضافة هذا الـ Endpoint في كلاس EndPoint
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

  static const String currentPage = 'current_page';
  static const String lastPage = 'last_page';
  static const String total = 'total';
  static const String title = 'title';
  static const String description = 'description';
  static const String type = 'type';
  static const String material_composition = 'material_composition';
  static const String secondary_contact_number = 'secondary_contact_number';
  static const String cancel_before_acceptance = 'cancel_before_acceptance';
  static const String cancel_after_acceptance = 'cancel_after_acceptance';
  static const String cancel_before_payment = 'cancel_before_payment';
  static const String is_provider_location_based = 'is_provider_location_based';
  static const String rejection_reason = 'rejection_reason';
  static const String category = 'category';
  static const String district = 'district';
  static const String images = 'images';
  static const String variants = 'variants';
  static const String created_at = 'created_at';
  static const String updated_at = 'updated_at';
  static const String price = 'price';
  static const String currency = 'currency';
  static const String price_type = 'price_type';
  static const String stock = 'stock';
  static const String attributes = 'attributes';
  static const String availabilities = 'availabilities';
  static const String available_date = 'available_date';
  static const String is_blocked = 'is_blocked';
  static const String slots = 'slots';
  static const String start_time = 'start_time';
  static const String end_time = 'end_time';
  static const String remaining_capacity = 'remaining_capacity';
  static const String meta = 'meta';
  static const String name = 'name';
  static const String success = 'success';
  static const String data = 'data';

  static const String listing = 'listing';
  static const String user_id = 'user_id';
  static const String provider_id = 'provider_id';
  static const String listing_id = 'listing_id';
  static const String listing_variant_id = 'listing_variant_id';
  static const String listing_slot_id = 'listing_slot_id';
  static const String booking_type = 'booking_type';
  static const String payment_status = 'payment_status';
  static const String quantity = 'quantity';
  static const String total_price = 'total_price';
  static const String booked_date = 'booked_date';
  static const String booked_start_time = 'booked_start_time';
  static const String booked_end_time = 'booked_end_time';
  static const String metadata = 'metadata';
  static const String customer_notes = 'customer_notes';

  static const String variant_name = 'variant_name';
  static const String event_type = 'event_type';
  static const String guest_count = 'guest_count';
  static const String setup_needs = 'setup_needs';
  static const String is_rental = 'is_rental';
  static const String rental_days = 'rental_days';
  static const String delivery_address = 'delivery_address';

  static const String lastBookingId = 'last_booking_id';
}
