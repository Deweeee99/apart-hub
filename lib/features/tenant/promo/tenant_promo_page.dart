import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/data/data_dummy.dart';
import '../../../core/widgets/tenant/tenant_promo_card.dart';
import '../../../core/widgets/white_premium_card.dart';

const _surface = Color(0xFFF8F5EF);
const _navy = Color(0xFF071B34);
const _blue = Color(0xFF173A67);
const _gold = Color(0xFFC08A1A);
const _muted = Color(0xFF687184);
const _line = Color(0xFFE7DFD1);
const _softGreen = Color(0xFFF0F9F1);
const _softBlue = Color(0xFFF0F6FF);
const _softGray = Color(0xFFF5F6F8);

class TenantPromoPage extends StatefulWidget {
  const TenantPromoPage({super.key});

  @override
  State<TenantPromoPage> createState() => _TenantPromoPageState();
}

class _TenantPromoPageState extends State<TenantPromoPage> {
  late List<_TenantPromo> _promos = DataDummy.tenantPromos
      .map(
        (item) => _TenantPromo(
          title: item.title,
          description: item.description,
          status: item.status,
          category: item.category,
          startDate: item.startDate,
          endDate: item.endDate,
          iconKey: item.iconKey,
        ),
      )
      .toList();
  String _filter = 'Active';

  List<_TenantPromo> get _filteredPromos =>
      _promos.where((promo) => promo.status == _filter).toList();

  Future<void> _showPromoSheet() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    var category = 'Coffee';
    var status = 'Active';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: WhitePremiumCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Promo',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _navy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: _navy),
                      cursorColor: _gold,
                      decoration: _fieldDecoration('Promo Title'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      style: const TextStyle(color: _navy),
                      cursorColor: _gold,
                      maxLines: 2,
                      decoration: _fieldDecoration('Description'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: _navy),
                      decoration: _fieldDecoration('Category'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Coffee',
                          child: Text('Coffee'),
                        ),
                        DropdownMenuItem(
                          value: 'Pastry',
                          child: Text('Pastry'),
                        ),
                        DropdownMenuItem(
                          value: 'Beverage',
                          child: Text('Beverage'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setSheetState(() => category = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: status,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: _navy),
                      decoration: _fieldDecoration('Status'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Active',
                          child: Text('Active'),
                        ),
                        DropdownMenuItem(
                          value: 'Scheduled',
                          child: Text('Scheduled'),
                        ),
                        DropdownMenuItem(value: 'Past', child: Text('Past')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setSheetState(() => status = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: startDateController,
                      style: const TextStyle(color: _navy),
                      cursorColor: _gold,
                      decoration: _fieldDecoration('Start Date'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: endDateController,
                      style: const TextStyle(color: _navy),
                      cursorColor: _gold,
                      decoration: _fieldDecoration('End Date'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final title = titleController.text.trim();
                          final description = descriptionController.text.trim();
                          if (title.isEmpty || description.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please complete the promo form.',
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _promos = [
                              _TenantPromo(
                                title: title,
                                description: description,
                                status: status,
                                category: category,
                                startDate: startDateController.text.trim(),
                                endDate: endDateController.text.trim(),
                                iconKey: _iconKeyForCategory(category),
                              ),
                              ..._promos,
                            ];
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Promo added successfully.'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _navy,
                          foregroundColor: const Color(0xFFFFD98A),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Save Promo',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditPreview() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit promo will be added later.')),
    );
  }

  void _togglePromoStatus(int index) {
    final current = _promos[index];
    final nextStatus = current.status == 'Active' ? 'Past' : 'Active';
    setState(() {
      _promos[index] = current.copyWith(status: nextStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredPromos = _filteredPromos;
    final activeCount = _promos
        .where((promo) => promo.status == 'Active')
        .length;
    final scheduledCount = _promos
        .where((promo) => promo.status == 'Scheduled')
        .length;
    final pastCount = _promos.where((promo) => promo.status == 'Past').length;

    return ColoredBox(
      color: _surface,
      child: ListView(
        key: const ValueKey('tenant-promo'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
        children: [
          const _PromoIntroCard(),
          const SizedBox(height: 16),
          SizedBox(
            height: 132,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _PromoSummaryCard(
                  icon: Icons.local_offer_outlined,
                  iconColor: AppColors.success,
                  iconBackground: _softGreen,
                  label: 'Active',
                  value: '$activeCount',
                ),
                const SizedBox(width: 12),
                _PromoSummaryCard(
                  icon: Icons.schedule_outlined,
                  iconColor: _blue,
                  iconBackground: _softBlue,
                  label: 'Scheduled',
                  value: '$scheduledCount',
                ),
                const SizedBox(width: 12),
                _PromoSummaryCard(
                  icon: Icons.history_outlined,
                  iconColor: _muted,
                  iconBackground: _softGray,
                  label: 'Past',
                  value: '$pastCount',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          WhitePremiumCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            onTap: _showPromoSheet,
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _softBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.add_rounded, color: _blue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add New Promo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Create a new resident offer',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: _gold),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final filter in const ['Active', 'Scheduled', 'Past']) ...[
                  _PromoFilterChip(
                    label: filter,
                    selected: _filter == filter,
                    onTap: () => setState(() => _filter = filter),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (filteredPromos.isEmpty)
            WhitePremiumCard(
              padding: const EdgeInsets.all(18),
              child: Text(
                'No promos are available for this status yet.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: _muted),
              ),
            )
          else
            for (final promo in filteredPromos) ...[
              TenantPromoCard(
                icon: _iconForKey(promo.iconKey),
                title: promo.title,
                description: promo.description,
                status: promo.status,
                category: promo.category,
                dateLabel: _dateLabelForPromo(promo),
                onEdit: _showEditPreview,
                onStatusAction: () =>
                    _togglePromoStatus(_promos.indexOf(promo)),
                statusActionLabel: promo.status == 'Active'
                    ? 'Pause'
                    : 'Activate',
              ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _PromoIntroCard extends StatelessWidget {
  const _PromoIntroCard();

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          Positioned(
            top: -18,
            right: -10,
            child: Container(
              width: 126,
              height: 126,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [_gold.withValues(alpha: 0.18), Colors.transparent],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F2647), Color(0xFF173A67)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.local_offer_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Promo Management',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: _navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Create campaigns, schedule offers, and boost resident purchases.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: _muted),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _softGreen,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.16),
                  ),
                ),
                child: Text(
                  'Brew Cabin Coffee',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PromoSummaryCard extends StatelessWidget {
  const _PromoSummaryCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 136,
      child: WhitePremiumCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: _navy,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoFilterChip extends StatelessWidget {
  const _PromoFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? _navy : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? _navy : _line),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _navy.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? const Color(0xFFFFD98A) : _navy,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

InputDecoration _fieldDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: _muted),
    floatingLabelStyle: const TextStyle(color: _gold),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _gold),
    ),
  );
}

IconData _iconForKey(String iconKey) {
  return switch (iconKey) {
    'gift' => Icons.redeem_outlined,
    'schedule' => Icons.schedule_outlined,
    'campaign' => Icons.campaign_outlined,
    'history' => Icons.history_outlined,
    _ => Icons.discount_outlined,
  };
}

String _iconKeyForCategory(String category) {
  return switch (category) {
    'Pastry' => 'gift',
    'Beverage' => 'schedule',
    _ => 'discount',
  };
}

String _dateLabelForPromo(_TenantPromo promo) {
  if (promo.status == 'Scheduled' && promo.startDate.isNotEmpty) {
    return 'Starts: ${promo.startDate}  •  Ends: ${promo.endDate}';
  }
  return 'Ends: ${promo.endDate}';
}

class _TenantPromo {
  const _TenantPromo({
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.iconKey,
  });

  final String title;
  final String description;
  final String status;
  final String category;
  final String startDate;
  final String endDate;
  final String iconKey;

  _TenantPromo copyWith({
    String? title,
    String? description,
    String? status,
    String? category,
    String? startDate,
    String? endDate,
    String? iconKey,
  }) {
    return _TenantPromo(
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      iconKey: iconKey ?? this.iconKey,
    );
  }
}
