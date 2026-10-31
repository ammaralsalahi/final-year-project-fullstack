
import 'package:flutter/material.dart';

import '../../../../data/repository/home_repository.dart';
import '../../data/model/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel? product;

  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final HomeRepository _repository = HomeRepository();

  int _selectedMonths = 3;
  bool _isLoading = false;

  static const Color primaryColor = Color(0xFF123746);
  static const Color secondaryColor = Color(0xFF205466);
  static const Color goldColor = Color(0xFFDDBB69);
  static const Color backgroundColor = Color(0xFFF3F6FA);
  static const Color mutedColor = Color(0xFF7B8B96);
  static const Color successColor = Color(0xFF23866B);
  static const Color errorColor = Color(0xFFCE5252);

  double get _monthlyInstallment {
    if (widget.product == null) return 0;
    return widget.product!.price / _selectedMonths;
  }

  double get _downPayment {
    if (widget.product == null) return 0;
    return widget.product!.price / 2;
  }

  void _showConfirmDialog(double downPaymentAmount) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: secondaryColor,
                  size: 27,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'تأكيد طلب التقسيط',
                    style: TextStyle(
                      fontFamily: 'cairo',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'يرجى مراجعة ملخص طلبك قبل المتابعة.',
                  style: TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 13,
                    color: mutedColor,
                  ),
                ),
                const SizedBox(height: 18),
                _dialogRow(
                  'الدفعة المقدمة',
                  '${downPaymentAmount.toStringAsFixed(2)} ريال',
                ),
                const SizedBox(height: 10),
                _dialogRow(
                  'مدة التقسيط',
                  '$_selectedMonths أشهر',
                ),
                const SizedBox(height: 10),
                _dialogRow(
                  'القسط الشهري التقريبي',
                  '${_monthlyInstallment.toStringAsFixed(2)} ريال',
                ),
                const SizedBox(height: 14),
                const Text(
                  'سيتم إرسال الطلب إلى نظام التقسيط عند التأكيد. '
                  'تحقق من تفاصيل الدفع قبل المتابعة.',
                  style: TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 12,
                    height: 1.7,
                    color: mutedColor,
                  ),
                ),
              ],
            ),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'مراجعة',
                        style: TextStyle(
                          fontFamily: 'cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        _handlePurchase(downPaymentAmount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'تأكيد الطلب',
                        style: TextStyle(
                          fontFamily: 'cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dialogRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'cairo',
              fontSize: 12,
              color: mutedColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: 'cairo',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handlePurchase(double downPayment) async {
    if (widget.product == null || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final int productId = int.tryParse(widget.product!.id) ?? 0;

      if (productId <= 0) {
        throw Exception('معرّف المنتج غير صالح.');
      }

      final bool success =
          await _repository.purchaseProductWithInstallment(
        productId: productId,
        months: _selectedMonths,
        downPayment: downPayment,
      );

      if (!mounted) return;

      if (success) {
        _showStyledSnackBar(
          message: 'تم تنفيذ طلب التقسيط بنجاح.',
          isError: false,
        );

        Navigator.pop(context);
      } else {
        _showStyledSnackBar(
          message: 'لم تكتمل عملية الشراء. حاول مرة أخرى.',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showStyledSnackBar(
        message: e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showStyledSnackBar({
    required String message,
    required bool isError,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: isError ? errorColor : successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          margin: const EdgeInsets.all(14),
          duration: const Duration(seconds: 4),
        ),
      );
  }

  Widget _buildProductImage(ProductModel product) {
    Widget fallback() {
      return Container(
        color: const Color(0xFFE9EFF3),
        alignment: Alignment.center,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 58,
              color: secondaryColor,
            ),
            SizedBox(height: 8),
            Text(
              'صورة المنتج غير متوفرة',
              style: TextStyle(
                fontFamily: 'cairo',
                fontSize: 12,
                color: secondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    if (product.image.isEmpty) {
      return Image.asset(
        'assets/images/img2.png',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }

    if (product.image.startsWith('http')) {
      return Image.network(
        product.image,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }

    return Image.asset(
      product.image,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => fallback(),
    );
  }

  Widget _buildSectionTitle(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: secondaryColor, size: 21),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'cairo',
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanOption(int months) {
    final bool selected = _selectedMonths == months;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? primaryColor : const Color(0xFFE0E7EC),
            width: 1.2,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isLoading
              ? null
              : () {
                  setState(() => _selectedMonths = months);
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 4,
            ),
            child: Column(
              children: [
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.calendar_month_rounded,
                  color: selected ? goldColor : mutedColor,
                  size: 21,
                ),
                const SizedBox(height: 7),
                Text(
                  '$months أشهر',
                  style: TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(widget.product!.price / months).toStringAsFixed(0)} ريال',
                  style: TextStyle(
                    fontFamily: 'cairo',
                    fontSize: 10,
                    color: selected ? goldColor : mutedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String value,
    bool highlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'cairo',
                fontSize: 12,
                color: highlighted ? primaryColor : mutedColor,
                fontWeight:
                    highlighted ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'cairo',
                fontSize: 13,
                color: highlighted ? secondaryColor : primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    if (product == null) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: primaryColor,
            elevation: 0,
          ),
          body: const Center(
            child: Text(
              'بيانات المنتج غير متوفرة',
              style: TextStyle(
                fontFamily: 'cairo',
                color: primaryColor,
              ),
            ),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: primaryColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'تفاصيل المنتج',
            style: TextStyle(
              fontFamily: 'cairo',
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'رجوع',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_forward_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // صورة المنتج
                    Container(
                      height: 280,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: _buildProductImage(product),
                            ),
                          ),
                          Positioned(
                            top: 14,
                            right: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_outlined,
                                    size: 15,
                                    color: goldColor,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'تفاصيل المنتج',
                                    style: TextStyle(
                                      fontFamily: 'cairo',
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // اسم المنتج والسعر
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontFamily: 'cairo',
                        fontSize: 21,
                        height: 1.5,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.sell_outlined,
                          size: 19,
                          color: secondaryColor,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${product.price.toStringAsFixed(2)} ريال',
                            style: const TextStyle(
                              fontFamily: 'cairo',
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (product.description.isNotEmpty) ...[
                      const SizedBox(height: 22),
                      _buildSectionTitle(
                        'وصف المنتج',
                        icon: Icons.subject_rounded,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          product.description,
                          style: const TextStyle(
                            fontFamily: 'cairo',
                            fontSize: 13,
                            height: 1.9,
                            color: mutedColor,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // خيارات التقسيط
                    _buildSectionTitle(
                      'اختر خطة التقسيط',
                      icon: Icons.calendar_month_rounded,
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'حدد المدة المناسبة لك',
                      style: TextStyle(
                        fontFamily: 'cairo',
                        fontSize: 11,
                        color: mutedColor,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [3, 6, 12]
                          .map(_buildPlanOption)
                          .toList(),
                    ),

                    const SizedBox(height: 24),

                    // الملخص المالي
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.07),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                            'ملخص خطتك',
                            icon: Icons.receipt_long_rounded,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            title: 'سعر المنتج',
                            value:
                                '${product.price.toStringAsFixed(2)} ريال',
                          ),
                          const Divider(height: 12),
                          _buildSummaryRow(
                            title: 'الدفعة المقدمة (50%)',
                            value:
                                '${_downPayment.toStringAsFixed(2)} ريال',
                          ),
                          const Divider(height: 12),
                          _buildSummaryRow(
                            title: 'مدة التقسيط',
                            value: '$_selectedMonths أشهر',
                          ),
                          const Divider(height: 12),
                          _buildSummaryRow(
                            title: 'القسط الشهري التقريبي',
                            value:
                                '${_monthlyInstallment.toStringAsFixed(2)} ريال',
                            highlighted: true,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F6F7),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: secondaryColor,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'المبلغ الشهري تقديري حسب السعر والمدة المختارة، '
                                    'ولا يشمل أي رسوم إضافية قد يحددها نظام التقسيط.',
                                    style: TextStyle(
                                      fontFamily: 'cairo',
                                      fontSize: 10,
                                      height: 1.7,
                                      color: mutedColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),

        // زر الطلب أسفل الصفحة
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.07),
                  blurRadius: 18,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'القسط الشهري',
                        style: TextStyle(
                          fontFamily: 'cairo',
                          fontSize: 10,
                          color: mutedColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${_monthlyInstallment.toStringAsFixed(2)} ريال',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 7,
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _showConfirmDialog(_downPayment),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        disabledBackgroundColor:
                            primaryColor.withOpacity(0.5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 19,
                                  color: goldColor,
                                ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'اطلب بالتقسيط',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'cairo',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
