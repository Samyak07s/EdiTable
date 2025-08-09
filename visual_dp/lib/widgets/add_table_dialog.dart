import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/table_model.dart';
import '../providers/table_list_provider.dart';

class AddTableDialog extends ConsumerStatefulWidget {
  const AddTableDialog({super.key});

  @override
  ConsumerState<AddTableDialog> createState() => _AddTableDialogState();
}

class _AddTableDialogState extends ConsumerState<AddTableDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rowsController = TextEditingController();
  final TextEditingController _colsController = TextEditingController();
  final TextEditingController _defaultValueController = TextEditingController();
  bool _isZeroIndexed = true;

  @override
  void dispose() {
    _nameController.dispose();
    _rowsController.dispose();
    _colsController.dispose();
    _defaultValueController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final rows = int.parse(_rowsController.text.trim());
      final cols = int.parse(_colsController.text.trim());
      final isZeroIndexed = _isZeroIndexed;
      final defaultValue = _defaultValueController.text.trim();

      final newTable = TableModel.createEmpty(
        name: name,
        rows: rows,
        cols: cols,
        isZeroIndexed: isZeroIndexed,
        pointers: [],
        defaultValue: defaultValue.isEmpty ? null : defaultValue,
      );

      ref.read(tableListProvider.notifier).addTable(newTable);
      Navigator.of(context).pop();
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter table name';
    return null;
  }

  String? _validatePositiveInt(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter a number';
    final n = int.tryParse(value.trim());
    if (n == null || n <= 0) return 'Enter positive integer';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Add New Table',
        style: TextStyle(color: Color(0xFFEEEEEE)),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInputField(_nameController, 'Table Name', _validateName),
              const SizedBox(height: 12),
              _buildInputField(_rowsController, 'Rows (M)', _validatePositiveInt),
              const SizedBox(height: 12),
              _buildInputField(_colsController, 'Columns (N)', _validatePositiveInt),
              const SizedBox(height: 12),
              _buildInputField(_defaultValueController, 'Default Value (Optional)', null),
              const SizedBox(height: 18),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('0-based'),
                    labelStyle: TextStyle(
                      color: _isZeroIndexed ? Colors.black : Colors.white,
                    ),
                    selected: _isZeroIndexed,
                    onSelected: (_) => setState(() => _isZeroIndexed = true),
                    selectedColor: Colors.grey[300],
                    backgroundColor: Colors.grey[800],
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('1-based'),
                    labelStyle: TextStyle(
                      color: !_isZeroIndexed ? Colors.black : Colors.white,
                    ),
                    selected: !_isZeroIndexed,
                    onSelected: (_) => setState(() => _isZeroIndexed = false),
                    selectedColor: Colors.grey[300],
                    backgroundColor: Colors.grey[800],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            foregroundColor: Colors.white,
          ),
          onPressed: _submit,
          child: const Text('Create'),
        ),
      ],
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFAAAAAA)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF555555)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF888888)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: label.contains('Row') || label.contains('Column')
          ? TextInputType.number
          : null,
      validator: validator,
    );
  }
}
