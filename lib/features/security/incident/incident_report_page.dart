import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/models/app_models.dart';
import '../../../core/widgets/security/security_evidence_picker_tile.dart';
import '../../../core/widgets/security/security_incident_report_card.dart';
import '../../../core/widgets/white_premium_card.dart';

const _incidentSurface = Color(0xFFF8F5EF);
const _incidentNavy = Color(0xFF071B34);
const _incidentBlue = Color(0xFF173A67);
const _incidentGold = Color(0xFFC08A1A);
const _incidentMuted = Color(0xFF687184);
const _incidentLine = Color(0xFFE7DFD1);

class IncidentReportPage extends StatefulWidget {
  const IncidentReportPage({super.key});

  @override
  State<IncidentReportPage> createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage> {
  late var _incidents = DemoData.incidents.map((item) => item).toList();
  final _incidentEvidenceIds = <String>{};
  final _picker = ImagePicker();
  var _category = 'Kehilangan';
  var _severity = 'Medium';
  final _location = TextEditingController(text: 'Lobby');
  final _description = TextEditingController(
    text: 'Resident melaporkan barang tertinggal.',
  );
  XFile? _evidencePhoto;
  Uint8List? _evidenceBytes;
  bool _isDummyEvidence = false;
  bool _isPickingEvidence = false;

  bool get _mediaPickerSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  bool get _hasEvidence => _evidencePhoto != null || _isDummyEvidence;

  @override
  void dispose() {
    _location.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final openCount = _incidents
        .where((item) => item.status != 'Resolved')
        .length;
    final underReviewCount = _incidents
        .where((item) => item.status == 'Under Review')
        .length;

    return ColoredBox(
      color: _incidentSurface,
      child: ListView(
        key: const ValueKey('security-incident'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
        children: [
          _IncidentHeroCard(
            openCount: openCount,
            underReviewCount: underReviewCount,
          ),
          const SizedBox(height: 18),
          WhitePremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Incident Form',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _incidentNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Record incident details clearly before sending them to management review.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _incidentMuted),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  dropdownColor: Colors.white,
                  iconEnabledColor: _incidentGold,
                  style: const TextStyle(
                    color: _incidentNavy,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: _inputDecoration('Incident category'),
                  items:
                      const [
                            'Kehilangan',
                            'Keributan',
                            'Kerusakan fasilitas',
                            'Kebakaran',
                          ]
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                  onChanged: (value) =>
                      setState(() => _category = value ?? _category),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _location,
                  style: const TextStyle(
                    color: _incidentNavy,
                    fontWeight: FontWeight.w600,
                  ),
                  cursorColor: _incidentGold,
                  decoration: _inputDecoration('Location'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _description,
                  minLines: 3,
                  maxLines: 4,
                  style: const TextStyle(
                    color: _incidentNavy,
                    fontWeight: FontWeight.w600,
                  ),
                  cursorColor: _incidentGold,
                  decoration: _inputDecoration('Description'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _severity,
                  dropdownColor: Colors.white,
                  iconEnabledColor: _incidentGold,
                  style: const TextStyle(
                    color: _incidentNavy,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: _inputDecoration('Severity'),
                  items: const ['Low', 'Medium', 'High', 'Emergency']
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _severity = value ?? _severity),
                ),
                const SizedBox(height: 14),
                SecurityEvidencePickerTile(
                  hasEvidence: _hasEvidence,
                  isDummy: _isDummyEvidence,
                  photoBytes: _evidenceBytes,
                  subtitle: _evidenceSubtitle,
                  onTap: _openEvidenceOptions,
                  onRemove: _hasEvidence ? _clearEvidence : null,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitIncident,
                    icon: const Icon(Icons.report_outlined, size: 18),
                    label: const Text('Submit Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.softGold,
                      foregroundColor: const Color(0xFF17120A),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reports',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _incidentNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${_incidents.length} records',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _incidentGold,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final incident in _incidents)
            SecurityIncidentReportCard(
              incident: incident,
              hasEvidence: _incidentEvidenceIds.contains(incident.id),
            ),
        ],
      ),
    );
  }

  String get _evidenceSubtitle {
    if (_isDummyEvidence) {
      return 'Dummy evidence ready for submission.';
    }
    if (_evidencePhoto != null) {
      return 'Image selected. Ready for submission.';
    }
    return 'Tap to attach camera, gallery, or dummy evidence.';
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _incidentMuted),
      hintStyle: const TextStyle(color: _incidentMuted),
      filled: true,
      fillColor: const Color(0xFFFCFBF8),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: _incidentLine),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: _incidentGold.withValues(alpha: 0.50)),
      ),
    );
  }

  void _submitIncident() {
    final hadEvidence = _hasEvidence;
    final incidentId = 'INC-${2400 + _incidents.length + 1}';
    setState(() {
      _incidents = [
        SecurityIncident(
          id: incidentId,
          category: _category,
          location: _location.text,
          description: _description.text,
          severity: _severity,
          status: 'Reported',
        ),
        ..._incidents,
      ];
      if (hadEvidence) {
        _incidentEvidenceIds.add(incidentId);
      }
      _evidencePhoto = null;
      _evidenceBytes = null;
      _isDummyEvidence = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hadEvidence
              ? 'Incident report submitted with photo evidence.'
              : 'Incident report submitted for review.',
        ),
      ),
    );
  }

  Future<void> _pickEvidenceFromCamera() async {
    if (!_mediaPickerSupported) {
      _showMobileOnlyPickerMessage();
      return;
    }
    await _pickEvidence(ImageSource.camera);
  }

  Future<void> _pickEvidenceFromGallery() async {
    if (!_mediaPickerSupported) {
      _showMobileOnlyPickerMessage();
      return;
    }
    await _pickEvidence(ImageSource.gallery);
  }

  Future<void> _pickEvidence(ImageSource source) async {
    if (_isPickingEvidence) return;
    setState(() => _isPickingEvidence = true);
    try {
      final photo = await _picker.pickImage(source: source, imageQuality: 85);
      if (!mounted) return;
      if (photo != null) {
        final bytes = await photo.readAsBytes();
        if (!mounted) return;
        setState(() {
          _evidencePhoto = photo;
          _evidenceBytes = bytes;
          _isDummyEvidence = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Photo picker is unavailable right now. Use dummy photo for demo.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPickingEvidence = false);
      }
    }
  }

  void _useDummyEvidence() {
    setState(() {
      _evidencePhoto = null;
      _evidenceBytes = null;
      _isDummyEvidence = true;
    });
  }

  void _clearEvidence() {
    setState(() {
      _evidencePhoto = null;
      _evidenceBytes = null;
      _isDummyEvidence = false;
    });
  }

  Future<void> _openEvidenceOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _EvidenceOptionsSheet(
        hasEvidence: _hasEvidence,
        onTakePhoto: () {
          Navigator.of(context).pop();
          _pickEvidenceFromCamera();
        },
        onChooseGallery: () {
          Navigator.of(context).pop();
          _pickEvidenceFromGallery();
        },
        onUseDummy: () {
          Navigator.of(context).pop();
          _useDummyEvidence();
        },
        onRemove: _hasEvidence
            ? () {
                Navigator.of(context).pop();
                _clearEvidence();
              }
            : null,
      ),
    );
  }

  void _showMobileOnlyPickerMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Photo picker is available on mobile. Use dummy photo for desktop demo.',
        ),
      ),
    );
  }
}

class _IncidentHeroCard extends StatelessWidget {
  const _IncidentHeroCard({
    required this.openCount,
    required this.underReviewCount,
  });

  final int openCount;
  final int underReviewCount;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.94),
                const Color(0xFFFBFCFD).withValues(alpha: 0.90),
                _incidentBlue.withValues(alpha: 0.07),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.74)),
            boxShadow: [
              BoxShadow(
                color: _incidentNavy.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -18,
                child: Container(
                  width: 96,
                  height: 66,
                  decoration: BoxDecoration(
                    color: _incidentBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 6,
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: _incidentNavy.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _incidentGold.withValues(alpha: 0.22),
                      ),
                    ),
                    child: const Icon(
                      Icons.report_problem_outlined,
                      color: _incidentGold,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Incident Report',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: _incidentNavy,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Record security incidents, attach evidence, and submit for management review.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: _incidentMuted, height: 1.35),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _HeroPill(
                              icon: Icons.pending_actions_outlined,
                              label: '$openCount open reports',
                            ),
                            _HeroPill(
                              icon: Icons.visibility_outlined,
                              label: '$underReviewCount under review',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _incidentLine),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _incidentGold),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _incidentNavy,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _EvidenceOptionsSheet extends StatelessWidget {
  const _EvidenceOptionsSheet({
    required this.hasEvidence,
    required this.onTakePhoto,
    required this.onChooseGallery,
    required this.onUseDummy,
    this.onRemove,
  });

  final bool hasEvidence;
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseGallery;
  final VoidCallback onUseDummy;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
        child: WhitePremiumCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photo Evidence',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _incidentNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Attach camera, gallery, or dummy evidence for this report.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: _incidentMuted),
              ),
              const SizedBox(height: 16),
              _OptionTile(
                icon: Icons.photo_camera_outlined,
                title: 'Take Photo',
                onTap: onTakePhoto,
              ),
              _OptionTile(
                icon: Icons.photo_library_outlined,
                title: 'Choose From Gallery',
                onTap: onChooseGallery,
              ),
              _OptionTile(
                icon: Icons.image_outlined,
                title: 'Use Dummy Photo',
                onTap: onUseDummy,
              ),
              if (hasEvidence && onRemove != null)
                _OptionTile(
                  icon: Icons.delete_outline,
                  title: 'Remove Evidence',
                  danger: true,
                  onTap: onRemove!,
                ),
              _OptionTile(
                icon: Icons.close_rounded,
                title: 'Cancel',
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.red.shade600 : _incidentNavy;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
