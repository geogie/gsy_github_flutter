import 'package:json_annotation/json_annotation.dart';
/// Create by george
/// Date:2019/2/18
/// description:

part 'License.g.dart';

@JsonSerializable()
class License {

  String name;

  License(this.name);

  factory License.fromJson(Map<String, dynamic> json) => _$LicenseFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseToJson(this);
}