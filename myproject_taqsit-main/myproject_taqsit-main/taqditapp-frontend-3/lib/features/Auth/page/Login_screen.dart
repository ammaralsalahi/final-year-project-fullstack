
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:installment/features/Auth/bloc/auth_bloc.dart';
import 'package:installment/features/Auth/bloc/auth_event.dart';
import 'package:installment/features/Auth/bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  static const Color _primary = Color(0xFF123746);
  static const Color _primaryLight = Color(0xFF205466);
  static const Color _gold = Color(0xFFDDBB69);
  static const Color _background = Color(0xFFF3F6FA);
  static const Color _textColor = Color(0xFF1B3440);
  static const Color _mutedColor = Color(0xFF7B8B96);

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF258568),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            );

            context.go('/mainPage');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: const Color(0xFFC44747),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFF8FAFC),
                        Color(0xFFEAF0F5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 290,
                  height: 290,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _gold.withOpacity(0.13),
                  ),
                ),
              ),

              Positioned(
                bottom: -120,
                left: -100,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _primaryLight.withOpacity(0.07),
                  ),
                ),
              ),

              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compactHeight =
                        constraints.maxHeight < 620;

                    final horizontalPadding =
                        constraints.maxWidth < 360 ? 14.0 : 22.0;

                    final verticalPadding =
                        compactHeight ? 12.0 : 24.0;

                    return SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              (constraints.maxHeight -
                                      verticalPadding * 2)
                                  .clamp(0.0, double.infinity),
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 440,
                            ),
                            child: _buildCard(
                              state,
                              compactHeight: compactHeight,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(
    AuthState state, {
    bool compactHeight = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFE5EBF0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // رأس البطاقة
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 22,
                vertical: compactHeight ? 20 : 30,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF123746),
                    Color(0xFF205466),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: _buildHeader(
                compactHeight: compactHeight,
              ),
            ),

            // محتوى البطاقة
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 22,
                vertical: compactHeight ? 20 : 28,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'بيانات الحساب',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'أدخل بياناتك للمتابعة إلى حسابك',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: _mutedColor,
                        fontSize: 13,
                        height: 1.7,
                      ),
                    ),

                    SizedBox(height: compactHeight ? 18 : 25),

                    _buildTextField(
                      controller: _phoneController,
                      label: 'رقم الهاتف',
                      icon: Icons.phone_iphone_rounded,
                      iconColor: _primaryLight,
                    ),

                    const SizedBox(height: 18),

                    _buildTextField(
                      controller: _passwordController,
                      label: 'كلمة المرور',
                      icon: Icons.lock_outline_rounded,
                      iconColor: _primaryLight,
                      isPassword: true,
                    ),

                    SizedBox(height: compactHeight ? 22 : 30),

                    _buildButton(state),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          size: 17,
                          color: Color(0xFF258568),
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            'تجربة سهلة ومريحة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    bool compactHeight = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compactHeight ? 54 : 66,
          height: compactHeight ? 54 : 66,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _gold.withOpacity(0.8),
              width: 1.3,
            ),
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            size: compactHeight ? 28 : 34,
            color: _gold,
          ),
        ),

        SizedBox(height: compactHeight ? 12 : 18),

        const Text(
          'تسجيل الدخول',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.1,
          ),
        ),

        const SizedBox(height: 9),

        const Text(
          'مرحباً بعودتك، يسعدنا وجودك مجدداً',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.8,
            color: Color(0xFFD5E3E9),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          width: 42,
          height: 3,
          decoration: BoxDecoration(
            color: _gold,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(AuthState state) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _primary.withOpacity(0.7),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: state is AuthLoading ? null : _submitForm,
        child: state is AuthLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: _gold,
                  strokeWidth: 2.5,
                ),
              )
            : const FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_back_rounded,
                      color: _gold,
                      size: 21,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Color iconColor = const Color(0xFF547484),
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: _textColor,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: _mutedColor,
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: _primaryLight,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
        filled: true,
        fillColor: const Color(0xFFF7F9FB),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 19,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFE1E8EE),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFE1E8EE),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: _primaryLight,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
