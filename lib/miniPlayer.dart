import 'package:flutter/material.dart';
import 'package:habits/player/page_manager.dart';
import 'package:habits/widgets/imageWidget.dart';
import 'package:hive/hive.dart';
import 'audioPlayerPage.dart';
import 'class/book.dart';
import 'main.dart';

late PageManager _pageManager;
class MiniPlayerWidget extends StatefulWidget {
  const MiniPlayerWidget({Key? key}) : super(key: key);

  @override
  State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
}

class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {

  @override
  void initState(){
    _pageManager = PageManager(Hive.box<Book>('play').getAt(0)!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState((){
           Navigator.of(context).push(
             MaterialPageRoute(builder: (ctx){
               return AudioPlayerPage(book: Hive.box<Book>('play').getAt(0)!, audioFileNo: 0);
             })
           );
        });
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Dismissible(
          onDismissed: (dir){
            miniPlayer = false;
          },
          key: UniqueKey(),
          child: Container(


            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10) ),
              color:  Colors.black,),

            height: 75,
            child: Column(
              children: [
                Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 10,),
                        ClipRRect(borderRadius: BorderRadius.circular(10), child: ImageWidget(book:  Hive.box<Book>('play').getAt(0)!,width: 55,height: 55,)),
                        const SizedBox(width: 10,),
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Hive.box<Book>('play').getAt(0)!.getBookName(),style: const TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 5,),
                            Text(Hive.box<Book>('play').getAt(0)!.getAuthor(),style: const TextStyle(color: Colors.white,fontSize: 13,),overflow: TextOverflow.ellipsis)
                          ],
                        )),
                        IconButton(onPressed: (){

                        }, icon: const Icon(Icons.skip_previous_rounded),color: Colors.white,),
                        IconButton(onPressed: (){
                          _pageManager.play();
                        }, icon: const Icon(Icons.play_arrow_rounded),color: Colors.white,),
                        IconButton(onPressed: (){

                        }, icon: const Icon(Icons.skip_next_rounded),color: Colors.white,),
                        const SizedBox(width: 10,)
                      ],
                    )),
                LinearProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: const Color(0xff191919),
                  value: 0.4,

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
