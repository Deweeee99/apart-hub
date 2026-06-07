import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/data/demo_data.dart';
import '../../core/models/app_models.dart';
import '../../core/widgets/luxury_button.dart';
import '../../core/widgets/premium_step_indicator.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/white_premium_card.dart';

final _currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
final _date = DateFormat('d MMM yyyy', 'id_ID');
final _time = DateFormat('HH:mm', 'id_ID');
final _month = DateFormat('MMM yyyy');

const _billingBackground = Color(0xFFFAF8F2);
const _billingNavy = Color(0xFF071B34);
const _billingGold = Color(0xFFC08A1A);
const _billingSoftGold = Color(0xFFFFF6DF);
const _billingMuted = Color(0xFF687184);
const _billingLine = Color(0xFFE7DFD1);
const _billingSoftGray = Color(0xFFF2F0EA);

class BillingPaymentPage extends StatefulWidget {
  const BillingPaymentPage({super.key});

  @override
  State<BillingPaymentPage> createState() => _BillingPaymentPageState();
}

class _BillingPaymentPageState extends State<BillingPaymentPage> {
  late final List<Billing> _billings = DemoData.billings
      .map((item) => item)
      .toList();
  final _dummyHistory = [
    Billing(
      id: 'INV-IPL-0526',
      category: 'IPL',
      amount: 2400000,
      dueDate: DateTime(2026, 5, 20),
      status: 'Paid',
    ),
    Billing(
      id: 'INV-IPL-0426',
      category: 'IPL',
      amount: 2400000,
      dueDate: DateTime(2026, 4, 20),
      status: 'Paid',
    ),
    Billing(
      id: 'INV-IPL-0326',
      category: 'IPL',
      amount: 2400000,
      dueDate: DateTime(2026, 3, 20),
      status: 'Paid',
    ),
  ];

  var _billingStep = 0;
  Billing? _selectedBilling;
  var _selectedPaymentMethod = 'Virtual Account';
  var _paymentStatus = 'Idle';
  var _historyFilter = 'All Status';
  var _paymentDateTime = DateTime(2026, 6, 20, 10, 30);
  var _transactionId = 'TRX20250620000123';

  @override
  Widget build(BuildContext context) {
    return _BillingSurface(
      child: ListView(
        key: const ValueKey('resident-billing'),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          _buildFlowHeader(),
          const SizedBox(height: 14),
          PremiumStepIndicator(
            currentStep: _billingStep,
            steps: const [
              'Overview',
              'Invoice',
              'Method',
              'Confirm',
              'Success',
              'History',
            ],
            onStepSelected: _goToStep,
          ),
          const SizedBox(height: 16),
          _buildStepContent(),
        ],
      ),
    );
  }

  void _goToStep(int step) {
    final nextStep = step.clamp(0, 5);
    if (nextStep > 0 && nextStep < 5 && _activeBilling == null) {
      _selectInvoice(_firstUnpaidBilling ?? _billings.first);
      return;
    }
    setState(() => _billingStep = nextStep);
  }

  void _selectInvoice(Billing billing) {
    setState(() {
      _selectedBilling = billing;
      _billingStep = 1;
    });
  }

  void _simulatePaymentSuccess() {
    final billing = _activeBilling;
    if (billing == null) {
      _goToStep(0);
      return;
    }
    final index = _billings.indexWhere((item) => item.id == billing.id);
    final paidBilling = billing.copyWith(status: 'Paid');
    setState(() {
      if (index != -1) {
        _billings[index] = paidBilling;
      }
      _selectedBilling = paidBilling;
      _paymentStatus = 'Paid';
      _paymentDateTime = DateTime(2026, 6, 20, 10, 30);
      _transactionId =
          'TRX${billing.id.hashCode.abs().toString().padLeft(10, '0')}';
      _billingStep = 4;
    });
  }

  Widget _buildStepContent() {
    return switch (_billingStep) {
      0 => _buildBillingOverview(),
      1 => _buildInvoiceDetail(),
      2 => _buildChoosePaymentMethod(),
      3 => _buildPaymentConfirmation(),
      4 => _buildPaymentSuccess(),
      _ => _buildPaymentHistory(),
    };
  }

  Widget _buildFlowHeader() {
    return const _BillingHeader(
      title: 'Billing & Payment',
      subtitle: 'Seamless, secure, and convenient',
      icon: Icons.receipt_long_outlined,
    );
  }

  Widget _buildBillingOverview() {
    final unpaid = _billings.where((item) => item.status != 'Paid').toList();
    final totalOutstanding = unpaid.fold<int>(
      0,
      (total, item) => total + item.amount,
    );
    final nearestDue = unpaid.map((item) => item.dueDate).fold<DateTime?>(
      null,
      (earliest, date) {
        if (earliest == null || date.isBefore(earliest)) {
          return date;
        }
        return earliest;
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _billingNavy,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: _billingNavy.withValues(alpha: 0.18),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const _GoldIcon(
                    icon: Icons.account_balance_wallet_outlined,
                    size: 48,
                    filled: false,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Outstanding',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.74),
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nearestDue == null
                              ? 'All invoices are paid'
                              : 'Due ${_date.format(nearestDue)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.70),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                _currency.format(totalOutstanding),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: _billingGold,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              LuxuryButton(
                label: totalOutstanding == 0 ? 'View History' : 'Pay Now',
                icon: totalOutstanding == 0
                    ? Icons.history_outlined
                    : Icons.payments_outlined,
                onPressed: () {
                  final billing = _firstUnpaidBilling;
                  if (billing == null) {
                    _goToStep(5);
                    return;
                  }
                  _selectInvoice(billing);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader(
          title: 'Unpaid Invoices',
          actionLabel: '${unpaid.length} pending',
          icon: Icons.receipt_outlined,
        ),
        const SizedBox(height: 12),
        if (unpaid.isEmpty)
          const WhitePremiumCard(child: Text('All invoices are paid.'))
        else
          for (final billing in unpaid) _buildInvoiceListCard(billing),
      ],
    );
  }

  Widget _buildInvoiceDetail() {
    final billing = _activeBilling;
    if (billing == null) {
      return WhitePremiumCard(
        child: Column(
          children: [
            const Text('No invoice selected.'),
            const SizedBox(height: 14),
            LuxuryButton(
              label: 'Back to Overview',
              icon: Icons.arrow_back_outlined,
              onPressed: () => _goToStep(0),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GoldIcon(icon: _billingIcon(billing.category), size: 46),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          billing.id,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: _billingNavy,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${billing.category} - Due ${_date.format(billing.dueDate)}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: _billingMuted),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: billing.status),
                ],
              ),
              const SizedBox(height: 18),
              _BillingBreakdown(billing: billing),
              const SizedBox(height: 18),
              _OutlineActionButton(
                label: 'Download Invoice',
                icon: Icons.picture_as_pdf_outlined,
                onPressed: () => _showBillingSnack(
                  'Invoice PDF generated for ${billing.id}.',
                ),
              ),
              if (billing.status != 'Paid') ...[
                const SizedBox(height: 12),
                LuxuryButton(
                  label: 'Pay Now',
                  icon: Icons.payments_outlined,
                  onPressed: () => _goToStep(2),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChoosePaymentMethod() {
    final savedMethods = const [
      ('Visa', '**** **** **** 1234', Icons.credit_card_outlined),
      ('Mastercard', '**** **** **** 5678', Icons.credit_card_outlined),
    ];
    final otherMethods = const [
      ('Virtual Account', 'Pay from any bank', Icons.account_balance_outlined),
      ('E-Wallet', 'GoPay, OVO, DANA, ShopeePay', Icons.wallet_outlined),
      ('QRIS', 'Scan and pay instantly', Icons.qr_code_2_outlined),
      ('Credit / Debit Card', 'Visa, Mastercard, JCB', Icons.payment_outlined),
      ('Convenience Store', 'Alfamart, Indomaret', Icons.storefront_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: 'Saved Methods',
          actionLabel: 'Cards',
          icon: Icons.credit_card_outlined,
        ),
        const SizedBox(height: 12),
        for (final method in savedMethods)
          _PaymentMethodCard(
            title: method.$1,
            subtitle: method.$2,
            icon: method.$3,
            selected: _selectedPaymentMethod == method.$1,
            onTap: () => setState(() => _selectedPaymentMethod = method.$1),
          ),
        const SizedBox(height: 10),
        const _SectionHeader(
          title: 'Other Methods',
          actionLabel: 'Secure',
          icon: Icons.account_balance_wallet_outlined,
        ),
        const SizedBox(height: 12),
        for (final method in otherMethods)
          _PaymentMethodCard(
            title: method.$1,
            subtitle: method.$2,
            icon: method.$3,
            selected: _selectedPaymentMethod == method.$1,
            onTap: () => setState(() => _selectedPaymentMethod = method.$1),
          ),
        const SizedBox(height: 8),
        LuxuryButton(
          label: 'Continue',
          icon: Icons.arrow_forward_outlined,
          onPressed: () => _goToStep(3),
        ),
      ],
    );
  }

  Widget _buildPaymentConfirmation() {
    final billing = _activeBilling;
    if (billing == null) {
      return _buildInvoiceDetail();
    }
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _billingNavy,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _billingNavy.withValues(alpha: 0.16),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Summary',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              _DarkInfoRow(label: 'Invoice', value: billing.id),
              const SizedBox(height: 10),
              _DarkInfoRow(
                label: 'Due Date',
                value: _date.format(billing.dueDate),
              ),
              const SizedBox(height: 10),
              _DarkInfoRow(
                label: 'Total Amount',
                value: _currency.format(billing.amount),
                highlight: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardTitle(
                title: 'Payment Method',
                subtitle: 'Review before proceeding.',
                icon: Icons.verified_user_outlined,
              ),
              const SizedBox(height: 16),
              _InfoRow(label: 'Method', value: _selectedPaymentMethod),
              const SizedBox(height: 10),
              _InfoRow(
                label: 'Amount',
                value: _currency.format(billing.amount),
              ),
              const SizedBox(height: 10),
              _InfoRow(label: 'Transaction Fee', value: _currency.format(0)),
              const SizedBox(height: 10),
              _InfoRow(
                label: 'Total Payment',
                value: _currency.format(billing.amount),
                highlight: true,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.lock_outline, color: _billingGold, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your payment information is secure and encrypted.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _billingMuted,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LuxuryButton(
                label: 'Pay Now',
                icon: Icons.payments_outlined,
                onPressed: _simulatePaymentSuccess,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSuccess() {
    final billing = _activeBilling;
    if (billing == null) {
      return _buildBillingOverview();
    }
    return WhitePremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F7EE),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2DAE62)),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF218D4F),
              size: 56,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Payment Successful!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF218D4F),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your payment has been completed successfully.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _billingMuted),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _billingSoftGray,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _billingLine),
            ),
            child: Column(
              children: [
                _InfoRow(
                  label: 'Total Payment',
                  value: _currency.format(billing.amount),
                  highlight: true,
                ),
                const SizedBox(height: 10),
                _InfoRow(label: 'Transaction ID', value: _transactionId),
                const SizedBox(height: 10),
                _InfoRow(
                  label: 'Date & Time',
                  value:
                      '${_date.format(_paymentDateTime)}, ${_time.format(_paymentDateTime)}',
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  label: 'Payment Method',
                  value: _selectedPaymentMethod,
                ),
                const SizedBox(height: 10),
                _InfoRow(label: 'Status', value: _paymentStatus),
              ],
            ),
          ),
          const SizedBox(height: 18),
          LuxuryButton(
            label: 'View Receipt',
            icon: Icons.receipt_long_outlined,
            onPressed: () =>
                _showBillingSnack('Receipt generated for ${billing.id}.'),
          ),
          const SizedBox(height: 10),
          _OutlineActionButton(
            label: 'Payment History',
            icon: Icons.history_outlined,
            onPressed: () => _goToStep(5),
          ),
          const SizedBox(height: 10),
          _OutlineActionButton(
            label: 'Back to Overview',
            icon: Icons.home_outlined,
            onPressed: () => _goToStep(0),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory() {
    final filtered = _historyItems.where(_matchesHistoryFilter).toList()
      ..sort((a, b) => b.dueDate.compareTo(a.dueDate));
    final grouped = <String, List<Billing>>{};
    for (final billing in filtered) {
      grouped.putIfAbsent(
        _month.format(billing.dueDate).toUpperCase(),
        () => [],
      );
      grouped[_month.format(billing.dueDate).toUpperCase()]!.add(billing);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardTitle(
                title: 'Payment History',
                subtitle: 'Track past payments and download statements.',
                icon: Icons.history_outlined,
              ),
              const SizedBox(height: 16),
              _ChoiceWrap(
                items: const ['All Status', 'Paid', 'Unpaid', 'Overdue'],
                selected: _historyFilter,
                onSelected: (value) => setState(() => _historyFilter = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (final entry in grouped.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 2, 10),
            child: Text(
              entry.key,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: _billingNavy,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          for (final billing in entry.value) _buildHistoryCard(billing),
        ],
        const SizedBox(height: 4),
        _OutlineActionButton(
          label: 'Download Statement',
          icon: Icons.download_outlined,
          onPressed: () => _showBillingSnack('Payment statement downloaded.'),
        ),
      ],
    );
  }

  Widget _buildInvoiceListCard(Billing billing) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      onTap: () => _selectInvoice(billing),
      child: Row(
        children: [
          _GoldIcon(icon: _billingIcon(billing.category), size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  billing.category,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _billingNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${billing.id} - Due ${_date.format(billing.dueDate)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _billingMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _currency.format(billing.amount),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _billingNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              StatusBadge(status: billing.status),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: _billingGold),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Billing billing) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GoldIcon(icon: _billingIcon(billing.category), size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  billing.id,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _billingNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${billing.category} - ${billing.status == 'Paid' ? 'Paid' : 'Due'} ${_date.format(billing.dueDate)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _billingMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _currency.format(billing.amount),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _billingNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              StatusBadge(status: billing.status),
            ],
          ),
        ],
      ),
    );
  }

  void _showBillingSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _matchesHistoryFilter(Billing billing) {
    return switch (_historyFilter) {
      'Paid' => billing.status == 'Paid',
      'Unpaid' => billing.status != 'Paid' && billing.status != 'Overdue',
      'Overdue' => billing.status == 'Overdue',
      _ => true,
    };
  }

  IconData _billingIcon(String category) {
    return switch (category) {
      'Air' => Icons.water_drop_outlined,
      'Listrik' => Icons.bolt_outlined,
      'Parkir' => Icons.local_parking_outlined,
      _ => Icons.receipt_long_outlined,
    };
  }

  Billing? get _firstUnpaidBilling {
    for (final billing in _billings) {
      if (billing.status != 'Paid') {
        return billing;
      }
    }
    return null;
  }

  Billing? get _activeBilling {
    final selected = _selectedBilling;
    if (selected == null) {
      return null;
    }
    final index = _billings.indexWhere((item) => item.id == selected.id);
    if (index == -1) {
      return selected;
    }
    return _billings[index];
  }

  List<Billing> get _historyItems => [..._billings, ..._dummyHistory];
}

class _BillingSurface extends StatelessWidget {
  const _BillingSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: _billingBackground,
        textTheme: Theme.of(
          context,
        ).textTheme.apply(bodyColor: _billingNavy, displayColor: _billingNavy),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: _billingMuted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _billingLine),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _billingGold, width: 1.2),
          ),
        ),
      ),
      child: ColoredBox(color: _billingBackground, child: child),
    );
  }
}

class _BillingHeader extends StatelessWidget {
  const _BillingHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _GoldIcon(icon: icon, size: 48),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _billingNavy,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _billingMuted,
                    height: 1.35,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.icon,
  });

  final String title;
  final String actionLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _billingGold, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _billingNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          actionLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: _billingMuted,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GoldIcon(icon: icon, size: 42),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _billingNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _billingMuted,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BillingBreakdown extends StatelessWidget {
  const _BillingBreakdown({required this.billing});

  final Billing billing;

  @override
  Widget build(BuildContext context) {
    final maintenance = (billing.amount * 0.72).round();
    final sinkingFund = (billing.amount * 0.20).round();
    final utility = billing.amount - maintenance - sinkingFund;
    final rows = [
      ('Maintenance Fee', maintenance),
      ('Sinking Fund', sinkingFund),
      ('Utility / Electricity', utility),
      ('Parking', billing.category == 'Parkir' ? billing.amount : 0),
      ('Late Fee', billing.status == 'Overdue' ? 50000 : 0),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _billingSoftGray,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _billingLine),
      ),
      child: Column(
        children: [
          for (final row in rows) ...[
            _InfoRow(label: row.$1, value: _currency.format(row.$2)),
            const SizedBox(height: 9),
          ],
          const Divider(color: _billingLine),
          _InfoRow(
            label: 'Total Amount',
            value: _currency.format(billing.amount),
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        children: [
          _GoldIcon(icon: icon, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _billingNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _billingMuted),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: selected ? _billingGold : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? _billingGold : _billingLine,
                width: 1.4,
              ),
            ),
            child: selected
                ? const Icon(Icons.check, color: Colors.white, size: 15)
                : null,
          ),
        ],
      ),
    );
  }
}

class _ChoiceWrap extends StatelessWidget {
  const _ChoiceWrap({
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          _PillChoice(
            label: item,
            selected: selected == item,
            onTap: () => onSelected(item),
          ),
      ],
    );
  }
}

class _PillChoice extends StatelessWidget {
  const _PillChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _billingSoftGold : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: selected ? _billingGold.withValues(alpha: 0.55) : _billingLine,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected ? _billingNavy : _billingMuted,
              fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          foregroundColor: _billingNavy,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          side: const BorderSide(color: _billingLine),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _DarkInfoRow extends StatelessWidget {
  const _DarkInfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.74),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: highlight ? _billingGold : Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _billingMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: highlight ? _billingGold : _billingNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _GoldIcon extends StatelessWidget {
  const _GoldIcon({required this.icon, this.size = 40, this.filled = true});

  final IconData icon;
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled ? _billingSoftGold : Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(size * 0.34),
        border: Border.all(color: _billingGold.withValues(alpha: 0.32)),
      ),
      child: Icon(icon, color: _billingGold, size: size * 0.54),
    );
  }
}
