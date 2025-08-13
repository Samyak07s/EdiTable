import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final penModeProvider = StateProvider<bool>((ref) => false);
final drawingPointsProvider = StateProvider<List<Offset?>>((ref) => []);
