import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawingProvider = ChangeNotifierProvider<DrawingProvider>((ref) {
  return DrawingProvider();
});

class DrawingProvider extends ChangeNotifier {
  final List<Offset?> _points = [];
  bool _isDrawingMode = false;

  List<Offset?> get points => _points;
  bool get isDrawingMode => _isDrawingMode;

  /// Add a point to the current stroke.
  void addPoint(Offset point) {
    _points.add(point);
    notifyListeners(); // triggers painter via repaint
  }

  /// End the current stroke (null separator).
  void endStroke() {
    _points.add(null);
    notifyListeners();
  }

  /// Clear all points.
  void clear() {
    _points.clear();
    notifyListeners();
  }

  /// Toggle drawing mode.
  void toggleDrawingMode() {
    _isDrawingMode = !_isDrawingMode;
    notifyListeners();
  }

  /// Explicitly set drawing mode.
  void setDrawingMode(bool value) {
    _isDrawingMode = value;
    notifyListeners();
  }
}
