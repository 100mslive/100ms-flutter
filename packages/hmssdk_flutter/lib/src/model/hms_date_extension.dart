import 'dart:developer';

///100ms HMSDateExtension
///
///[HMSDateExtension] is used to convert android and ios native time format to DateTime type
///in local time zone format.
class HMSDateExtension {
  static DateTime convertDate(int date) {
    DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return _dateTime;
  }

  static optionalConvertDate(int date) {
    try {
      DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(date);
      // DateTime _dateTime = DateTime.parse(date).toLocal();
      return _dateTime;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
