import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/models/app_models.dart';
import '../../../core/widgets/luxury_button.dart';
import '../../../core/widgets/premium_qr_card.dart';
import '../../../core/widgets/premium_step_indicator.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/white_premium_card.dart';

final _facilityDate = DateFormat('d MMM yyyy', 'id_ID');

const _facilityBackground = Color(0xFFFAF8F2);
const _facilityNavy = Color(0xFF071B34);
const _facilityGold = Color(0xFFC08A1A);
const _facilitySoftGold = Color(0xFFFFF6DF);
const _facilityMuted = Color(0xFF687184);
const _facilityLine = Color(0xFFE7DFD1);
const _facilitySoftGray = Color(0xFFF2F0EA);

class FacilityBookingPage extends StatefulWidget {
  const FacilityBookingPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<FacilityBookingPage> createState() => _FacilityBookingPageState();
}

class _FacilityBookingPageState extends State<FacilityBookingPage> {
  final _notesController = TextEditingController();
  late List<FacilityBooking> _bookings = DemoData.bookings
      .where((item) => item.residentName == 'Jonathan Wijaya')
      .toList();

  var _facilityStep = 0;
  var _facility = 'Kolam Renang';
  var _slot = '09:00 - 11:00';
  var _guestCount = 2;
  var _bookingFilter = 'Upcoming';
  FacilityBooking? _createdBooking;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FacilitySurface(
      child: ListView(
        key: const ValueKey('resident-facility-booking'),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          _buildHeader(),
          const SizedBox(height: 14),
          PremiumStepIndicator(
            currentStep: _facilityStep,
            steps: const [
              'Select',
              'Availability',
              'Date & Time',
              'Confirm',
              'Approved',
              'Bookings',
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
    setState(() => _facilityStep = step.clamp(0, 5));
  }

  void _confirmBooking() {
    final booking = FacilityBooking(
      id: 'BK-${1000 + _bookings.length + 1}',
      facility: _facility,
      date: DateTime(2026, 6, 7),
      slot: _slot,
      status: 'Approved',
      residentName: 'Jonathan Wijaya',
    );
    setState(() {
      _bookings = [booking, ..._bookings];
      _createdBooking = booking;
      _facilityStep = 4;
    });
  }

  Widget _buildStepContent() {
    return switch (_facilityStep) {
      0 => _buildSelectFacility(),
      1 => _buildViewAvailability(),
      2 => _buildChooseDateTime(),
      3 => _buildConfirmBooking(),
      4 => _buildBookingApproved(),
      _ => _buildMyBookings(),
    };
  }

  Widget _buildHeader() {
    return _FlowHeader(
      title: 'Booking Facility',
      subtitle: 'Easy, smart, and hassle-free reservations',
      icon: Icons.event_available_outlined,
      onBack: widget.onBack,
    );
  }

  Widget _buildSelectFacility() {
    final facilities = const [
      ('Gym', 'Stay fit and healthy', Icons.fitness_center_outlined),
      ('Tennis Court', 'Book your game time', Icons.sports_tennis_outlined),
      ('Meeting Room', 'For meetings and events', Icons.meeting_room_outlined),
      ('Function Hall', 'Events and gatherings', Icons.celebration_outlined),
      ('Sky Lounge', 'Enjoy the best view', Icons.deck_outlined),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a facility to proceed with your booking.',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: _facilityNavy,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        for (final item in facilities)
          _FacilityCard(
            title: item.$1,
            subtitle: item.$2,
            icon: item.$3,
            selected: _facility == item.$1,
            onTap: () {
              setState(() {
                _facility = item.$1;
                _facilityStep = 1;
              });
            },
          ),
      ],
    );
  }

  Widget _buildViewAvailability() {
    final slots = const [
      ('07:00 - 09:00', 'Available'),
      ('09:00 - 11:00', 'Available'),
      ('11:00 - 13:00', 'Booked'),
      ('13:00 - 15:00', 'Available'),
      ('15:00 - 17:00', 'Available'),
    ];
    return Column(
      children: [
        _SelectedFacilityCard(facility: _facility),
        const SizedBox(height: 14),
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardTitle(
                title: 'June 2026',
                subtitle: 'Check available dates and time slots.',
                icon: Icons.calendar_month_outlined,
              ),
              const SizedBox(height: 16),
              const _CalendarGrid(),
              const SizedBox(height: 16),
              for (final slot in slots)
                _SlotCard(
                  slot: slot.$1,
                  status: slot.$2,
                  selected: _slot == slot.$1,
                  onTap: slot.$2 == 'Available'
                      ? () => setState(() => _slot = slot.$1)
                      : null,
                ),
              const SizedBox(height: 8),
              LuxuryButton(
                label: 'Continue',
                icon: Icons.arrow_forward_outlined,
                onPressed: () => _goToStep(2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChooseDateTime() {
    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SelectedFacilityCard(facility: _facility),
          const SizedBox(height: 16),
          const _InfoPanel(
            icon: Icons.calendar_today_outlined,
            title: 'Date',
            subtitle: '07 June 2026',
            status: 'Selected',
          ),
          _ChoiceWrap(
            items: const [
              '07:00 - 09:00',
              '09:00 - 11:00',
              '13:00 - 15:00',
              '15:00 - 17:00',
            ],
            selected: _slot,
            onSelected: (value) => setState(() => _slot = value),
          ),
          const SizedBox(height: 16),
          _GuestStepper(
            value: _guestCount,
            onMinus: _guestCount <= 1
                ? null
                : () => setState(() => _guestCount--),
            onPlus: _guestCount >= 4
                ? null
                : () => setState(() => _guestCount++),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _notesController,
            minLines: 3,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Notes (Optional)'),
          ),
          const SizedBox(height: 16),
          LuxuryButton(
            label: 'Continue',
            icon: Icons.arrow_forward_outlined,
            onPressed: () => _goToStep(3),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmBooking() {
    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            title: 'Confirm Booking',
            subtitle: 'Review reservation details before booking.',
            icon: Icons.fact_check_outlined,
          ),
          const SizedBox(height: 16),
          _DetailPanel(
            rows: [
              ('Facility', _facility),
              ('Location', _facilityLocation),
              ('Date', '07 Jun 2026'),
              ('Time', _slot),
              ('Guests', '$_guestCount Persons'),
              ('Total Duration', '2 Hours'),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _facilitySoftGold,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _facilityGold.withValues(alpha: 0.25)),
            ),
            child: Text(
              'Please arrive 10 minutes before booking time. Cancellation must be made at least 2 hours in advance.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _facilityNavy,
                height: 1.38,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          LuxuryButton(
            label: 'Confirm Booking',
            icon: Icons.check_circle_outline,
            onPressed: _confirmBooking,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingApproved() {
    final booking = _createdBooking;
    return Column(
      children: [
        WhitePremiumCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const _SuccessIcon(),
              const SizedBox(height: 18),
              Text(
                'Booking Confirmed!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF218D4F),
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your reservation has been successfully confirmed.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: _facilityMuted),
              ),
              const SizedBox(height: 18),
              _DetailPanel(
                rows: [
                  ('Reservation ID', booking?.id ?? 'BK-20260607-001'),
                  ('Status', booking?.status ?? 'Approved'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumQrCard(
          title: 'Booking QR',
          code: booking?.id ?? 'BK-20260607-001',
          accessType: _facility,
          visitorName: 'Jonathan Wijaya',
          schedule: '07 Jun 2026, $_slot',
          status: 'APPROVED',
          countdownText: null,
        ),
        const SizedBox(height: 14),
        LuxuryButton(
          label: 'View Booking Details',
          icon: Icons.visibility_outlined,
          onPressed: () => _goToStep(5),
        ),
        const SizedBox(height: 10),
        _OutlineActionButton(
          label: 'Back to Services',
          icon: Icons.arrow_back_outlined,
          onPressed: widget.onBack,
        ),
      ],
    );
  }

  Widget _buildMyBookings() {
    final items = _bookings.where((booking) {
      if (_bookingFilter == 'Past') {
        return booking.date.isBefore(DateTime(2026, 6, 7));
      }
      return !booking.date.isBefore(DateTime(2026, 6, 7));
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WhitePremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardTitle(
                title: 'My Bookings',
                subtitle: 'View upcoming and past reservations.',
                icon: Icons.list_alt_outlined,
              ),
              const SizedBox(height: 16),
              _ChoiceWrap(
                items: const ['Upcoming', 'Past'],
                selected: _bookingFilter,
                onSelected: (value) => setState(() => _bookingFilter = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (items.isEmpty)
          const WhitePremiumCard(child: Text('No bookings in this filter.'))
        else
          for (final booking in items) _BookingCard(booking: booking),
        const SizedBox(height: 4),
        _OutlineActionButton(
          label: 'View Calendar',
          icon: Icons.calendar_month_outlined,
          onPressed: () => _showFacilitySnack('Calendar view simulated.'),
        ),
        const SizedBox(height: 10),
        LuxuryButton(
          label: 'Back to Services',
          icon: Icons.arrow_back_outlined,
          onPressed: widget.onBack,
        ),
      ],
    );
  }

  void _showFacilitySnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String get _facilityLocation {
    return switch (_facility) {
      'Kolam Renang' => 'Level 5',
      'Gym' => 'Level 3',
      'Tennis Court' => 'Level 4',
      'Meeting Room' => 'Level 2',
      'Function Hall' => 'Ground Floor',
      _ => 'Rooftop',
    };
  }
}

class _FacilitySurface extends StatelessWidget {
  const _FacilitySurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: _facilityBackground,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: _facilityNavy,
          displayColor: _facilityNavy,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: _facilityMuted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _facilityLine),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _facilityGold, width: 1.2),
          ),
        ),
      ),
      child: ColoredBox(color: _facilityBackground, child: child),
    );
  }
}

class _FlowHeader extends StatelessWidget {
  const _FlowHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: _facilityNavy),
          ),
          _GoldIcon(icon: icon, size: 48),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _facilityNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _facilityMuted,
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

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({
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
          _GoldIcon(icon: icon, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _facilityNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _facilityMuted),
                ),
              ],
            ),
          ),
          Icon(
            selected ? Icons.check_circle : Icons.chevron_right,
            color: _facilityGold,
          ),
        ],
      ),
    );
  }
}

class _SelectedFacilityCard extends StatelessWidget {
  const _SelectedFacilityCard({required this.facility});

  final String facility;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _facilityNavy,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(Icons.pool_outlined, color: _facilityGold),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              facility,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            'Selected',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (var i = 1; i <= 21; i++)
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: i == 7 ? _facilityGold : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: _facilityLine),
            ),
            child: Text(
              '$i',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: i == 7 ? Colors.white : _facilityNavy,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({
    required this.slot,
    required this.status,
    required this.selected,
    required this.onTap,
  });

  final String slot;
  final String status;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              slot,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? _facilityGold : _facilityNavy,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          StatusBadge(status: status),
        ],
      ),
    );
  }
}

class _GuestStepper extends StatelessWidget {
  const _GuestStepper({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final int value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _facilitySoftGray,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _facilityLine),
      ),
      child: Row(
        children: [
          Text(
            'Guests (Max 4)',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _facilityNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          IconButton(onPressed: onMinus, icon: const Icon(Icons.remove)),
          Text(
            '$value',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _facilityNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
          IconButton(onPressed: onPlus, icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final FacilityBooking booking;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _GoldIcon(icon: Icons.event_available_outlined, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.facility,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _facilityNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_facilityDate.format(booking.date)} - ${booking.slot}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _facilityMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          StatusBadge(status: booking.status),
        ],
      ),
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
                  color: _facilityNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _facilityMuted,
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

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String status;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
                    color: _facilityNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _facilityMuted),
                ),
              ],
            ),
          ),
          StatusBadge(status: status),
        ],
      ),
    );
  }
}

class _DetailPanel extends StatelessWidget {
  const _DetailPanel({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _facilitySoftGray,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _facilityLine),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _InfoRow(label: rows[i].$1, value: rows[i].$2),
            if (i != rows.length - 1) const SizedBox(height: 10),
          ],
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
      color: selected ? _facilitySoftGold : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: selected
              ? _facilityGold.withValues(alpha: 0.55)
              : _facilityLine,
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
              color: selected ? _facilityNavy : _facilityMuted,
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
          foregroundColor: _facilityNavy,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          side: const BorderSide(color: _facilityLine),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _facilityMuted,
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
              color: _facilityNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _GoldIcon extends StatelessWidget {
  const _GoldIcon({required this.icon, this.size = 40});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _facilitySoftGold,
        borderRadius: BorderRadius.circular(size * 0.34),
        border: Border.all(color: _facilityGold.withValues(alpha: 0.32)),
      ),
      child: Icon(icon, color: _facilityGold, size: size * 0.54),
    );
  }
}
