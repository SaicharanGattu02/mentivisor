
class TimeHelper {
  /// Convert server UTC timestamp → IST
  static DateTime utcToIST(String utcString) {
    final utc = DateTime.parse(utcString).toUtc();
    return utc.add(const Duration(hours: 5, minutes: 30));
  }

  /// Convert local device time → UTC (for sending to server)
  static String nowUTC() {
    return DateTime.now().toUtc().toIso8601String();
  }

  /// Convert local time → IST (useful for optimistic messages)
  static String nowIST() {
    return DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30)).toIso8601String();
  }
}
