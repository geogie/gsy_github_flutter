import 'package:dio/dio.dart';
import 'dart:io';

import 'package:gsy_github_flutter/common/net/Api.dart';
import 'package:gsy_github_flutter/common/net/ResultData.dart';
import 'package:gsy_github_flutter/common/net/Code.dart';
import 'package:gsy_github_flutter/common/model/TrendingRepoModel.dart';

/// Create by george
/// Date:2019/2/20
/// description:趋势数据解析
class GitHubTrending {
  fetchTrending(url) async {
    var res = await HttpManager.netFetch(url, null, null, new Options(contentType: ContentType.text));
    if (res != null && res.result && res.data != null) {
      return new ResultData(TrendingUtil.htmlToRepo(res.data), true, Code.SUCCESS);
    } else {
      return res;
    }
  }
}

class TrendingUtil {
  static htmlToRepo(String responseData) {
    try {
      responseData = responseData.replaceAll(new RegExp('\n'), '');
    } catch (e) {}
    var repos = new List();
    var splitWithH3 = responseData.split('<h3');
    splitWithH3.removeAt(0);
    for (var i = 0; i < splitWithH3.length; i++) {
      var repo = TrendingRepoModel.empty();
      var html = splitWithH3[i];

      parseRepoBaseInfo(repo, html);

      var metaNoteContent = parseContentWithNote(html, 'class="f6 text-gray mt-2">', '<\/li>');
      repo.meta = parseRepoLabelWithTag(repo, metaNoteContent, TAGS["meta"]);
      repo.starCount = parseRepoLabelWithTag(repo, metaNoteContent, TAGS["starCount"]);
      repo.forkCount = parseRepoLabelWithTag(repo, metaNoteContent, TAGS["forkCount"]);

      parseRepoLang(repo, metaNoteContent);
      parseRepoContributors(repo, metaNoteContent);
      repos.add(repo);
    }
    return repos;
  }

  static parseRepoContributors(repo, htmlContributors) {
    htmlContributors = parseContentWithNote(htmlContributors, 'Built by', '<\/a>');
    var splitWitSemicolon = htmlContributors.split('\"');
    if(splitWitSemicolon.length > 1) {
      repo.contributorsUrl = splitWitSemicolon[1];
    }
    var contributors = new List<String>();
    for (var i = 0; i < splitWitSemicolon.length; i++) {
      String url = splitWitSemicolon[i];
      if (url.indexOf('http') != -1) {
        contributors.add(url);
      }
    }
    repo.contributors = contributors;
  }

  static parseRepoBaseInfo(repo, htmlBaseInfo) {
    var urlIndex = htmlBaseInfo.indexOf('<a href="') + '<a href="'.length;
    var url = htmlBaseInfo.substring(urlIndex, htmlBaseInfo.indexOf('">', urlIndex));
    repo.url = url;
    repo.fullName = url.substring(1, url.length);
    if (repo.fullName != null && repo.fullName.indexOf('/') != -1) {
      repo.name = repo.fullName.split('/')[0];
      repo.reposName = repo.fullName.split('/')[1];
    }

    String description = parseContentWithNote(htmlBaseInfo, '<p class="col-9 d-inline-block text-gray m-0 pr-4">', '</p>');
    if (description != null) {
      String reg = "<g-emoji.*?>.+?</g-emoji>";
      RegExp tag = new RegExp(reg);
      Iterable<Match> tags = tag.allMatches(description);
      for (Match m in tags) {
        String match = m.group(0).replaceAll(new RegExp("<g-emoji.*?>"), "").replaceAll(new RegExp("</g-emoji>"), "");
        description = description.replaceAll(new RegExp(m.group(0)), match);
      }
    }
    repo.description = description;
  }

  static parseContentWithNote(htmlStr, startFlag, endFlag) {
    var noteStar = htmlStr.indexOf(startFlag);
    if (noteStar == -1) {
      return '';
    } else {
      noteStar += startFlag.length;
    }

    var noteEnd = htmlStr.indexOf(endFlag, noteStar);
    var content = htmlStr.substring(noteStar, noteEnd);
    return trim(content);
  }

  static trim(text) {
    if (text is String) {
      return text.trim();
    } else {
      return text.toString().trim();
    }
  }

  static parseRepoLabelWithTag(repo, noteContent, tag) {
    var startFlag;
    if (TAGS["starCount"] == tag || TAGS["forkCount"] == tag) {
      startFlag = tag["start"] + ' href="/' + repo.fullName + tag["flag"];
    } else {
      startFlag = tag["start"];
    }
    var content = parseContentWithNote(noteContent, startFlag, tag["end"]);
    if(content.indexOf('</svg>') != -1 && (content.indexOf('</svg>') + '</svg>'.length <= content.length)) {
      var metaContent = content.substring(content.indexOf('</svg>') + '</svg>'.length, content.length);
      return trim(metaContent);
    } else {
      return trim(content);
    }
  }

  static parseRepoLang(repo, metaNoteContent) {
    var content = parseContentWithNote(metaNoteContent, 'programmingLanguage">', '</span>');
    repo.language = trim(content);
  }
}

const TAGS = {
  "meta": {"start": '<span class="d-inline-block float-sm-right">', "end": '</span>'},
  "starCount": {"start": '<a class="muted-link d-inline-block mr-3"', "flag": '/stargazers">', "end": '</a>'},
  "forkCount": {"start": '<a class="muted-link d-inline-block mr-3"', "flag": '/network">', "end": '</a>'}
};