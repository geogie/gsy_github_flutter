import 'package:json_annotation/json_annotation.dart';
import 'package:gsy_github_flutter/common/model/User.dart';
/// Create by george
/// Date:2019/2/18
/// description:
part 'PushEventCommit.g.dart';

@JsonSerializable()
class PushEventCommit {
  String sha;
  User author;
  String message;
  bool distinct;
  String url;

  PushEventCommit(
      this.sha,
      this.author,
      this.message,
      this.distinct,
      this.url,
      );

  factory PushEventCommit.fromJson(Map<String, dynamic> json) => _$PushEventCommitFromJson(json);

  Map<String, dynamic> toJson() => _$PushEventCommitToJson(this);
}