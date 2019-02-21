import 'package:json_annotation/json_annotation.dart';
/// Create by george
/// Date:2019/2/18
/// description:
part 'RepositoryPermissions.g.dart';

@JsonSerializable()
class RepositoryPermissions {
  bool admin;
  bool push;
  bool pull;

  RepositoryPermissions(
      this.admin,
      this.push,
      this.pull,
      );

  factory RepositoryPermissions.fromJson(Map<String, dynamic> json) => _$RepositoryPermissionsFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryPermissionsToJson(this);
}