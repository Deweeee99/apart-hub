import 'package:flutter/material.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/widgets/security/security_checkpoint_card.dart';
import '../../../core/widgets/security/security_patrol_header_card.dart';
import 'patrol_photo_page.dart';

const _patrolSurface = Color(0xFFF8F5EF);
const _patrolNavy = Color(0xFF071B34);
const _patrolMuted = Color(0xFF687184);
const _patrolGold = Color(0xFFC08A1A);

class PatrolManagementPage extends StatefulWidget {
  const PatrolManagementPage({super.key});

  @override
  State<PatrolManagementPage> createState() => _PatrolManagementPageState();
}

class _PatrolManagementPageState extends State<PatrolManagementPage> {
  late final _checkpoints = DemoData.checkpoints.map((item) => item).toList();
  int? _photoCheckpointIndex;

  @override
  Widget build(BuildContext context) {
    if (_photoCheckpointIndex != null) {
      final checkpoint = _checkpoints[_photoCheckpointIndex!];

      return PatrolPhotoPage(
        checkpoint: checkpoint,
        onCancel: () {
          setState(() => _photoCheckpointIndex = null);
        },
        onSubmit: (result) {
          final checkpointIndex = _photoCheckpointIndex!;
          setState(() {
            _checkpoints[checkpointIndex] = _checkpoints[checkpointIndex]
                .copyWith(
                  status: 'Checked',
                  note: result.isDummy
                      ? 'Dummy photo evidence submitted'
                      : 'Photo evidence submitted',
                );
            _photoCheckpointIndex = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Photo evidence submitted for ${result.checkpointName}.',
              ),
            ),
          );
        },
      );
    }

    final checkedCount = _checkpoints
        .where((item) => item.status == 'Checked')
        .length;

    return ColoredBox(
      color: _patrolSurface,
      child: ListView(
        key: const ValueKey('security-patrol'),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
        children: [
          SecurityPatrolHeaderCard(
            checkedCount: checkedCount,
            totalCount: _checkpoints.length,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Checkpoint List',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _patrolNavy,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${_checkpoints.length} checkpoints',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _patrolGold,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Patrol route status and area notes for the current shift.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: _patrolMuted),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < _checkpoints.length; i++)
            SecurityCheckpointCard(
              checkpoint: _checkpoints[i],
              onScan: () => setState(
                () => _checkpoints[i] = _checkpoints[i].copyWith(
                  status: 'Checked',
                  note: 'Condition normal',
                ),
              ),
              onPhoto: () => setState(() => _photoCheckpointIndex = i),
            ),
        ],
      ),
    );
  }
}
