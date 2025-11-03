import 'package:wood_track_mobile/providers/base_provider.dart';
import 'package:wood_track_mobile/models/user_upsert_model.dart';

class UserProvider extends BaseProvider<UserUpsertModel> {
  UserProvider() : super('Users');

  @override
  UserUpsertModel fromJson(data) {
    return UserUpsertModel.fromJson(data);
  }
}
