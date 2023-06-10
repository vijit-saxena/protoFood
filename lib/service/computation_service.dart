import 'package:protofood/data_models/tiffin_data_model.dart';

class Calculator {
  int getActiveTiffinDaysRemaining(TiffinDataModel tiffinModel) {
    var endDate = parseDateTimeWithoutCurrentTime(DateTime.parse(tiffinModel.endDate));

    var currentDate = parseDateTimeWithoutCurrentTime(DateTime.now());

    return endDate.difference(currentDate).inDays;
  }

  int getActiveTiffinTotalDays(TiffinDataModel tiffinModel) {
    var startDate = parseDateTimeWithoutCurrentTime(DateTime.parse(tiffinModel.startDate));
    var endDate = parseDateTimeWithoutCurrentTime(DateTime.parse(tiffinModel.endDate));

    return endDate.difference(startDate).inDays;
  }

  DateTime parseDateTimeWithoutCurrentTime(DateTime datetime) {
    DateTime formattedDateTime = DateTime(datetime.year, datetime.month, datetime.day);

    return formattedDateTime;
  }
}
