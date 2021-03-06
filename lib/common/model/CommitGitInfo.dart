import 'package:json_annotation/json_annotation.dart';
import 'package:gsy_github_flutter/common/model/CommitGitUser.dart';
/// Create by george
/// Date:2019/2/18
/// description:
part 'CommitGitInfo.g.dart';

@JsonSerializable()
class CommitGitInfo  {
  String message;
  String url;
  @JsonKey(name: "comment_count")
  int commentCount;
  CommitGitUser author;
  CommitGitUser committer;

  CommitGitInfo(
      this.message,
      this.url,
      this.commentCount,
      this.author,
      this.committer,
      );

  factory CommitGitInfo.fromJson(Map<String, dynamic> json) => _$CommitGitInfoFromJson(json);


  Map<String, dynamic> toJson() => _$CommitGitInfoToJson(this);
}