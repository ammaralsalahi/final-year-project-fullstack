import 'package:flutter/material.dart';

class SliverAppBarDashboard extends StatelessWidget {
  final String userName;
  final double balance;
  final int creditScore;
  final double nextInstallment;
  final String dueDate;
  final bool isOverdue;

  const SliverAppBarDashboard({
    super.key,
    required this.userName,
    required this.balance,
    required this.creditScore,
    required this.nextInstallment,
    required this.dueDate,
    this.isOverdue = false,
  });

  static const Color primaryColor = Color(0xFF123746);
  static const Color secondaryColor = Color(0xFF205466);
  static const Color goldColor = Color(0xFFDDBB69);

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        isOverdue ? const Color(0xFFFF8A80) : goldColor;

    return SliverAppBar(
      expandedHeight: 340,
      collapsedHeight: 68,
      toolbarHeight: 68,
      pinned: true,
      floating: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: _buildStaticHeader(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF0D2D3A),
                    Color(0xFF164958),
                    Color(0xFF246477),
                  ],
                ),
              ),
            ),

            Positioned(
              top: -65,
              left: -45,
              child: _buildDecorativeCircle(
                size: 190,
                color: Colors.white.withOpacity(0.045),
              ),
            ),

            Positioned(
              top: 95,
              right: -65,
              child: _buildDecorativeCircle(
                size: 145,
                color: goldColor.withOpacity(0.08),
              ),
            ),

            Positioned(
              bottom: 30,
              left: 30,
              child: _buildDecorativeCircle(
                size: 55,
                color: Colors.white.withOpacity(0.035),
              ),
            ),

            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 76, 20, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildEfficiencyScore(
                      creditScore,
                      statusColor,
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.085),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 18,
                                color: goldColor,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'الرصيد الحالي',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontFamily: 'cairo',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                                  CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  balance.toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 31,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.3,
                                    fontFamily: 'cairo',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'ريال',
                                  style: TextStyle(
                                    color: goldColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoChip(
                            icon: Icons.payments_outlined,
                            label: 'القسط',
                            value: _formatAmount(nextInstallment),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInfoChip(
                            icon: Icons.calendar_month_outlined,
                            label: 'موعد الاستحقاق',
                            value: dueDate,
                            color: isOverdue
                                ? const Color(0xFFFF8A80)
                                : goldColor,
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

  Widget _buildStaticHeader() {
    final String name =
        userName.trim().isEmpty ? 'مستخدم' : userName.trim();

    return Row(
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.13),
            shape: BoxShape.circle,
            border: Border.all(
              color: goldColor.withOpacity(0.75),
              width: 1.3,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            name.characters.first,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontFamily: 'cairo',
            ),
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'مرحباً بك',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontFamily: 'cairo',
                ),
              ),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'cairo',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.09),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.account_balance_outlined,
            color: goldColor,
            size: 21,
          ),
        ),
      ],
    );
  }

  Widget _buildEfficiencyScore(int points, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.13),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: statusColor.withOpacity(0.42),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: statusColor,
            size: 19,
          ),
          const SizedBox(width: 8),
          Text(
            'مؤشر الثقة والائتمان',
            style: TextStyle(
              color: Colors.white.withOpacity(0.92),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'cairo',
            ),
          ),
          const SizedBox(width: 9),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$points',
              style: TextStyle(
                color: statusColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFamily: 'cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.09),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    fontFamily: 'cairo',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(2);
  }
}
