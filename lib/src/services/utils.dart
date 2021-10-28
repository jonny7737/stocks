DateTime openDate(String dateStr) {
  DateTime? dt = DateTime.tryParse(dateStr);
  return dt ?? DateTime(0);
}
