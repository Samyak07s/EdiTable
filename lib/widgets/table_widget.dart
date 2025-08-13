import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/table_model.dart';
import '../providers/table_list_provider.dart';
import 'pointer_chip.dart';

class TableWidget extends ConsumerStatefulWidget {
  final int tableIndex;
  final TableModel table;

  const TableWidget({
    super.key,
    required this.tableIndex,
    required this.table,
  });

  @override
  ConsumerState<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends ConsumerState<TableWidget> {
  int? selectedRow;
  int? selectedCol;

  late List<List<TextEditingController>> controllers;

  @override
  void initState() {
    super.initState();
    controllers = _buildControllers(widget.table);
  }

  List<List<TextEditingController>> _buildControllers(TableModel table) {
    return List.generate(
      table.rows,
      (r) => List.generate(
        table.cols,
        (c) => TextEditingController(
          text: table.data[r][c].value.isNotEmpty
              ? table.data[r][c].value
              : (table.defaultValue ?? ''),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant TableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.table.rows != widget.table.rows ||
        oldWidget.table.cols != widget.table.cols) {
      for (var rowControllers in controllers) {
        for (var ctrl in rowControllers) {
          ctrl.dispose();
        }
      }
      controllers = _buildControllers(widget.table);
    } else {
      for (int r = 0; r < widget.table.rows; r++) {
        for (int c = 0; c < widget.table.cols; c++) {
          final newValue = widget.table.data[r][c].value.isNotEmpty
              ? widget.table.data[r][c].value
              : (widget.table.defaultValue ?? '');
          if (controllers[r][c].text != newValue) {
            controllers[r][c].text = newValue;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    for (var rowControllers in controllers) {
      for (var ctrl in rowControllers) {
        ctrl.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double cellWidth = 60.0;
    final double cellHeight = 50.0;
    final double cellMargin = 3.5;
    final double rowLabelWidth = 30.0;

    final dynamicFontSize =
        0.75 * (cellWidth < cellHeight ? cellWidth : cellHeight);

    final table = widget.table;
    final isZeroIndexed = table.isZeroIndexed;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade700, width: 1.2),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${table.name} [${isZeroIndexed ? "0-based" : "1-based"}]',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
                  tooltip: 'Delete this table',
                  onPressed: () {
                    ref.read(tableListProvider.notifier).removeTable(widget.tableIndex);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Table with headers
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Column headers
                  Row(
                    children: [
                      Container(
                        width: rowLabelWidth,
                        height: cellHeight,
                        margin: EdgeInsets.all(cellMargin),
                      ),
                      ...List.generate(table.cols, (col) {
                        final label = (isZeroIndexed ? col : col + 1).toString();
                        return Container(
                          width: cellWidth,
                          height: cellHeight,
                          margin: EdgeInsets.all(cellMargin),
                          alignment: Alignment.center,
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Data rows
                  ...List.generate(table.rows, (row) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Row index
                        Container(
                          width: rowLabelWidth,
                          height: cellHeight,
                          margin: EdgeInsets.all(cellMargin),
                          alignment: Alignment.center,
                          child: Text(
                            (isZeroIndexed ? row : row + 1).toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Cells
                        ...List.generate(table.cols, (col) {
                          final cell = table.data[row][col];
                          final isSelected = selectedRow == row && selectedCol == col;

                          return Container(
                            width: cellWidth,
                            height: cellHeight,
                            margin: EdgeInsets.all(cellMargin),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : (cell.pointers.isNotEmpty
                                        ? Colors.tealAccent.shade700
                                        : Colors.grey.shade600),
                                width: isSelected ? 2.2 : 1.1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controllers[row][col],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: dynamicFontSize * 0.8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      filled: false,
                                      isCollapsed: true,
                                    ),
                                    maxLines: 1,
                                    onTap: () {
                                      setState(() {
                                        selectedRow = row;
                                        selectedCol = col;
                                      });
                                    },
                                    onChanged: (val) {
                                      ref.read(tableListProvider.notifier).updateCellValue(
                                            tableIndex: widget.tableIndex,
                                            row: row,
                                            col: col,
                                            value: val,
                                          );
                                    },
                                  ),
                                ),
                                if (cell.pointers.isNotEmpty)
                                  Wrap(
                                    spacing: 2,
                                    runSpacing: -4,
                                    children: cell.pointers
                                        .map((p) => PointerChip(label: p))
                                        .toList(),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
