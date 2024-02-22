import 'package:fram_flutter_assignment/src/base/enums.dart';

DateTime parseDateTime(String dateString) {
  List<String> parts = dateString.split('-');
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);
  return DateTime(year, month, day);
}

Gender parseGender(String gender){
  return gender == "male" ? Gender.male: Gender.female;
}