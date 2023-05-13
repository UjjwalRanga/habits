import 'package:flutter/material.dart';
import 'package:habits/audioPlayerPage.dart';
import 'package:habits/class/book.dart';
import 'package:habits/player/page_manager.dart';
import 'package:habits/widgets/imageWidget.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';

class BookDetail extends StatefulWidget {

  final Book book;

   const BookDetail({Key? key,
    required this.book,
}) : super(key: key);

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {

  bool isInLib = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;

  @override
  void initState(){

    var box = Hive.box<Book>("Lib");
    if(box.containsKey(widget.book.id)){
      setState((){
        bookDuration();
        isInLib = true;
      });
    }

    super.initState();
  }

  void bookDuration() async {
    var duration = const Duration(seconds: 0);
    for(int i = 0 ; i < widget.book.audio.length ; i++){
      var audio = await _audioPlayer.setUrl(widget.book.audio[i]);
      duration += Duration(seconds: audio!.inSeconds);
    }
    setState((){

    this.duration = duration;
    });
    _audioPlayer.dispose();
  }
  @override
  void dispose(){

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var val = MediaQuery.of(context);
    return Scaffold(

        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(
                    height: (val.orientation == Orientation.portrait) ? val.size.height*0.35 : val.size.height*0.4,
                    width: val.size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ImageWidget(book: widget.book,width: 175,height: 260,),
                          ),
                          const SizedBox(width: 10,),
                          SizedBox(
                            width: val.size.width/2,
                            height: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,top: 8,right: 10,),
                                  child: Text(widget.book.getBookName(),
                                    maxLines: (val.orientation == Orientation.portrait) ? 3 : 1,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10,),
                                  child: FittedBox(
                                    child: Text(widget.book.getAuthor(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10,),
                                  child: Row(
                                    children: [
                                      MaterialButton(
                                        color: Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                        onPressed: (){
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (_) {
                                                //return AudioPlayerUrl(book: widget.book,audioFileNo: 0,);
                                                return AudioPlayerPage(book: widget.book,audioFileNo: 0,);
                                              })
                                          );
                                        },
                                        child: const Text("Listen Now"),
                                      ),
                                      const SizedBox(width: 10,),
                                      MaterialButton(
                                        shape: ShapeBorder.lerp(Border.all(width: 1,color: Colors.white38), Border.all(width: 1), 0),
                                        color: Colors.white10 ,
                                        textColor: Colors.white,
                                        onPressed: (){
                                          var box =   Hive.box<Book>('Lib');
                                           setState((){

                                             if(isInLib){
                                               setState((){
                                                 isInLib = false;
                                               });
                                                box.delete(widget.book.id);
                                             }else {
                                               setState((){
                                                 isInLib = true;
                                               });

                                               box.put(widget.book.id,widget.book);
                                             }
                                           });
                                        },
                                        child:  Text( (isInLib == false ) ? "Add to Lib" : "Added"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: val.size.height*0.62,
                    child: ListView.builder(
                        itemCount: widget.book.audio.length,
                        itemBuilder: (ctx,index){

                          return Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15,top: 10,),
                        child: Container(
                          decoration: BoxDecoration(
                              color:const Color.fromRGBO(15, 15 , 15, 1),
                              borderRadius: BorderRadius.circular(10)
                          ),


                          child: ListTile(
                            onTap: (){

                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (ctx) {
                                    return AudioPlayerPage(book: widget.book,audioFileNo: index,);
                                  })
                              );
                            },
                              trailing: Text((index+1).toString(),style: const TextStyle(color: Colors.white),),
                             leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ImageWidget(book: widget.book,width: 55,height: 55,)
                            ),
                            title: Text(widget.book.getBookName(),style: const TextStyle(color: Colors.white),),
                            subtitle:Text(widget.book.getAuthor(),style:const TextStyle(color: Colors.white),),
                          ),
                        ),
                      );
                    }),
                  ),
                ]),
          ),
        )
    );
  }
}

