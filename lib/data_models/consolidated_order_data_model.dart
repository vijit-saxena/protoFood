import 'package:protofood/data_models/extra_tiffin_data_model.dart';
import 'package:protofood/data_models/payment_data_model.dart';
import 'package:protofood/data_models/skip_tiffin_data_model.dart';
import 'package:protofood/data_models/taste_tiffin_data_model.dart';
import 'package:protofood/data_models/tiffin_data_model.dart';

class ConsolidatedOrder {
  final String orderId;
  final String action;
  final String timeCreated;

  TasteTiffinDataModel? taste = null;
  TiffinDataModel? tiffin = null;
  ExtraTiffinDataModel? extra = null;
  SkipTiffinDataModel? skip = null;
  PaymentDataModel? payment = null;

  ConsolidatedOrder({
    required this.orderId,
    required this.action,
    required this.timeCreated,
  });

  setTaste(Map<String, dynamic> json) {
    taste = TasteTiffinDataModel.fromJson(json);
  }

  setTiffin(Map<String, dynamic> json) {
    tiffin = TiffinDataModel.fromJson(json);
  }

  setExtra(Map<String, dynamic> json) {
    extra = ExtraTiffinDataModel.fromJson(json);
  }

  setSkip(Map<String, dynamic> json) {
    skip = SkipTiffinDataModel.fromJson(json);
  }

  setPayment(Map<String, dynamic> json) {
    payment = PaymentDataModel.fromJson(json);
  }

  factory ConsolidatedOrder.fromJson(Map<String, dynamic> json) {
    return ConsolidatedOrder(
      orderId: json["orderId"],
      action: json["action"],
      // taste: TasteTiffinDataModel.fromJson(json["taste"]),
      // tiffin: TiffinDataModel.fromJson(json["tiffin"]),
      // extra: ExtraTiffinDataModel.fromJson(json["extra"]),
      // skip: SkipTiffinDataModel.fromJson(json["skip"]),
      // payment: PaymentDataModel.fromJson(json["payment"]),
      timeCreated: json["timeCreated"],
    );
  }
}
