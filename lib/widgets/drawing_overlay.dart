// drawing_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visual_dp/providers/drawing_provider.dart';

class DrawingOverlay extends ConsumerWidget {
  const DrawingOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(drawingPointsProvider);

    return GestureDetector(
      onPanUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final point = box.globalToLocal(details.globalPosition);
        ref.read(drawingPointsProvider.notifier).update((state) => [...state, point]);
      },
      onPanEnd: (_) {
        ref.read(drawingPointsProvider.notifier).update((state) => [...state, null]);
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: _DrawingPainter(points),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent // bright laser-like color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) => true;
}
