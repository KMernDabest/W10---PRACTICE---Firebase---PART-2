import '../../model/comment/comment.dart';

class CommentDto {
  static const String artistIdKey = 'artistId';
  static const String textKey = 'text';
  static const String createdAtKey = 'createdAt';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    assert(json[artistIdKey] is String);
    assert(json[textKey] is String);
    assert(json[createdAtKey] is String);

    return Comment(
      id: id,
      artistId: json[artistIdKey],
      text: json[textKey],
      createdAt: DateTime.parse(json[createdAtKey]),
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      artistIdKey: comment.artistId,
      textKey: comment.text,
      createdAtKey: comment.createdAt.toIso8601String(),
    };
  }
}
