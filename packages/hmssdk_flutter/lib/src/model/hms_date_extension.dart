///100ms HMSDateExtension
///
///[HMSDateExtension] is used to convert android and ios native time format to DateTime type
///in local time zone format.
class HMSDateExtension {
  static DateTime convertDate(String date) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    return dateTime;
  }
}
