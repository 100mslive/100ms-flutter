///100ms HMSDateExtension
///
///[HMSDateExtension] is used to covert android and ios native time format to DateTime format.
class HMSDateExtension {
  static DateTime convertDate(String date) {
    List<String> dateTimeSeprate = date.split(" ");
    List<String> dateList = dateTimeSeprate[0].split("-");
    List<String> timeList = dateTimeSeprate[1].split(":");

    DateTime _dateTime = DateTime(
      int.parse(dateList[0]),
      int.parse(dateList[1]),
      int.parse(dateList[2]),
      int.parse(timeList[0]),
      int.parse(timeList[1]),
      int.parse(timeList[2]),
    );
    return _dateTime;
  }
}
