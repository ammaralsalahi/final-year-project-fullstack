
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:installment/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Future<List<dynamic>> _transactionsFuture;

  static const Color _primary = Color(0xFF123746);
  static const Color _primaryLight = Color(0xFF205466);
  static const Color _gold = Color(0xFFDDBB69);
  static const Color _background = Color(0xFFF3F6FA);
  static const Color _textColor = Color(0xFF1B3440);
  static const Color _mutedColor = Color(0xFF7B8B96);
  static const Color _borderColor = Color(0xFFE5EBF0);

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _fetchTransactions();
  }

  Future<List<dynamic>> _fetchTransactions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final String url = '${AppConstants.baseUrl}/user/transactions';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);

        if (decoded.containsKey('data')) {
          return decoded['data'] as List<dynamic>;
        }
        return [];
      } else {
        throw Exception('فشل الاتصال: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<void> _generateAndDownloadPDF(
    List<dynamic> transactions,
  ) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: font),
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              children: [
                pw.Center(
                  child: pw.Text(
                    'كشف الحساب المالي',
                    style: const pw.TextStyle(fontSize: 20),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.TableHelper.fromTextArray(
                  context: context,
                  data: [
                    ['المنتج', 'النوع', 'المبلغ'],
                    ...transactions.map(
                      (tx) => [
                        tx['order']?['product']?['product_name'] ?? '-',
                        tx['type'] ?? '-',
                        '${tx['amount']} ر.س',
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  Future<void> _refreshTransactions() async {
    final future = _fetchTransactions();

    setState(() {
      _transactionsFuture = future;
    });

    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'سجل العمليات',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: _primaryLight,
                strokeWidth: 3,
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildErrorState();
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final list = snapshot.data!;

          return RefreshIndicator(
            color: _primary,
            onRefresh: _refreshTransactions,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
              children: [
                _buildHeader(list.length),

                const SizedBox(height: 22),

                _buildPdfButton(list),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 23,
                      decoration: BoxDecoration(
                        color: _gold,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'جميع العمليات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4EDF2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${list.length} عملية',
                        style: const TextStyle(
                          color: _primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                ...List.generate(
                  list.length,
                  (index) => _buildTransactionCard(
                    list[index],
                    index,
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: Text(
                    'اسحب للأسفل لتحديث السجل',
                    style: TextStyle(
                      fontSize: 12,
                      color: _mutedColor.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF123746),
            Color(0xFF205466),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -12,
            top: -15,
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 100,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: _gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _gold.withOpacity(0.35),
                  ),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: _gold,
                  size: 27,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'سجل معاملاتك',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'تابع عمليات الشراء والتقسيط في مكان واحد',
                style: TextStyle(
                  color: Color(0xFFD5E3E9),
                  fontSize: 13,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.receipt_outlined,
                      size: 19,
                      color: _gold,
                    ),
                    const SizedBox(width: 9),
                    const Text(
                      'إجمالي العمليات المسجلة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '$count',
                      style: const TextStyle(
                        color: _gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPdfButton(List<dynamic> list) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _generateAndDownloadPDF(list),
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _borderColor),
            boxShadow: [
              BoxShadow(
                color: _primary.withOpacity(0.035),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: Color(0xFFC44747),
                  size: 26,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'كشف الحساب المالي',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'عرض وطباعة التقرير بصيغة PDF',
                      style: TextStyle(
                        color: _mutedColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(dynamic item, int index) {
    final String prodName =
        item['order']?['product']?['product_name'] ??
            'منتج غير محدد';

    final String type = item['type']?.toString() ?? '';
    final String amount = item['amount']?.toString() ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 49,
              height: 49,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1F5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: _primaryLight,
                size: 24,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prodName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),

                  if (type.isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F6F8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _mutedColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 10),

            Flexible(
              flex: 0,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 125,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F6F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _gold.withOpacity(0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'المبلغ',
                      style: TextStyle(
                        color: _mutedColor,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      amount,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: _primary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'ر.س',
                      style: TextStyle(
                        color: _mutedColor,
                        fontSize: 10,
                      ),
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

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE7EEF3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: _primaryLight,
                size: 48,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'لا توجد عمليات مسجلة',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textColor,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'ستظهر عملياتك هنا عند توفرها.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _mutedColor,
                fontSize: 13,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 24),

            OutlinedButton.icon(
              onPressed: _refreshTransactions,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('تحديث السجل'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _primary,
                side: const BorderSide(color: _primaryLight),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFFC44747),
              size: 58,
            ),

            const SizedBox(height: 18),

            const Text(
              'تعذر تحميل سجل العمليات',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'تحقق من اتصال الإنترنت وحاول مرة أخرى.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _mutedColor,
                fontSize: 13,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _refreshTransactions,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
