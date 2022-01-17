class UntilEvent {
  final String title;
  final String? img;
  final DateTime date;

  UntilEvent({
    required this.title,
    required this.date,
    this.img,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "date": date.toString(),
      "img": img,
    };
  }

  UntilEvent.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        date = DateTime.parse(json["date"]),
        img = json["img"];

  @override
  String toString() {
    return "UntilEvent | title: $title, date: ${date}";
  }
}
