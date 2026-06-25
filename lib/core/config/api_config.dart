class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://dreambaby.pro';
  static const String apiBase = '$baseUrl/api';
  static const String storageBase = '$baseUrl/storage';

  /// Builds a full storage URL from a relative path or returns [path] if already absolute.
  static String storageUrl(String? path) {
    if (path == null || path.isEmpty || path == 'null') return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final normalized = path.startsWith('/') ? path.substring(1) : path;
    return '$storageBase/$normalized';
  }

  // Auth
  static const String login = '$apiBase/auth/login';
  static const String sendOtp = '$apiBase/auth/send-otp';
  static const String verifyOtp = '$apiBase/auth/verify-otp';
  static const String registerInitial = '$apiBase/auth/register-initial';
  static const String completeRegistration = '$apiBase/auth/complete-registration';
  static const String registerSkip = '$apiBase/auth/register/skip';
  static const String forgotPassword = '$apiBase/auth/forgot-password';
  static const String resetPassword = '$apiBase/auth/reset-password';
  static const String deleteAccount = '$apiBase/auth/delete-account';

  // User & profile
  static const String profile = '$apiBase/profile';
  static const String updateProfile = '$apiBase/update-profile';
  static const String babyData = '$apiBase/baby_data';
  static const String activeUser = '$apiBase/active_user';

  // Questions & activities
  static const String questions = '$apiBase/questions';
  static const String userAnswer = '$apiBase/user_answer';
  static const String userQuestionStatus = '$apiBase/user-question-status';
  static const String questionsStatusToday = '$apiBase/questions/status/today';

  // Content
  static const String staticData = '$apiBase/static_data';
  static const String getTestimonials = '$apiBase/get_testimonials';
  static const String testimonials = '$apiBase/testimonials';

  // Notifications
  static String notifications({required int page}) =>
      '$apiBase/notifications?page=$page';

  static String notificationRead(int notificationId) =>
      '$apiBase/notifications/$notificationId/read';

  static const String notificationsReadAll = '$apiBase/notifications/read-all';
  static const String notificationsUnreadCount =
      '$apiBase/notifications/unread-count';

  static String deleteAccountForUser(int userId) =>
      '$apiBase/auth/delete-account/$userId';
}
