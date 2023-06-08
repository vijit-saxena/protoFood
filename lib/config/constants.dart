// ignore_for_file: constant_identifier_names

const String baseUrl = "http://192.168.207.184:8080/protofood/v1";
const Map<String, String> baseHeaders = {"Content-Type": "application/json"};

const String paymentKey = "rzp_test_eBwTFIyskpMbwk";

enum PaymentStatus {
  Success,
  Failed,
  RefundPending,
  Refunded,
}

enum Meal {
  BreakfastLunchDinner,
  LunchDinner,
  Lunch,
  Dinner,
}

enum Gender {
  Male,
  Female,
}

enum UserAction {
  Taste,
  ExtraTiffin,
  SkipTiffin,
  Subscription,
  SubscriptionRefund,
}
