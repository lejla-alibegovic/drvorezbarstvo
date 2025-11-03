import 'package:wood_track_admin/models/base.dart';
import 'package:wood_track_admin/models/toolCategory.dart';
import 'package:wood_track_admin/models/toolService.dart';
import 'package:wood_track_admin/models/user_model.dart';

class Tool extends BaseModel {
  late String code;
  late String name;
  late String description;
  late double dimension;
  DateTime? chargedDate;
  DateTime? lastServiceDate;
  late bool isNeedNewService;
  late int toolCategoryId;
  late ToolCategory toolCategory;
  int? chargedByUserId;
  UserModel? chargedByUser;
  late List<ToolService> services = [];

  Tool();

  Tool.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'].toString();
    name = json['name'];
    description = json['description'];
    dimension = (json['dimension'] as num).toDouble();
    dateCreated = DateTime.parse(json['dateCreated']);
    chargedDate = json['chargedDate'] != null
        ? DateTime.parse(json['chargedDate'])
        : null;
    lastServiceDate = json['lastServiceDate'] != null
        ? DateTime.parse(json['lastServiceDate'])
        : null;
    isNeedNewService = json['isNeedNewService'];
    toolCategoryId = json['toolCategoryId'];

    if (json['toolCategory'] != null) {
      toolCategory = ToolCategory.fromJson(json['toolCategory']);
    }

    if (json['chargedByUserId'] != null) {
      chargedByUserId = json['chargedByUserId'];
    }

    if (json['chargedByUser'] != null) {
      chargedByUser = UserModel.fromJson(json['chargedByUser']);
    }

    if (json['services'] != null) {
      services = (json['services'] as List)
          .map((service) => ToolService.fromJson(service))
          .toList();
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    data['dimension'] = dimension;
    data['chargedDate'] = chargedDate?.toIso8601String();
    data['lastServiceDate'] = lastServiceDate?.toIso8601String();
    data['isNeedNewService'] = isNeedNewService;
    data['toolCategoryId'] = toolCategoryId;
    data['chargedByUserId'] = chargedByUserId;

    if (services.isNotEmpty) {
      data['services'] = services.map((service) => service.toJson()).toList();
    }

    return data;
  }
}
