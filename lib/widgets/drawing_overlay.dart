import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/drawing_provider.dart';

/// Full-screen overlay that handles input and paints with ultra-low latency.
/// Uses CustomPainter's `repaint` to avoid rebuilding widgets while drawing.
class DrawingOverlay extends ConsumerWidget {
  const DrawingOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We only need the instance; painting will subscribe via `repaint`.
    final drawing = ref.read(drawingProvider);

    Offset _toLocal(Offset global, BuildContext ctx) {
      final box = ctx.findRenderObject() as RenderBox;
      return box.globalToLocal(global);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque, // ensure we capture touches everywhere
      onPanStart: (details) {
        final p = _toLocal(details.globalPosition, context);
        drawing.addPoint(p); // draw immediately on touch down
      },
      onPanUpdate: (details) {
        final p = _toLocal(details.globalPosition, context);
        drawing.addPoint(p); // continuous points -> smooth line
      },
      onPanEnd: (_) {
        drawing.endStroke();
      },
      child: SizedBox.expand(
        child: CustomPaint(
          // Pass the provider as the painter’s repaint Listenable for low latency
          painter: _LaserPainter(drawing),
        ),
      ),
    );
  }
}

class _LaserPainter extends CustomPainter {
  final DrawingProvider drawing;

  _LaserPainter(this.drawing) : super(repaint: drawing);

  @override
  void paint(Canvas canvas, Size size) {
    final pts = drawing.points;

    // Glow (outer) stroke — cyan-ish laser glow
    final glow = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.8)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
      ..isAntiAlias = true;

    // Core (inner) stroke — bright white
    final core = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    for (int i = 0; i < pts.length - 1; i++) {
      final a = pts[i];
      final b = pts[i + 1];
      if (a != null && b != null) {
        // draw glow then core for a laser effect
        canvas.drawLine(a, b, glow);
        canvas.drawLine(a, b, core);
      }
    }
  }

  // We use `repaint:` with the provider; no need to compare delegates.
  @override
  bool shouldRepaint(covariant _LaserPainter oldDelegate) => false;
}
