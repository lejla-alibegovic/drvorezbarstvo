import 'package:wood_track_admin/models/base.dart';
import 'package:wood_track_admin/models/tool.dart';
import 'package:wood_track_admin/models/user_model.dart';

class ToolService extends BaseModel {
  late double newDimension;
  late DateTime deadlineFinishedAt;
  late String description;
  late int toolId;
  Tool? tool;
  late int? userId;
  UserModel? user;

  ToolService();

  ToolService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    newDimension = (json['newDimension'] as num).toDouble();
    deadlineFinishedAt = DateTime.parse(json['deadlineFinishedAt']);
    description = json['description'];
    toolId = json['toolId'];
    if (json['tool'] != null) {
      tool = Tool.fromJson(json['tool']);
    }
    if (json['userId'] != null) {
      userId = json['userId'];
    }
    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }
    dateCreated = DateTime.parse(json['dateCreated']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['newDimension'] = newDimension;
    data['deadlineFinishedAt'] = deadlineFinishedAt.toIso8601String();
    data['description'] = description;
    data['toolId'] = toolId;
    data['userId'] = userId;
    return data;
  }
}
