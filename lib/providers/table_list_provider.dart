import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/table_model.dart';
import '../models/cell_model.dart';

final tableListProvider = StateNotifierProvider<TableListNotifier, List<TableModel>>(
  (ref) => TableListNotifier(),
);

class TableListNotifier extends StateNotifier<List<TableModel>> {
  TableListNotifier() : super([]);

  void addTable(TableModel table) {
    state = [...state, table];
  }

  void clearTables() {
    state = [];
  }

  void removeTable(int index) {
    if (index < 0 || index >= state.length) return;
    final newList = [...state];
    newList.removeAt(index);
    state = newList;
  }

  void updateCellValue({
    required int tableIndex,
    required int row,
    required int col,
    required String value,
  }) {
    if (tableIndex < 0 || tableIndex >= state.length) return;
    final currentTable = state[tableIndex];

    final newData = List.generate(
      currentTable.rows,
      (r) => List.generate(
        currentTable.cols,
        (c) {
          if (r == row && c == col) {
            final oldCell = currentTable.data[r][c];
            return CellModel(value: value, pointers: oldCell.pointers);
          } else {
            return currentTable.data[r][c];
          }
        },
      ),
    );

    final updatedTable = TableModel(
      name: currentTable.name,
      rows: currentTable.rows,
      cols: currentTable.cols,
      isZeroIndexed: currentTable.isZeroIndexed,
      pointers: currentTable.pointers,
      data: newData,
    );

    final newState = [...state];
    newState[tableIndex] = updatedTable;
    state = newState;
  }
}
