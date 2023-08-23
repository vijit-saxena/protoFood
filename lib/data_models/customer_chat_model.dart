class CustomerChat {
  final String message;
  final DateTime dateTime;
  final String author;

  CustomerChat({
    required this.message,
    required this.dateTime,
    required this.author,
  });

  factory CustomerChat.fromJson(Map<String, dynamic> json) {
    return CustomerChat(
      message: json["message"],
      dateTime: DateTime.parse(json["dateTime"]),
      author: json["author"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "dateTime": dateTime.toString(),
      "author": author,
    };
  }
}
