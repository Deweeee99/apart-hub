import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/data/data_dummy.dart';
import '../../../core/widgets/white_premium_card.dart';

const _surface = Color(0xFFF8F5EF);
const _navy = Color(0xFF071B34);
const _blue = Color(0xFF173A67);
const _gold = Color(0xFFC08A1A);
const _line = Color(0xFFE7DFD1);
const _muted = Color(0xFF687184);
const _softGold = Color(0xFFFFF6DF);
const _softGreen = Color(0xFFF0F9F1);
const _softBlue = Color(0xFFF0F6FF);

class TenantProfilePage extends StatefulWidget {
  const TenantProfilePage({super.key});

  @override
  State<TenantProfilePage> createState() => _TenantProfilePageState();
}

class _TenantProfilePageState extends State<TenantProfilePage> {
  late _MerchantProfile _profile = _MerchantProfile(
    name: DataDummy.tenantMerchantProfile.name,
    category: DataDummy.tenantMerchantProfile.category,
    location: DataDummy.tenantMerchantProfile.location,
    operatingHours: DataDummy.tenantMerchantProfile.operatingHours,
    phone: DataDummy.tenantMerchantProfile.phone,
    description: DataDummy.tenantMerchantProfile.description,
    rating: DataDummy.tenantMerchantProfile.rating,
    reviewCount: DataDummy.tenantMerchantProfile.reviewCount,
    status: DataDummy.tenantMerchantProfile.status,
  );
  bool _isOnline = DataDummy.tenantMerchantProfile.visibility == 'Online';

  Future<void> _showEditProfileSheet() async {
    final nameController = TextEditingController(text: _profile.name);
    final categoryController = TextEditingController(text: _profile.category);
    final locationController = TextEditingController(text: _profile.location);
    final hoursController = TextEditingController(
      text: _profile.operatingHours,
    );
    final phoneController = TextEditingController(text: _profile.phone);
    final descriptionController = TextEditingController(
      text: _profile.description,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: WhitePremiumCard(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _navy,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: _navy),
                    cursorColor: _gold,
                    decoration: _fieldDecoration('Store Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: categoryController,
                    style: const TextStyle(color: _navy),
                    cursorColor: _gold,
                    decoration: _fieldDecoration('Category'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    style: const TextStyle(color: _navy),
                    cursorColor: _gold,
                    decoration: _fieldDecoration('Location'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: hoursController,
                    style: const TextStyle(color: _navy),
                    cursorColor: _gold,
                    decoration: _fieldDecoration('Operating Hours'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    style: const TextStyle(color: _navy),
                    cursorColor: _gold,
                    decoration: _fieldDecoration('Phone'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    style: const TextStyle(color: _navy),
                    cursorColor: _gold,
                    maxLines: 3,
                    decoration: _fieldDecoration('Description'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _profile = _profile.copyWith(
                            name: nameController.text.trim(),
                            category: categoryController.text.trim(),
                            location: locationController.text.trim(),
                            operatingHours: hoursController.text.trim(),
                            phone: phoneController.text.trim(),
                            description: descriptionController.text.trim(),
                          );
                        });
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Merchant profile updated.'),
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
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text(
                        'Save Profile',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleVisibility() {
    setState(() => _isOnline = !_isOnline);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isOnline
              ? 'Store visibility set to Online.'
              : 'Store visibility set to Offline.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _surface,
      child: ListView(
        key: const ValueKey('tenant-profile'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
        children: [
          _ProfileHeaderCard(profile: _profile, isOnline: _isOnline),
          const SizedBox(height: 16),
          _StoreInformationCard(profile: _profile),
          const SizedBox(height: 16),
          _BrandingSummaryCard(description: _profile.description),
          const SizedBox(height: 16),
          _RatingVisibilitySection(
            rating: _profile.rating,
            reviewCount: _profile.reviewCount,
            status: _profile.status,
            isOnline: _isOnline,
            onToggleVisibility: _toggleVisibility,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showEditProfileSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: _navy,
                foregroundColor: const Color(0xFFFFD98A),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text(
                'Edit Profile',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.profile, required this.isOnline});

  final _MerchantProfile profile;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -8,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A2E1F), Color(0xFF20150F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.local_cafe_outlined,
                      color: Color(0xFFFFD98A),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: _navy,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _muted,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: _gold,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${profile.rating.toStringAsFixed(1)} (${profile.reviewCount})',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: _navy,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatusChip(
                    label: profile.status,
                    background: _softGreen,
                    foreground: AppColors.success,
                  ),
                  _StatusChip(
                    label: isOnline ? 'Online' : 'Offline',
                    background: isOnline ? _softBlue : _softGold,
                    foreground: isOnline ? _blue : _gold,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoreInformationCard extends StatelessWidget {
  const _StoreInformationCard({required this.profile});

  final _MerchantProfile profile;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Store Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: profile.location,
          ),
          Divider(color: _line, height: 20),
          _InfoRow(
            icon: Icons.schedule_outlined,
            label: 'Operating Hours',
            value: profile.operatingHours,
          ),
          Divider(color: _line, height: 20),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: profile.phone,
          ),
          Divider(color: _line, height: 20),
          _InfoRow(
            icon: Icons.category_outlined,
            label: 'Category',
            value: profile.category,
          ),
        ],
      ),
    );
  }
}

class _BrandingSummaryCard extends StatelessWidget {
  const _BrandingSummaryCard({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Branding Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _navy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _muted, height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _StatusChip(
                label: 'Coffee',
                background: _softGold,
                foreground: _gold,
              ),
              _StatusChip(
                label: 'Pastry',
                background: _softBlue,
                foreground: _blue,
              ),
              _StatusChip(
                label: 'Resident Favorite',
                background: _softGreen,
                foreground: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingVisibilitySection extends StatelessWidget {
  const _RatingVisibilitySection({
    required this.rating,
    required this.reviewCount,
    required this.status,
    required this.isOnline,
    required this.onToggleVisibility,
  });

  final double rating;
  final int reviewCount;
  final String status;
  final bool isOnline;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: WhitePremiumCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rating',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${rating.toStringAsFixed(1)} / 5.0',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$reviewCount reviews',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: WhitePremiumCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visibility',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _navy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        status,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Switch(
                      value: isOnline,
                      activeThumbColor: AppColors.success,
                      onChanged: (_) => onToggleVisibility(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _softGold,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _gold, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: _navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w800,
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

class _MerchantProfile {
  const _MerchantProfile({
    required this.name,
    required this.category,
    required this.location,
    required this.operatingHours,
    required this.phone,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.status,
  });

  final String name;
  final String category;
  final String location;
  final String operatingHours;
  final String phone;
  final String description;
  final double rating;
  final int reviewCount;
  final String status;

  _MerchantProfile copyWith({
    String? name,
    String? category,
    String? location,
    String? operatingHours,
    String? phone,
    String? description,
    double? rating,
    int? reviewCount,
    String? status,
  }) {
    return _MerchantProfile(
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      operatingHours: operatingHours ?? this.operatingHours,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      status: status ?? this.status,
    );
  }
}
