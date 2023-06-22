import 'package:intl/intl.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/data_models/tiffin_data_model.dart';
import 'package:uuid/uuid.dart';

class Calculator {
  static int getActiveTiffinDaysRemaining(TiffinDataModel tiffinModel) {
    var endDate = parseDateTimeWithoutCurrentTime(tiffinModel.endDate);

    var currentDate = parseDateTimeWithoutCurrentTime(DateTime.now());

    return endDate.difference(currentDate).inDays;
  }

  static int getActiveTiffinTotalDays(TiffinDataModel tiffinModel) {
    var startDate = parseDateTimeWithoutCurrentTime(tiffinModel.startDate);
    var endDate = parseDateTimeWithoutCurrentTime(tiffinModel.endDate);

    return endDate.difference(startDate).inDays;
  }

  static DateTime parseDateTimeWithoutCurrentTime(DateTime datetime) {
    DateTime formattedDateTime = DateTime(datetime.year, datetime.month, datetime.day);

    return formattedDateTime;
  }

  static String parseDateTimeToDateString(DateTime datetime) {
    return DateFormat("yyyy-MM-dd").format(datetime);
  }

  static String generateUUID(UuidTag actionTag) {
    Uuid generator = const Uuid();

    return "ocid.${actionTag.name}..${generator.v1()}";
  }
}
