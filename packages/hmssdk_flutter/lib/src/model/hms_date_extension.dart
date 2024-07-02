///100ms HMSDateExtension
///
///[HMSDateExtension] is used to convert android and ios native time format to DateTime type
///in local time zone format.

///Dart imports
import 'dart:developer';

class HMSDateExtension {
  ///Returns optional DateTime object from epoch in milliseconds
  static DateTime? convertDateFromEpoch(int date) {
    try {
      DateTime _dateTime =
          DateTime.fromMillisecondsSinceEpoch(date, isUtc: false);
      return _dateTime;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
