
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installment/data/model/bank_model.dart';
import '../../../../data/repository/home_repository.dart';
import '../../bloc/home_bloc.dart';

class InstallmentsPage extends StatelessWidget {
  const InstallmentsPage({super.key});

  static const Color _primary = Color(0xFF123746);
  static const Color _primaryLight = Color(0xFF205466);
  static const Color _gold = Color(0xFFDDBB69);
  static const Color _background = Color(0xFFF3F6FA);
  static const Color _text = Color(0xFF1B3440);
  static const Color _muted = Color(0xFF7B8B96);
  static const Color _border = Color(0xFFE5EBF0);
  static const Color _green = Color(0xFF25845D);
  static const Color _red = Color(0xFFC74646);
  static const Color _blue = Color(0xFF2878D0);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: _background,
          appBar: AppBar(
            backgroundColor: _primary,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 20,
            toolbarHeight: 76,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سجل الأقساط والمالية',
                  style: TextStyle(
                    fontFamily: 'cairo',
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'تابع مدفوعاتك والتزاماتك بسهولة',
                  style: TextStyle(
                    fontFamily: 'cairo',
                    color: Color(0xFFD0E0E6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            actions: const [
              Padding(
                padding: EdgeInsetsDirectional.only(end: 20),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: _gold,
                  size: 29,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: _primary,
                  unselectedLabelColor: Colors.white70,
                  dividerColor: Colors.transparent,
                  labelStyle: const TextStyle(
                    fontFamily: 'cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: 'cairo',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  tabs: const [
                    Tab(
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.schedule_rounded, size: 18),
                          SizedBox(width: 6),
                          Flexible(child: Text('الأقساط المتبقية')),
                        ],
                      ),
                    ),
                    Tab(
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline_rounded, size: 18),
                          SizedBox(width: 6),
                          Flexible(child: Text('الأقساط المدفوعة')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading || state is HomeInitial) {
                return const Center(
                  child: CircularProgressIndicator(color: _primary),
                );
              }

              if (state is HomeLoaded) {
                final allInstallments = state.bankData.installments;

                final activeInstallments = allInstallments
                    .where((item) => !item.isPaid)
                    .toList();

                final paidInstallments = allInstallments
                    .where((item) => item.isPaid)
                    .toList();

                final activeTotal = activeInstallments.fold<double>(
                  0,
                  (sum, item) => sum + item.amount,
                );

                final paidTotal = paidInstallments.fold<double>(
                  0,
                  (sum, item) => sum + item.amount,
                );

                final lateCount = activeInstallments
                    .where((item) => item.isLate)
                    .length;

                return Column(
                  children: [
                    _buildOverview(
                      activeCount: activeInstallments.length,
                      paidCount: paidInstallments.length,
                      lateCount: lateCount,
                      activeTotal: activeTotal,
                      paidTotal: paidTotal,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildInstallmentList(
                            context,
                            activeInstallments,
                            isActive: true,
                          ),
                          _buildInstallmentList(
                            context,
                            paidInstallments,
                            isActive: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              if (state is HomeError) {
                return _buildErrorState(context, state.message);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOverview({
    required int activeCount,
    required int paidCount,
    required int lateCount,
    required double activeTotal,
    required double paidTotal,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_primary, _primaryLight],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(0.16),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: _gold,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'إجمالي الأقساط المتبقية',
                        style: TextStyle(
                          fontFamily: 'cairo',
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$activeCount أقساط',
                        style: const TextStyle(
                          fontFamily: 'cairo',
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  '${activeTotal.toStringAsFixed(2)} ريال',
                  style: const TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 3,
                  width: 65,
                  decoration: BoxDecoration(
                    color: _gold,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMiniSummary(
                  icon: Icons.check_circle_outline_rounded,
                  title: 'تم سدادها',
                  value: '$paidCount قسط',
                  color: _green,
                  background: const Color(0xFFE7F4ED),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMiniSummary(
                  icon: Icons.payments_outlined,
                  title: 'إجمالي المدفوع',
                  value: '${paidTotal.toStringAsFixed(2)} ريال',
                  color: _green,
                  background: const Color(0xFFE7F4ED),
                ),
              ),
            ],
          ),
          if (lateCount > 0) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEEE),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: _red.withOpacity(0.15),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: _red,
                    size: 21,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'لديك $lateCount قسط متعثر، يرجى مراجعة مواعيد السداد.',
                      style: const TextStyle(
                        fontFamily: 'cairo',
                        color: _red,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniSummary({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 10,
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallmentList(
    BuildContext context,
    List<InstallmentItem> installments, {
    required bool isActive,
  }) {
    if (installments.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: _border),
                ),
                child: Icon(
                  isActive
                      ? Icons.receipt_long_outlined
                      : Icons.task_alt_rounded,
                  color: isActive ? _primaryLight : _green,
                  size: 43,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                isActive
                    ? 'لا توجد أقساط متبقية'
                    : 'لا توجد أقساط مدفوعة حتى الآن',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isActive
                    ? 'أحسنت! لا توجد التزامات ظاهرة في هذا القسم.'
                    : 'ستظهر الأقساط المسددة هنا بعد تأكيد الدفع.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'cairo',
                  fontSize: 12,
                  color: _muted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: installments.length + 1,
      itemBuilder: (context, index) {
        if (index == installments.length) {
          return _buildFooter();
        }

        final item = installments[index];

        return _buildInstallmentCard(
          context,
          item,
          isActive: isActive,
        );
      },
    );
  }

  Widget _buildInstallmentCard(
    BuildContext context,
    InstallmentItem item, {
    required bool isActive,
  }) {
    final Color statusColor = !isActive
        ? _green
        : item.isLate
            ? _red
            : _blue;

    final Color statusBackground = !isActive
        ? const Color(0xFFE7F4ED)
        : item.isLate
            ? const Color(0xFFFFEEEE)
            : const Color(0xFFEAF2FD);

    final IconData statusIcon = !isActive
        ? Icons.check_circle_rounded
        : item.isLate
            ? Icons.warning_amber_rounded
            : Icons.schedule_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                color: statusColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color: statusBackground,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Icon(
                              statusIcon,
                              color: statusColor,
                              size: 23,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'cairo',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _text,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  isActive
                                      ? (item.isLate
                                          ? 'قسط متعثر'
                                          : 'قسط مستحق')
                                      : 'مدفوع ومكتمل',
                                  style: TextStyle(
                                    fontFamily: 'cairo',
                                    fontSize: 11,
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${item.amount.toStringAsFixed(2)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontFamily: 'cairo',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                                const Text(
                                  'ريال',
                                  style: TextStyle(
                                    fontFamily: 'cairo',
                                    fontSize: 10,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F8FB),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: _muted,
                              size: 17,
                            ),
                            const SizedBox(width: 7),
                            const Text(
                              'تاريخ الاستحقاق',
                              style: TextStyle(
                                fontFamily: 'cairo',
                                color: _muted,
                                fontSize: 10,
                              ),
                            ),
                            const Spacer(),
                            Flexible(
                              child: Text(
                                item.dueDate,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontFamily: 'cairo',
                                  color: _text,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isActive)
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed: () => _payInstallment(context, item),
                            icon: const Icon(
                              Icons.credit_card_rounded,
                              size: 19,
                            ),
                            label: Text(
                              item.isLate ? 'سداد القسط المتعثر' : 'سداد الآن',
                              style: const TextStyle(
                                fontFamily: 'cairo',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: item.isLate ? _red : _primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7F4ED),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: _green,
                                size: 17,
                              ),
                              SizedBox(width: 7),
                              Text(
                                'تم سداد هذا القسط',
                                style: TextStyle(
                                  fontFamily: 'cairo',
                                  color: _green,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _payInstallment(
    BuildContext context,
    InstallmentItem item,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'جاري معالجة عملية السداد...',
          style: TextStyle(fontFamily: 'cairo'),
        ),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      final bool isPaid = await HomeRepository().payInstallment(item.id);

      if (!context.mounted) return;

      if (isPaid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم سداد القسط بنجاح وتحديث حسابك',
              style: TextStyle(fontFamily: 'cairo'),
            ),
            backgroundColor: _green,
          ),
        );

        context.read<HomeBloc>().add(FetchHomeData());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'لم يتم تأكيد السداد، يرجى المحاولة مرة أخرى.',
              style: TextStyle(fontFamily: 'cairo'),
            ),
            backgroundColor: _red,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll('Exception: ', ''),
            style: const TextStyle(fontFamily: 'cairo'),
          ),
          backgroundColor: _red,
        ),
      );
    }
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEEEE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: _red,
                size: 35,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'تعذر تحميل الأقساط',
              style: TextStyle(
                fontFamily: 'cairo',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: _text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'cairo',
                fontSize: 12,
                color: _muted,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HomeBloc>().add(FetchHomeData());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontFamily: 'cairo'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9E7F8)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.shield_outlined,
            color: _primaryLight,
            size: 27,
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معاً نحو مستقبل مالي أفضل',
                  style: TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _primary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'تابع التزاماتك وحافظ على انتظام مدفوعاتك.',
                  style: TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 10,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
