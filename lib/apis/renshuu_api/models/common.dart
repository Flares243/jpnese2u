import 'package:json_annotation/json_annotation.dart';

part 'common.g.dart';

@JsonSerializable()
class ApiUsageResFieldEntity {
  const ApiUsageResFieldEntity({
    required this.callsToday,
    required this.dailyAllowance,
  });

  @JsonKey(name: "calls_today")
  final String callsToday;
  @JsonKey(name: "daily_allowance")
  final int dailyAllowance;

  factory ApiUsageResFieldEntity.fromJson(Map<String, dynamic> json) =>
      _$ApiUsageResFieldEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ApiUsageResFieldEntityToJson(this);
}
