import 'package:flutter/material.dart';

const _stepNavy = Color(0xFF071B34);
const _stepGold = Color(0xFFC08A1A);
const _stepSoftGold = Color(0xFFFFF6DF);
const _stepMuted = Color(0xFF687184);
const _stepLine = Color(0xFFE7DFD1);
const _stepSoftGray = Color(0xFFF2F0EA);

class PremiumStepIndicator extends StatelessWidget {
  const PremiumStepIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onStepSelected,
  });

  final int currentStep;
  final List<String> steps;
  final ValueChanged<int>? onStepSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: steps.length,
        separatorBuilder: (_, _) => const _StepConnector(),
        itemBuilder: (context, index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;
          return _StepNode(
            label: steps[index],
            number: index + 1,
            isActive: isActive,
            isCompleted: isCompleted,
            onTap: onStepSelected == null
                ? null
                : () => onStepSelected?.call(index),
          );
        },
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 20,
        height: 1.2,
        color: _stepGold.withValues(alpha: 0.36),
      ),
    );
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({
    required this.label,
    required this.number,
    required this.isActive,
    required this.isCompleted,
    required this.onTap,
  });

  final String label;
  final int number;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final circleColor = isActive
        ? _stepGold
        : isCompleted
        ? _stepSoftGold
        : _stepSoftGray;
    final borderColor = isActive || isCompleted
        ? _stepGold.withValues(alpha: 0.58)
        : _stepLine;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: Text(
                '$number',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive ? Colors.white : _stepNavy,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isActive ? _stepNavy : _stepMuted,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
