///100ms HMSDateExtension
///
///[HMSDateExtension] is used to covert android and ios native time format to DateTime format
///in local time zone format.
class HMSDateExtension {
  static DateTime convertDate(String date) {
    DateTime _dateTime = DateTime.parse(date).toLocal();
    return _dateTime;
  }
}
