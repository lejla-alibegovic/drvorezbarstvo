import 'package:wood_track_mobile/models/review.dart';
import 'base_provider.dart';

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super('Reviews');

  @override
  Review fromJson(data) {
    return Review.fromJson(data);
  }
}