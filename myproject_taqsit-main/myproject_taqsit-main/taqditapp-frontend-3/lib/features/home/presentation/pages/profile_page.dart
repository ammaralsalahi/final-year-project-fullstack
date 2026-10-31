
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:installment/features/home/bloc/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/repository/home_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final HomeRepository _repository = HomeRepository();

  Future<Map<String, dynamic>>? _profileFuture;

  static const Color _primary = Color(0xFF123746);
  static const Color _primaryLight = Color(0xFF205466);
  static const Color _gold = Color(0xFFDDBB69);
  static const Color _background = Color(0xFFF3F6FA);
  static const Color _textColor = Color(0xFF1B3440);
  static const Color _mutedColor = Color(0xFF7B8B96);
  static const Color _borderColor = Color(0xFFE5EBF0);
  static const Color _green = Color(0xFF61D6A4);

  @override
  void initState() {
    super.initState();
    _profileFuture = _repository.getUserProfile();
  }

  Future<void> _refreshProfile() async {
    final future = _repository.getUserProfile();

    setState(() {
      _profileFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // تعرض FutureBuilder حالة الخطأ.
    }
  }

  Future<void> _logout() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

    if (!mounted) return;

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: _background,
          foregroundColor: _primary,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'الملف الشخصي والمالي',
            style: TextStyle(
              fontFamily: 'cairo',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: _primary,
            ),
          ),
        ),
        body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLoaded) {
              _refreshProfile();
            }
          },
          child: FutureBuilder<Map<String, dynamic>>(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              }

              if (snapshot.hasError) {
                return _buildErrorState();
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return _buildEmptyState();
              }

              final profileData = snapshot.data!;

              final String name =
                  profileData['full_name']?.toString() ?? 'مرحباً بك';
              final String email =
                  profileData['email']?.toString() ??
                      'لا يوجد بريد إلكتروني';
              final String phone =
                  profileData['phone_number']?.toString() ??
                      'لا يوجد رقم هاتف';
              final String accountNumber =
                  profileData['account_number']?.toString() ??
                      'لا يوجد رقم حساب';

              final double balance = double.tryParse(
                    profileData['balance']?.toString() ?? '0.0',
                  ) ??
                  0.0;

              final double maxLimit = double.tryParse(
                    profileData['max_credit_limit']?.toString() ?? '0.0',
                  ) ??
                  0.0;

              final int creditScore = int.tryParse(
                    profileData['credit_score']?.toString() ?? '0',
                  ) ??
                  0;

              return RefreshIndicator(
                color: _primary,
                onRefresh: _refreshProfile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildWelcomeHeader(name),
                          const SizedBox(height: 22),
                          _buildFinancialCard(
                            name: name,
                            phone: phone,
                            accountNumber: accountNumber,
                            balance: balance,
                            maxLimit: maxLimit,
                            creditScore: creditScore,
                          ),
                          const SizedBox(height: 28),
                          _buildSectionTitle(
                            'المعلومات الشخصية',
                            'بيانات حسابك المسجل',
                            Icons.person_outline_rounded,
                          ),
                          const SizedBox(height: 14),
                          _buildProfileInformation(
                            name: name,
                            email: email,
                            phone: phone,
                          ),
                          const SizedBox(height: 28),
                          _buildSectionTitle(
                            'إعدادات الحساب',
                            'إدارة الوصول إلى حسابك',
                            Icons.settings_outlined,
                          ),
                          const SizedBox(height: 14),
                          _buildAccountOptions(),
                          const SizedBox(height: 24),
                          _buildLogoutButton(),
                          const SizedBox(height: 18),
                          const Center(
                            child: Text(
                              'حسابك المالي في مكان واحد',
                              style: TextStyle(
                                fontFamily: 'cairo',
                                color: _mutedColor,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(String name) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_primary, _primaryLight],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: _primary.withOpacity(0.15),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أهلاً وسهلاً',
                style: TextStyle(
                  fontFamily: 'cairo',
                  color: _mutedColor,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'cairo',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: _primary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: _borderColor),
          ),
          child: const Icon(
            Icons.verified_user_outlined,
            color: _primaryLight,
            size: 23,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialCard({
    required String name,
    required String phone,
    required String accountNumber,
    required double balance,
    required double maxLimit,
    required int creditScore,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primary, _primaryLight],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.20),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -32,
            top: -35,
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                  width: 22,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: _gold,
                      size: 26,
                    ),
                  ),
                  const Spacer(),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'TAQSIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      ),
                      Text(
                        'حسابك المالي',
                        style: TextStyle(
                          color: Colors.white60,
                          fontFamily: 'cairo',
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'رقم الحساب',
                style: TextStyle(
                  fontFamily: 'cairo',
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              SelectableText(
                accountNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.09),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الرصيد الحالي',
                      style: TextStyle(
                        fontFamily: 'cairo',
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${balance.toStringAsFixed(2)} ريال',
                      style: const TextStyle(
                        fontFamily: 'cairo',
                        color: _green,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _buildFinancialValue(
                      title: 'الحد الائتماني',
                      value: '${maxLimit.toStringAsFixed(2)} ريال',
                      icon: Icons.credit_score_rounded,
                      valueColor: _gold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFinancialValue(
                      title: 'مؤشر الائتمان',
                      value: '$creditScore',
                      icon: Icons.shield_outlined,
                      valueColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white60,
                    size: 17,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'cairo',
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      phone,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialValue({
    required String title,
    required String value,
    required IconData icon,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _gold, size: 20),
          const SizedBox(height: 9),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'cairo',
              color: Colors.white60,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'cairo',
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: const Color(0xFFE7EEF2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: _primary, size: 23),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'cairo',
                  color: _textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'cairo',
                  color: _mutedColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInformation({
    required String name,
    required String email,
    required String phone,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileItem(
            icon: Icons.person_outline_rounded,
            title: 'الاسم الكامل',
            value: name,
          ),
          _buildItemDivider(),
          _buildProfileItem(
            icon: Icons.email_outlined,
            title: 'البريد الإلكتروني',
            value: email,
          ),
          _buildItemDivider(),
          _buildProfileItem(
            icon: Icons.phone_android_rounded,
            title: 'رقم الهاتف',
            value: phone,
          ),
        ],
      ),
    );
  }

  Widget _buildItemDivider() {
    return const Divider(
      height: 1,
      indent: 58,
      color: _borderColor,
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: _background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: _primaryLight, size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 11,
                    color: _mutedColor,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value,
                  style: const TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor),
      ),
      child: const ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: Icon(
          Icons.security_outlined,
          color: _primary,
          size: 30,
        ),
        title: Text(
          'أمان الحساب',
          style: TextStyle(
            fontFamily: 'cairo',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        subtitle: Text(
          'حافظ على سرية بيانات تسجيل الدخول',
          style: TextStyle(
            fontFamily: 'cairo',
            fontSize: 10,
            color: _mutedColor,
          ),
        ),
        trailing: Icon(
          Icons.verified_user_outlined,
          color: _primaryLight,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontFamily: 'cairo',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFCA4C4C),
          side: const BorderSide(
            color: Color(0xFFE9CACA),
          ),
          backgroundColor: const Color(0xFFFFF8F8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: _primary),
          SizedBox(height: 16),
          Text(
            'جاري تحميل بيانات حسابك...',
            style: TextStyle(
              fontFamily: 'cairo',
              color: _mutedColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_search_outlined,
              size: 62,
              color: _mutedColor,
            ),
            const SizedBox(height: 14),
            const Text(
              'لا توجد بيانات للمستخدم حالياً',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'cairo',
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _refreshProfile,
              icon: const Icon(Icons.refresh),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontFamily: 'cairo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEEE),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.cloud_off_outlined,
                size: 42,
                color: Color(0xFFCA4C4C),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'تعذر تحميل بيانات الملف الشخصي',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'cairo',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'تحقق من اتصال الإنترنت ثم حاول مرة أخرى.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'cairo',
                fontSize: 12,
                color: _mutedColor,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _refreshProfile,
              icon: const Icon(Icons.refresh),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontFamily: 'cairo'),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: _primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
