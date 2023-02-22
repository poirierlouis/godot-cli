/// Sets of data used to generate a class from a template.
class GDTemplateClassData {
  const GDTemplateClassData({
    required this.className,
  });

  /// Class name of the library (e.g. "Example").
  final String className;

  /// Header name of the file to include (e.g. "example").
  String get includeName => className.toLowerCase();

  /// Header name of the class to define a guard (e.g. "EXAMPLE").
  String get headerName => className.toUpperCase();
}
