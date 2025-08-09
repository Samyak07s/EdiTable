import 'cell_model.dart';

class TableModel {
  final String name;
  final int rows;
  final int cols;
  final bool isZeroIndexed;
  final List<String> pointers;
  final List<List<CellModel>> data;
  final String? defaultValue; 

  TableModel({
    required this.name,
    required this.rows,
    required this.cols,
    required this.isZeroIndexed,
    required this.pointers,
    required this.data,
    this.defaultValue,
  });

  factory TableModel.createEmpty({
    required String name,
    required int rows,
    required int cols,
    bool isZeroIndexed = true,
    List<String> pointers = const [],
    String? defaultValue,
  }) {
    final data = List.generate(
      rows,
      (_) => List.generate(
        cols,
        (_) => CellModel(value: defaultValue ?? ''), // initialize with defaultValue if provided
      ),
    );

    return TableModel(
      name: name,
      rows: rows,
      cols: cols,
      isZeroIndexed: isZeroIndexed,
      pointers: pointers,
      data: data,
      defaultValue: defaultValue,
    );
  }
}
