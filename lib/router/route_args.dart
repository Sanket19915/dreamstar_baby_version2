class OtpRouteArgs {
  final String phoneNumber;
  final Map<String, dynamic>? userModel;

  const OtpRouteArgs({
    required this.phoneNumber,
    this.userModel,
  });
}

class ForgotOtpRouteArgs {
  final String phoneNumber;
  final int? userId;

  const ForgotOtpRouteArgs({
    required this.phoneNumber,
    required this.userId,
  });
}
