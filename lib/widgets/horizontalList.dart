
// import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:habits/main.dart';
import 'package:habits/widgets/imageWidget.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:habits/services/getWebData.dart';
import 'package:habits/widgets/bookDetail.dart';
import '../class/book.dart';

class HorizontalList extends StatefulWidget {

  final String url;
  HorizontalList({required this.url,});

  @override
  State<HorizontalList> createState() => _HorizontalListState();
}


class _HorizontalListState extends State<HorizontalList> {

   File file(String filename)  {
    String pathName = p.join(directory.path, filename);
    return File(pathName);
  }

  List <Book> books = [];

  @override
  void initState() {

      GetWebData.getWebsiteDataInFormOfBook(widget.url, false).then((value) =>
          setState(() {
            books = value;
          }));


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 320,

      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 5),

          itemBuilder: (context,index){

            final book = books;
            return GestureDetector(
              // onLongPress: (){
              //   showDialog(context: context, builder: (_){
              //     return Image.network(
              //       book[index].imageUrl!,
              //       errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              //         return Image.asset('audiobook.png',fit: BoxFit.cover,height: 150,width: 150,);
              //       },
              //     );
              //   });
              // },
              onTap: (){

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) {
                      return  BookDetail(book: book[index],);
                    })
                );

              },

              child: SizedBox(
                  width: 190,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ImageWidget(book: book[index],height: 260,width: 175,),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10,top: 8,right: 10,),
                        child: Text(book[index].getBookName(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,),
                        child: Text(book[index].getAuthor(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
               ),
            );
          },
          itemCount: books.length),
    );
  }
}
