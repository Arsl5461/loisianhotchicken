import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routing/app_routes.dart';
import '../../../utils/media_query.dart';
import '../../../widgets/Layout/EditProfileHeader.dart';

import 'package:OApp/core/constants/app_colors.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  String selectedPeriod = 'This year';

  final List<Transaction> transactions = [
    Transaction(
      title: 'June, Premium 1 month',
      date: '06/05/23',
      method: 'Apple 7118',
      amount: '\$19.99',
    ),
    Transaction(
      title: 'July, Premium 1 month',
      date: '07/05/23',
      method: 'Apple 7118',
      amount: '\$19.99',
    ),
    Transaction(
      title: 'Superlike, 5 pack',
      date: '06/08/23',
      method: 'Apple 7118',
      amount: '\$4.99',
    ),
  ];
  List<Transaction> get _filteredTransactions {
    final now = DateTime.now();
    final currentYear = now.year;
    final lastYear = currentYear - 1;
    if (selectedPeriod == 'All time') return transactions;
    return transactions.where((t) {
      final dt = _parseDate(t.date);
      if (dt == null) return false;
      if (selectedPeriod == 'This year') return dt.year == currentYear;
      if (selectedPeriod == 'Last year') return dt.year == lastYear;
      return true;
    }).toList();
  }

  double get _totalAmount {
    return _filteredTransactions.fold(
      0.0,
      (sum, t) => sum + _parseAmount(t.amount),
    );
  }

  DateTime? _parseDate(String s) {
    final parts = s.split('/');
    if (parts.length != 3) return null;
    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final yy = int.tryParse(parts[2]);
    if (month == null || day == null || yy == null) return null;
    final year = 2000 + yy;
    return DateTime(year, month, day);
  }

  double _parseAmount(String s) {
    final cleaned = s.replaceAll('\$', '').trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            EditProfileHeader(
              title: 'Billing',
              onBack: () => Get.back(),
              showCloseButton: false,
            ),

            // Divider after header
            Divider(height: 1, thickness: 1, color: AppColors.grey[300]),

            // Filter Section
            _buildFilterSection(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryUtil.spacing(16),
                  vertical: MediaQueryUtil.spacing(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummary(),
                    // Column Headers
                    _buildTableHeader(),

                    SizedBox(height: MediaQueryUtil.spacing(8)),

                    // Transaction Rows
                    if (_filteredTransactions.isEmpty)
                      _buildEmptyState()
                    else
                      ..._filteredTransactions.map(
                        (transaction) => _buildTransactionRow(transaction),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom home indicator
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQueryUtil.spacing(8),
        bottom: MediaQueryUtil.spacing(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(MediaQueryUtil.spacing(12)),
              decoration: BoxDecoration(
                color: AppColors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(12),
                      color: AppColors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${_filteredTransactions.length}',
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: MediaQueryUtil.spacing(8)),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(MediaQueryUtil.spacing(12)),
              decoration: BoxDecoration(
                color: AppColors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total spent',
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(12),
                      color: AppColors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${_totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.spacing(16),
        vertical: MediaQueryUtil.spacing(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: _showPeriodSelector,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedPeriod,
                  style: TextStyle(
                    fontSize: MediaQueryUtil.fontSize(12),
                    fontWeight: FontWeight.w500,
                    color: AppColors.cFF016B6A,
                  ),
                ),
                SizedBox(width: MediaQueryUtil.spacing(4)),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.black,
                  size: MediaQueryUtil.iconSize(18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQueryUtil.spacing(6)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Title',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(12),
                fontWeight: FontWeight.w500,
                color: AppColors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Date',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(12),
                fontWeight: FontWeight.w500,
                color: AppColors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Method',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(12),
                fontWeight: FontWeight.w500,
                color: AppColors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Amount',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(12),
                fontWeight: FontWeight.w500,
                color: AppColors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(Transaction transaction) {
    return GestureDetector(
      onTap: () => _openTransactionDetails(transaction),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQueryUtil.spacing(16)),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                transaction.title,
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(12),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            Expanded(
              child: Text(
                transaction.date,
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(12),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            Expanded(
              child: Text(
                transaction.method,
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(12),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
            Expanded(
              child: Text(
                transaction.amount,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(12),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
      decoration: BoxDecoration(
        color: AppColors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey[300]!),
      ),
      child: Center(
        child: Text(
          'No billing records for the selected period',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(12),
            color: AppColors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showPeriodSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MediaQueryUtil.spacing(20)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: MediaQueryUtil.spacing(12)),
              width: MediaQueryUtil.spacing(40),
              height: MediaQueryUtil.spacing(4),
              decoration: BoxDecoration(
                color: AppColors.grey[300],
                borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(2)),
              ),
            ),

            // Period options
            Padding(
              padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
              child: Column(
                children: [
                  Text(
                    'Select Period',
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(16),
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: MediaQueryUtil.spacing(20)),

                  ...['This year', 'Last year', 'All time'].map((period) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPeriod = period;
                        });
                        Get.back();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQueryUtil.spacing(16),
                        ),
                        child: Text(
                          period,
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(14),
                            fontWeight: selectedPeriod == period
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: selectedPeriod == period
                                ? AppColors.cFF016B6A
                                : AppColors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Bottom safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _openTransactionDetails(Transaction t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MediaQueryUtil.spacing(20)),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(MediaQueryUtil.spacing(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction Details',
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(16),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.title,
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    t.amount,
                    style: TextStyle(
                      fontSize: MediaQueryUtil.fontSize(14),
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQueryUtil.spacing(8)),
              Text(
                'Date: ${t.date}',
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(12),
                  color: AppColors.grey[700],
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(4)),
              Text(
                'Method: ${t.method}',
                style: TextStyle(
                  fontSize: MediaQueryUtil.fontSize(12),
                  color: AppColors.grey[700],
                ),
              ),
              SizedBox(height: MediaQueryUtil.spacing(16)),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _viewReceipt(t);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cFF4A90E2,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'View Receipt',
                        style: TextStyle(
                          fontSize: MediaQueryUtil.fontSize(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQueryUtil.spacing(8)),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.toNamed(Routes.CONTACT_US);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.black,
                        side: BorderSide(color: AppColors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Contact Support',
                        style: TextStyle(
                          fontSize: MediaQueryUtil.fontSize(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQueryUtil.spacing(8)),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  void _viewReceipt(Transaction t) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(16)),
        ),
        title: Text(
          'Receipt',
          style: TextStyle(
            fontSize: MediaQueryUtil.fontSize(16),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.title,
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(14),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(6)),
            Text(
              'Date: ${t.date}',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(12),
                color: AppColors.grey[700],
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(4)),
            Text(
              'Method: ${t.method}',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(12),
                color: AppColors.grey[700],
              ),
            ),
            SizedBox(height: MediaQueryUtil.spacing(4)),
            Text(
              'Amount: ${t.amount}',
              style: TextStyle(
                fontSize: MediaQueryUtil.fontSize(12),
                color: AppColors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
        ],
      ),
    );
  }
}

class Transaction {
  final String title;
  final String date;
  final String method;
  final String amount;

  Transaction({
    required this.title,
    required this.date,
    required this.method,
    required this.amount,
  });
}
