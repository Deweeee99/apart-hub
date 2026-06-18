import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class SecurityScannerFrame extends StatelessWidget {
  const SecurityScannerFrame({
    super.key,
    required this.child,
    this.footer,
    this.showFooter = true,
  });

  final Widget child;
  final Widget? footer;
  final bool showFooter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 292,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.goldMetallic.withValues(alpha: 0.42),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.34),
                  ],
                ),
              ),
            ),
            const _GoldScanCorners(),
            if (showFooter)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 32, 18, 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.56),
                      ],
                    ),
                  ),
                  child:
                      footer ??
                      Text(
                        'Place QR code inside the frame',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GoldScanCorners extends StatelessWidget {
  const _GoldScanCorners();

  @override
  Widget build(BuildContext context) {
    const frameSize = 178.0;
    const cornerLength = 34.0;
    const cornerWidth = 4.0;

    return Center(
      child: SizedBox(
        width: frameSize,
        height: frameSize,
        child: Stack(
          children: const [
            _Corner(
              alignment: Alignment.topLeft,
              length: cornerLength,
              width: cornerWidth,
            ),
            _Corner(
              alignment: Alignment.topRight,
              length: cornerLength,
              width: cornerWidth,
            ),
            _Corner(
              alignment: Alignment.bottomLeft,
              length: cornerLength,
              width: cornerWidth,
            ),
            _Corner(
              alignment: Alignment.bottomRight,
              length: cornerLength,
              width: cornerWidth,
            ),
          ],
        ),
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  const _Corner({
    required this.alignment,
    required this.length,
    required this.width,
  });

  final Alignment alignment;
  final double length;
  final double width;

  @override
  Widget build(BuildContext context) {
    final isRight = alignment.x > 0;
    final isBottom = alignment.y > 0;

    return Align(
      alignment: alignment,
      child: SizedBox(
        width: length,
        height: length,
        child: Stack(
          children: [
            Positioned(
              left: isRight ? null : 0,
              right: isRight ? 0 : null,
              top: isBottom ? null : 0,
              bottom: isBottom ? 0 : null,
              child: Container(
                width: length,
                height: width,
                decoration: BoxDecoration(
                  color: AppColors.softGold,
                  borderRadius: BorderRadius.circular(width),
                ),
              ),
            ),
            Positioned(
              left: isRight ? null : 0,
              right: isRight ? 0 : null,
              top: isBottom ? null : 0,
              bottom: isBottom ? 0 : null,
              child: Container(
                width: width,
                height: length,
                decoration: BoxDecoration(
                  color: AppColors.softGold,
                  borderRadius: BorderRadius.circular(width),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
