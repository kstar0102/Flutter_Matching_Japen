import 'package:intl/intl.dart';

import 'package:matching_app/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class CommunicateItem {
  const CommunicateItem({
    required this.category_id,
    required this.category_name,
    required this.category_image,
    required this.sub_category_id,
    required this.community_name,
    required this.community_photo,
    required this.community_count
  });

  final String category_id;
  final String category_name;
  final String category_image;
  final String sub_category_id;
  final String community_name;
  final String community_photo;
  final String community_count;

  factory CommunicateItem.fromMap(Map<String, dynamic> data) {
    return CommunicateItem(
      category_id: data['category_id'].toString(),
      category_name: data['category_name'].toString(),
      category_image: data['category_image'].toString(),
      sub_category_id: data['sub_category_id'].toString(),
      community_name: data['community_name'].toString(),
      community_photo: data['community_photo'].toString(),
      community_count: data['community_count'].toString()
    );
  }

  @override
  String toString() => 'CommunicateItem(category_id: $category_id, category_name: $category_name, '
      'category_image: $category_image, sub_category_id: $sub_category_id, community_name: $community_name,'
      'community_photo: $community_photo, community_count: $community_count)';
}

typedef CommunicateItemList = List<CommunicateItem>;
