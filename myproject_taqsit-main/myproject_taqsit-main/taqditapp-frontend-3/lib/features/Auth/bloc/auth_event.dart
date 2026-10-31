abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  LoginEvent({required this.phoneNumber, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String billingAccount;

  RegisterEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.billingAccount,
  });
}
