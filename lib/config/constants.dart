const String baseUrl = "http://192.168.42.184:8080/protofood/v1";
const Map<String, String> baseHeaders = {"Content-Type": "application/json"};

const String paymentKey = "rzp_test_eBwTFIyskpMbwk";

enum PaymentStatus {
  success,
  failed,
  refund,
}

enum Meal {
  breakfastLunchDinner,
  lunchDinner,
  lunch,
  dinner,
}

enum Gender {
  male,
  female,
}

enum UserAction {
  taste,
  extraTiffin,
  skipTiffin,
  subscription,
  subscriptionRefund,
}
