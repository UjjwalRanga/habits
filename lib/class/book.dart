
import 'package:hive_flutter/hive_flutter.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book{
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? imageUrl;

  @HiveField(3)
  String? story;

  @HiveField(4)
  List<String> audio;

  @HiveField(5)
  List<Duration> position = [];

  @HiveField(6)
  Map<String,Map<double,double>> bookMarks = {};

  // List<Duration> duration = [];

  String _bookName = '';
  String _bookAuthor = '';


  Book({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.audio,
 });

  void setTitleAndAuthor(){
    if(title.contains('–')) {
      _bookAuthor =
          title.substring(0, title.indexOf('–'));
      _bookName = title.substring(
          title.indexOf('–') + 2, title.length - 9);
    }else{
      _bookName = title;
      _bookAuthor = '  ';
    }
  }

  String getImage(){
    if(imageUrl == null) return ' ';
    return imageUrl!;
  }
  String getBookName(){
    if(_bookName != '') return _bookName;
    setTitleAndAuthor();
    return _bookName;
  }
  String getAuthor(){
    if(_bookAuthor != '') return _bookAuthor;
    setTitleAndAuthor();
    return _bookAuthor;
  }
  String getStory(){
    if(story == null) return ' ';
    return story!;
  }
  // String bookLength(){
  //   Duration length = Duration.zero;
  //
  //   for(Duration i in duration){
  //     length += i;
  //   }
  //   return length.toString();
  // }

}
