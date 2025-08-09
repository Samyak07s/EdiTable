class CellModel {
  String value;
  List<String> pointers;

  CellModel({this.value = '', List<String>? pointers})
      : pointers = pointers ?? [];
}
