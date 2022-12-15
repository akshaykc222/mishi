class StaticPages {
  StaticPages({
    required this.priority,
    required this.pageTitle,
    required this.id,
    required this.owner,
    required this.pageUrl,
    required this.createdDate,
    required this.updatedDate,
    required this.brandId,
    required this.pageLive,
  });

  int priority;
  String pageTitle;
  String id;
  String owner;
  String pageUrl;
  DateTime createdDate;
  DateTime updatedDate;
  String brandId;
  bool pageLive;

  factory StaticPages.fromJson(Map<String, dynamic> json) => StaticPages(
        priority: json["priority"],
        pageTitle: json["pageTitle"],
        id: json["_id"],
        owner: json["_owner"],
        pageUrl: json["pageUrl"],
        createdDate: DateTime.parse(json["_createdDate"]),
        updatedDate: DateTime.parse(json["_updatedDate"]),
        brandId: json["brandId"],
        pageLive: json["pageLive"],
      );

  Map<String, dynamic> toJson() => {
        "priority": priority,
        "pageTitle": pageTitle,
        "_id": id,
        "_owner": owner,
        "pageUrl": pageUrl,
        "_createdDate": createdDate.toIso8601String(),
        "_updatedDate": updatedDate.toIso8601String(),
        "brandId": brandId,
        "pageLive": pageLive,
      };
}
