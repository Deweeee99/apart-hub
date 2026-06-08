import 'package:flutter/material.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/models/app_models.dart';
import '../../../core/widgets/luxury_button.dart';
import '../../../core/widgets/premium_step_indicator.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/white_premium_card.dart';

const _serviceBackground = Color(0xFFFAF8F2);
const _serviceNavy = Color(0xFF071B34);
const _serviceGold = Color(0xFFC08A1A);
const _serviceSoftGold = Color(0xFFFFF6DF);
const _serviceMuted = Color(0xFF687184);
const _serviceLine = Color(0xFFE7DFD1);
const _serviceSoftGray = Color(0xFFF2F0EA);

class ServiceRequestPage extends StatefulWidget {
  const ServiceRequestPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<ServiceRequestPage> createState() => _ServiceRequestPageState();
}

class _ServiceRequestPageState extends State<ServiceRequestPage> {
  final _titleController = TextEditingController(text: 'Kitchen sink leakage');
  final _descriptionController = TextEditingController(
    text: 'The kitchen sink is leaking and water keeps dripping.',
  );
  final _commentController = TextEditingController(
    text: 'Very fast response and professional service. Thank you!',
  );
  late List<ServiceTicket> _tickets = DemoData.tickets
      .map((item) => item)
      .toList();

  var _serviceStep = 0;
  var _category = 'Plumbing';
  var _priority = 'Medium';
  var _rating = 5;
  var _isSubmitting = false;
  ServiceTicket? _createdTicket;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ServiceSurface(
      child: ListView(
        key: const ValueKey('resident-service-request'),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          _buildHeader(),
          const SizedBox(height: 14),
          PremiumStepIndicator(
            currentStep: _serviceStep,
            steps: const [
              'Create',
              'Describe',
              'Submitted',
              'Assigned',
              'Progress',
              'Completed',
              'Rate',
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
    setState(() => _serviceStep = step.clamp(0, 6));
  }

  Future<void> _submitRequest() async {
    if (_isSubmitting) {
      return;
    }
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) {
      return;
    }
    final ticket = ServiceTicket(
      id: 'SR-${2400 + _tickets.length + 1}',
      category: _category,
      title: _titleController.text,
      description: _descriptionController.text,
      priority: _priority,
      status: 'Open',
      assignee: 'Waiting assignment',
    );
    setState(() {
      _tickets = [ticket, ..._tickets];
      _createdTicket = ticket;
      _isSubmitting = false;
      _serviceStep = 2;
    });
  }

  Widget _buildStepContent() {
    return switch (_serviceStep) {
      0 => _buildCreateRequest(),
      1 => _buildDescribeIssue(),
      2 => _buildRequestSubmitted(),
      3 => _buildAssignedToStaff(),
      4 => _buildWorkInProgress(),
      5 => _buildCompleted(),
      _ => _buildRateService(),
    };
  }

  Widget _buildHeader() {
    return _FlowHeader(
      title: 'Service Request',
      subtitle: 'Fast, transparent, and efficient issue resolution',
      icon: Icons.home_repair_service_outlined,
      onBack: widget.onBack,
    );
  }

  Widget _buildCreateRequest() {
    final categories = const [
      ('Plumbing', 'Water leakage, pipe repair', Icons.plumbing_outlined),
      ('Electrical', 'Light, power, switch issue', Icons.bolt_outlined),
      (
        'Air Conditioning',
        'AC not cooling, maintenance',
        Icons.ac_unit_outlined,
      ),
      (
        'Housekeeping',
        'Cleaning, room service',
        Icons.cleaning_services_outlined,
      ),
      ('Internet / Wi-Fi', 'Connection problems', Icons.wifi_outlined),
      (
        'General Maintenance',
        'Other maintenance issues',
        Icons.handyman_outlined,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What type of service do you need?',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: _serviceNavy,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        for (final item in categories)
          _ServiceCategoryCard(
            title: item.$1,
            subtitle: item.$2,
            icon: item.$3,
            selected: _category == item.$1,
            onTap: () {
              setState(() {
                _category = item.$1;
                _serviceStep = 1;
              });
            },
          ),
      ],
    );
  }

  Widget _buildDescribeIssue() {
    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            title: 'Describe Issue',
            subtitle: 'Provide issue details and supporting photos.',
            icon: Icons.edit_note_outlined,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Problem title'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            minLines: 4,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Problem description'),
          ),
          const SizedBox(height: 14),
          const _PhotoUploadRow(),
          const SizedBox(height: 14),
          _ChoiceWrap(
            items: const ['Low', 'Medium', 'High', 'Emergency'],
            selected: _priority,
            onSelected: (value) => setState(() => _priority = value),
          ),
          const SizedBox(height: 14),
          const _InfoPanel(
            icon: Icons.calendar_month_outlined,
            title: 'Preferred Schedule',
            subtitle: '07 Jun 2026 - 10:00 AM - 12:00 PM',
            status: 'Available',
          ),
          const SizedBox(height: 16),
          LuxuryButton(
            label: _isSubmitting ? 'Submitting...' : 'Submit Request',
            icon: Icons.send_outlined,
            onPressed: _submitRequest,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestSubmitted() {
    final ticket = _activeTicket;
    return WhitePremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const _SuccessIcon(icon: Icons.send_outlined),
          const SizedBox(height: 18),
          Text(
            'Ticket Created!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF218D4F),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your service request has been submitted successfully.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _serviceMuted),
          ),
          const SizedBox(height: 18),
          _DetailPanel(
            rows: [
              ('Ticket Number', ticket?.id ?? 'SR-20260607-001'),
              ('Status', ticket?.status ?? 'Open'),
            ],
          ),
          const SizedBox(height: 18),
          LuxuryButton(
            label: 'View Details',
            icon: Icons.visibility_outlined,
            onPressed: () => _goToStep(3),
          ),
          const SizedBox(height: 10),
          _OutlineActionButton(
            label: 'Back to Services',
            icon: Icons.arrow_back_outlined,
            onPressed: widget.onBack,
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedToStaff() {
    return Column(
      children: [
        WhitePremiumCard(
          child: Column(
            children: [
              const _CardTitle(
                title: 'Assigned to Staff',
                subtitle: 'Your request has been assigned to a technician.',
                icon: Icons.engineering_outlined,
              ),
              const SizedBox(height: 18),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: _serviceSoftGold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: _serviceGold,
                  size: 52,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'John Technical',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _serviceNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Maintenance Technician',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: _serviceMuted),
              ),
              const SizedBox(height: 8),
              Text(
                '4.8 (126)',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _serviceGold,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              const _InfoPanel(
                icon: Icons.timer_outlined,
                title: 'Estimated Arrival Time',
                subtitle: '30 - 45 Minutes',
                status: 'On the way',
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _OutlineActionButton(
          label: 'Contact Technician',
          icon: Icons.phone_outlined,
          onPressed: () => _showServiceSnack('Contact technician simulated.'),
        ),
        const SizedBox(height: 10),
        LuxuryButton(
          label: 'Track Progress',
          icon: Icons.route_outlined,
          onPressed: () => _goToStep(4),
        ),
      ],
    );
  }

  Widget _buildWorkInProgress() {
    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            title: 'Work In Progress',
            subtitle: 'Technician is working on your request.',
            icon: Icons.construction_outlined,
          ),
          const SizedBox(height: 16),
          const _InfoPanel(
            icon: Icons.engineering_outlined,
            title: 'Technician on Site',
            subtitle: '10:15 AM',
            status: 'In Progress',
          ),
          const SizedBox(height: 16),
          const _ProgressTimeline(activeIndex: 1),
          const SizedBox(height: 16),
          Container(
            height: 126,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _serviceSoftGray,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _serviceLine),
            ),
            child: const Center(
              child: Icon(Icons.location_pin, color: _serviceGold, size: 44),
            ),
          ),
          const SizedBox(height: 16),
          LuxuryButton(
            label: 'Mark as Completed',
            icon: Icons.check_circle_outline,
            onPressed: () => _goToStep(5),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleted() {
    return WhitePremiumCard(
      child: Column(
        children: [
          const _SuccessIcon(icon: Icons.check_rounded),
          const SizedBox(height: 18),
          Text(
            'Request Completed',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF218D4F),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'The issue has been resolved successfully.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: _serviceMuted),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(child: _BeforeAfterBox(label: 'Before')),
              SizedBox(width: 10),
              Expanded(child: _BeforeAfterBox(label: 'After')),
            ],
          ),
          const SizedBox(height: 18),
          _DetailPanel(
            rows: [
              ('Completed By', 'John Technical'),
              ('Completed At', '07 Jun 2026, 11:25 AM'),
              ('Note', 'Leakage issue has been fixed and tested successfully.'),
            ],
          ),
          const SizedBox(height: 18),
          LuxuryButton(
            label: 'Close Request',
            icon: Icons.star_outline,
            onPressed: () => _goToStep(6),
          ),
        ],
      ),
    );
  }

  Widget _buildRateService() {
    return Column(
      children: [
        WhitePremiumCard(
          child: Column(
            children: [
              const _CardTitle(
                title: 'Rate Service',
                subtitle: 'How was your experience with our service?',
                icon: Icons.star_outline,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 5; i++)
                    IconButton(
                      onPressed: () => setState(() => _rating = i),
                      icon: Icon(
                        i <= _rating ? Icons.star : Icons.star_border,
                        color: _serviceGold,
                        size: 30,
                      ),
                    ),
                ],
              ),
              Text(
                _rating >= 5 ? 'Excellent!' : 'Thank you!',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _serviceNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                minLines: 4,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Add comment (Optional)',
                ),
              ),
              const SizedBox(height: 16),
              LuxuryButton(
                label: 'Submit Rating',
                icon: Icons.send_outlined,
                onPressed: () {
                  _showServiceSnack('Thank you for your feedback.');
                  widget.onBack();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _buildTicketHistory(),
      ],
    );
  }

  Widget _buildTicketHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: 'Ticket History',
          actionLabel: 'Latest',
          icon: Icons.history_outlined,
        ),
        const SizedBox(height: 12),
        for (final ticket in _tickets.take(4))
          _InfoPanel(
            icon: Icons.build_circle_outlined,
            title: '${ticket.id} - ${ticket.title}',
            subtitle: '${ticket.category} - ${ticket.priority}',
            status: ticket.status,
          ),
      ],
    );
  }

  void _showServiceSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  ServiceTicket? get _activeTicket => _createdTicket ?? _tickets.firstOrNull;
}

class _ServiceSurface extends StatelessWidget {
  const _ServiceSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: _serviceBackground,
        textTheme: Theme.of(
          context,
        ).textTheme.apply(bodyColor: _serviceNavy, displayColor: _serviceNavy),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: _serviceMuted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _serviceLine),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _serviceGold, width: 1.2),
          ),
        ),
      ),
      child: ColoredBox(color: _serviceBackground, child: child),
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
            icon: const Icon(Icons.arrow_back, color: _serviceNavy),
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
                    color: _serviceNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _serviceMuted,
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

class _ServiceCategoryCard extends StatelessWidget {
  const _ServiceCategoryCard({
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
                    color: _serviceNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _serviceMuted),
                ),
              ],
            ),
          ),
          Icon(
            selected ? Icons.check_circle : Icons.chevron_right,
            color: _serviceGold,
          ),
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
                  color: _serviceNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _serviceMuted,
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

class _PhotoUploadRow extends StatelessWidget {
  const _PhotoUploadRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < 3; i++) ...[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: _serviceSoftGray,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _serviceLine),
                ),
                child: Icon(
                  Icons.image_outlined,
                  color: _serviceGold.withValues(alpha: 0.72),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _serviceLine),
              ),
              child: const Icon(Icons.add, color: _serviceGold),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressTimeline extends StatelessWidget {
  const _ProgressTimeline({required this.activeIndex});

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final steps = const [
      'Inspection',
      'Repairing',
      'Quality Check',
      'Completed',
    ];
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    i <= activeIndex
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: i <= activeIndex ? _serviceGold : _serviceMuted,
                    size: 22,
                  ),
                  if (i != steps.length - 1)
                    Container(width: 1, height: 28, color: _serviceLine),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    steps[i],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: i == activeIndex ? _serviceNavy : _serviceMuted,
                      fontWeight: i == activeIndex
                          ? FontWeight.w900
                          : FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _BeforeAfterBox extends StatelessWidget {
  const _BeforeAfterBox({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.12,
      child: Container(
        decoration: BoxDecoration(
          color: _serviceSoftGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _serviceLine),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _serviceNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
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
        color: _serviceSoftGray,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _serviceLine),
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
      margin: const EdgeInsets.only(bottom: 10),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _serviceNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _serviceMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          StatusBadge(status: status),
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
        Icon(icon, color: _serviceGold, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: _serviceNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          actionLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: _serviceMuted,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
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
      color: selected ? _serviceSoftGold : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: selected ? _serviceGold.withValues(alpha: 0.55) : _serviceLine,
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
              color: selected ? _serviceNavy : _serviceMuted,
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
          foregroundColor: _serviceNavy,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          side: const BorderSide(color: _serviceLine),
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
              color: _serviceMuted,
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
              color: _serviceNavy,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon({required this.icon});

  final IconData icon;

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
      child: Icon(icon, color: const Color(0xFF218D4F), size: 52),
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
        color: _serviceSoftGold,
        borderRadius: BorderRadius.circular(size * 0.34),
        border: Border.all(color: _serviceGold.withValues(alpha: 0.32)),
      ),
      child: Icon(icon, color: _serviceGold, size: size * 0.54),
    );
  }
}
