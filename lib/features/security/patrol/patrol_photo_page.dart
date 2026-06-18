import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/models/app_models.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/white_premium_card.dart';

const _photoSurface = Color(0xFFF8F5EF);
const _photoNavy = Color(0xFF071B34);
const _photoBlue = Color(0xFF173A67);
const _photoGold = Color(0xFFC08A1A);
const _photoMuted = Color(0xFF687184);
const _photoLine = Color(0xFFE7DFD1);

class PatrolPhotoResult {
  const PatrolPhotoResult({
    required this.checkpointName,
    required this.note,
    required this.submittedAt,
    this.photoPath,
    this.isDummy = false,
  });

  final String checkpointName;
  final String note;
  final DateTime submittedAt;
  final String? photoPath;
  final bool isDummy;
}

class PatrolPhotoPage extends StatefulWidget {
  const PatrolPhotoPage({
    super.key,
    required this.checkpoint,
    required this.onCancel,
    required this.onSubmit,
  });

  final PatrolCheckpoint checkpoint;
  final VoidCallback onCancel;
  final ValueChanged<PatrolPhotoResult> onSubmit;

  @override
  State<PatrolPhotoPage> createState() => _PatrolPhotoPageState();
}

class _PatrolPhotoPageState extends State<PatrolPhotoPage> {
  final _picker = ImagePicker();
  final _notesController = TextEditingController(
    text: 'Area condition documented.',
  );

  XFile? _capturedPhoto;
  bool _isDummyPhoto = false;
  bool _isPicking = false;

  bool get _cameraCaptureSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  bool get _canSubmit => _capturedPhoto != null || _isDummyPhoto;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _photoSurface,
      child: ListView(
        key: const ValueKey('security-patrol-photo'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
        children: [
          _PhotoHeroCard(checkpoint: widget.checkpoint),
          const SizedBox(height: 18),
          _CheckpointSummaryCard(checkpoint: widget.checkpoint),
          const SizedBox(height: 18),
          WhitePremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Area Evidence',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _photoNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _capturedPhoto == null && !_isDummyPhoto
                      ? 'Take a clear photo of this checkpoint area.'
                      : 'Review the captured evidence before submitting.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: _photoMuted),
                ),
                const SizedBox(height: 16),
                _EvidencePreview(
                  photoPath: _capturedPhoto?.path,
                  isDummy: _isDummyPhoto,
                ),
                const SizedBox(height: 16),
                if (_capturedPhoto == null && !_isDummyPhoto)
                  _CaptureActions(
                    canUseCamera: _cameraCaptureSupported,
                    isPicking: _isPicking,
                    onTakePhoto: _takePhoto,
                    onUseDummy: _useDummyPhoto,
                  )
                else
                  _PreviewActions(
                    canSubmit: _canSubmit,
                    isPicking: _isPicking,
                    onRetake: _cameraCaptureSupported
                        ? _takePhoto
                        : _useDummyPhoto,
                    onSubmit: _submitEvidence,
                    retakeLabel: _cameraCaptureSupported
                        ? 'Retake Photo'
                        : 'Use Dummy Again',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          WhitePremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Evidence Notes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _photoNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
               TextField(
                  controller: _notesController,
                  minLines: 3,
                  maxLines: 4,
                  cursorColor: _photoGold,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _photoNavy,
                        fontWeight: FontWeight.w600,
                      ),
                  decoration: InputDecoration(
                    hintText: 'Add a short note for management review',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _photoMuted.withValues(alpha: 0.65),
                          fontWeight: FontWeight.w500,
                        ),
                    filled: true,
                    fillColor: const Color(0xFFFCFBF8),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: _photoLine),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: _photoGold.withValues(alpha: 0.48),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onCancel,
                  icon: const Icon(Icons.arrow_back_outlined, size: 18),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _photoNavy,
                    side: const BorderSide(color: _photoLine),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _canSubmit ? _submitEvidence : null,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Submit Evidence'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    disabledBackgroundColor: _photoLine,
                    disabledForegroundColor: _photoMuted.withValues(alpha: 0.6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    if (!_cameraCaptureSupported || _isPicking) return;
    setState(() => _isPicking = true);
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (!mounted) return;
      if (photo != null) {
        setState(() {
          _capturedPhoto = photo;
          _isDummyPhoto = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Camera capture is unavailable right now. Use dummy photo for demo.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  void _useDummyPhoto() {
    setState(() {
      _capturedPhoto = null;
      _isDummyPhoto = true;
    });
  }

  void _submitEvidence() {
    if (!_canSubmit) return;
    widget.onSubmit(
      PatrolPhotoResult(
        checkpointName: widget.checkpoint.name,
        note: _notesController.text.trim().isEmpty
            ? 'Area condition documented.'
            : _notesController.text.trim(),
        submittedAt: DateTime.now(),
        photoPath: _capturedPhoto?.path,
        isDummy: _isDummyPhoto,
      ),
    );
  }
}

class _PhotoHeroCard extends StatelessWidget {
  const _PhotoHeroCard({required this.checkpoint});

  final PatrolCheckpoint checkpoint;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.94),
                const Color(0xFFFBFCFD).withValues(alpha: 0.90),
                _photoBlue.withValues(alpha: 0.07),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.74)),
            boxShadow: [
              BoxShadow(
                color: _photoNavy.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: _photoNavy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _photoGold.withValues(alpha: 0.22)),
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  color: _photoGold,
                  size: 29,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Checkpoint Photo',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _photoNavy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Capture area evidence for management review at ${checkpoint.name}.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _photoMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckpointSummaryCard extends StatelessWidget {
  const _CheckpointSummaryCard({required this.checkpoint});

  final PatrolCheckpoint checkpoint;

  @override
  Widget build(BuildContext context) {
    return WhitePremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  checkpoint.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _photoNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              StatusBadge(status: checkpoint.status),
            ],
          ),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Area', value: checkpoint.area),
          _SummaryRow(label: 'Current Note', value: checkpoint.note),
        ],
      ),
    );
  }
}

class _EvidencePreview extends StatelessWidget {
  const _EvidencePreview({required this.photoPath, required this.isDummy});

  final String? photoPath;
  final bool isDummy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF202B39),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _photoGold.withValues(alpha: 0.26)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Builder(
          builder: (context) {
            if (photoPath != null && !kIsWeb) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(photoPath!), fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.36),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            if (isDummy) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _photoBlue.withValues(alpha: 0.55),
                      _photoNavy.withValues(alpha: 0.82),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image_outlined,
                      color: Colors.white,
                      size: 58,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Dummy evidence preview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Camera capture is available on mobile. This desktop preview is used for the demo flow.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.photo_camera_outlined,
                    color: AppColors.softGold,
                    size: 64,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Take a clear photo of this checkpoint area.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CaptureActions extends StatelessWidget {
  const _CaptureActions({
    required this.canUseCamera,
    required this.isPicking,
    required this.onTakePhoto,
    required this.onUseDummy,
  });

  final bool canUseCamera;
  final bool isPicking;
  final VoidCallback onTakePhoto;
  final VoidCallback onUseDummy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: canUseCamera && !isPicking ? onTakePhoto : null,
          icon: const Icon(Icons.camera_alt_outlined, size: 18),
          label: Text(isPicking ? 'Opening Camera...' : 'Take Photo'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.softGold,
            disabledBackgroundColor: _photoLine,
            disabledForegroundColor: _photoMuted.withValues(alpha: 0.6),
            foregroundColor: const Color(0xFF17120A),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        if (!canUseCamera) ...[
          const SizedBox(height: 12),
          Text(
            'Camera capture is available on mobile. Use dummy photo for desktop demo.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: _photoMuted, height: 1.35),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onUseDummy,
            icon: const Icon(Icons.image_outlined, size: 18),
            label: const Text('Use Dummy Photo'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _photoGold,
              side: BorderSide(color: _photoGold.withValues(alpha: 0.42)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PreviewActions extends StatelessWidget {
  const _PreviewActions({
    required this.canSubmit,
    required this.isPicking,
    required this.onRetake,
    required this.onSubmit,
    required this.retakeLabel,
  });

  final bool canSubmit;
  final bool isPicking;
  final VoidCallback onRetake;
  final VoidCallback onSubmit;
  final String retakeLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 340;
        final buttons = [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isPicking ? null : onRetake,
              icon: const Icon(Icons.refresh_outlined, size: 18),
              label: Text(retakeLabel, overflow: TextOverflow.ellipsis),
              style: OutlinedButton.styleFrom(
                foregroundColor: _photoGold,
                side: BorderSide(color: _photoGold.withValues(alpha: 0.42)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: canSubmit ? onSubmit : null,
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Submit Evidence'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                disabledBackgroundColor: _photoLine,
                disabledForegroundColor: _photoMuted.withValues(alpha: 0.6),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ];

        if (!stacked) {
          return Row(children: buttons);
        }

        return Column(
          children: [
            OutlinedButton.icon(
              onPressed: isPicking ? null : onRetake,
              icon: const Icon(Icons.refresh_outlined, size: 18),
              label: Text(retakeLabel, overflow: TextOverflow.ellipsis),
              style: OutlinedButton.styleFrom(
                foregroundColor: _photoGold,
                side: BorderSide(color: _photoGold.withValues(alpha: 0.42)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: canSubmit ? onSubmit : null,
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Submit Evidence'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                disabledBackgroundColor: _photoLine,
                disabledForegroundColor: _photoMuted.withValues(alpha: 0.6),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _photoGold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _photoNavy,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
