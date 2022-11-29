import 'package:hive/hive.dart';

part 'poem.g.dart';

@HiveType(typeId: 0)
class Poem {
  @HiveField(0)
  String name;
  @HiveField(1)
  String author;
  @HiveField(2)
  String poetic;
  @HiveField(3)
  String content;

  Poem({
    required this.name,
    required this.author,
    required this.poetic,
    required this.content,
  });

  @override
  String toString() {
    return '$name $author $poetic $content';
  }
}
