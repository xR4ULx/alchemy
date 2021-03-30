import 'dart:convert';

ResponsePush responsePushFromJson(String str) => ResponsePush.fromJson(json.decode(str));

String responsePushToJson(ResponsePush data) => json.encode(data.toJson());

class ResponsePush {
  ResponsePush({
    this.multicastId,
    this.success,
    this.failure,
    this.canonicalIds,
    this.results,
  });

  double multicastId;
  int success;
  int failure;
  int canonicalIds;
  List<Result> results;

  factory ResponsePush.fromJson(Map<String, dynamic> json) => ResponsePush(
    multicastId: json["multicast_id"].toDouble(),
    success: json["success"],
    failure: json["failure"],
    canonicalIds: json["canonical_ids"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "multicast_id": multicastId,
    "success": success,
    "failure": failure,
    "canonical_ids": canonicalIds,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.error,
  });

  String error;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
  };
}