import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/table_model.dart';
import '../providers/table_list_provider.dart';
import '../providers/drawing_provider.dart';
import '../widgets/add_table_dialog.dart';
import '../widgets/table_widget.dart';
import '../widgets/drawing_overlay.dart';

class VisualDPScreen extends ConsumerWidget {
  const VisualDPScreen({super.key});

  void _showAddTableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AddTableDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.watch(tableListProvider);
    final drawing = ref.watch(drawingProvider);
    final isDrawing = drawing.isDrawingMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EdiTable'),
        actions: [
          // Toggle drawing mode (reset strokes on enter)
          IconButton(
            tooltip: isDrawing ? 'Exit Drawing Mode' : 'Enable Drawing',
            icon: Icon(isDrawing ? Icons.close : Icons.edit),
            onPressed: () {
              final dp = ref.read(drawingProvider);
              if (!dp.isDrawingMode) {
                // Reset canvas every time we ENTER drawing mode
                dp.clear();
              }
              dp.toggleDrawingMode();
            },
          ),

          // Clear all tables (only when not drawing and tables exist)
          if (!isDrawing && tables.isNotEmpty)
            IconButton(
              tooltip: 'Clear All Tables',
              icon: const Icon(Icons.delete_forever_outlined),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear All Tables?'),
                    content: const Text(
                      'This will delete all tables permanently.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(tableListProvider.notifier).clearTables();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          // Tables or empty state
          tables.isEmpty
              ? const Center(
                  child: Text(
                    'No tables added yet.\nTap + to add a new DP table.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: tables.length,
                  itemBuilder: (context, index) {
                    final TableModel table = tables[index];
                    return TableWidget(
                      key: ValueKey('${table.name}_$index'),
                      tableIndex: index,
                      table: table,
                    );
                  },
                ),

          // Scribble overlay when drawing
          if (isDrawing) const DrawingOverlay(),
        ],
      ),

      // Hide FAB when drawing
      floatingActionButton: isDrawing
          ? null
          : FloatingActionButton(
              tooltip: 'Add Table',
              onPressed: () => _showAddTableDialog(context),
              child: const Icon(Icons.add),
            ),
    );
  }
}
