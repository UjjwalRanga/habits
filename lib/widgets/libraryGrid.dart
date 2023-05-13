import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../class/book.dart';
import 'bookDetail.dart';
import 'imageWidget.dart';

class LibraryGrid extends StatelessWidget {
  const LibraryGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
              height: MediaQuery.of(context).size.height*0.83,
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Book>('Lib').listenable(),
                builder: (context , Box<Book>box,_){
                   return GridView.builder(
                       gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 3,
                         crossAxisSpacing: 10,
                         mainAxisSpacing: 10,
                         childAspectRatio: 4/6,
                       ),
                       padding: const EdgeInsets.all(10),
                       itemBuilder: (ctx,index){
                         return  GestureDetector(
                            onLongPress: (){
                              showDialog(context: context, builder: (ctx)=>AlertDialog(
                                    backgroundColor: const Color(0xff202020),
                                    title:const Center(child: Text("Are you Sure?",style: TextStyle(color: Colors.white),)),
                                    actions: [
                                      MaterialButton(onPressed: (){
                                        Navigator.of(ctx).pop(false);
                                      },
                                        color: Theme.of(context).primaryColor,
                                        child: const Text("NO",style: TextStyle(color: Colors.white),),
                                      ),
                                      MaterialButton(onPressed: (){
                                        box.delete(box.getAt(index)?.id);
                                        Navigator.of(ctx).pop(true);
                                      },
                                        color: Theme.of(context).primaryColor,
                                        child:const Text("Yes",style: TextStyle(color: Colors.white),),
                                      ),

                                    ],

                                    content: const Text("Are you sure you want to delete this item?",style: TextStyle(color: Colors.white),),
                                  ));
                            },

                             onTap: (){
                               Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                                 return BookDetail(book: box.getAt(index)!,);
                               }));
                             },
                             child: ClipRRect(
                                 borderRadius: BorderRadius.circular(10),
                                 child: ImageWidget(book: box.getAt(index)!,width: 175,height: 260)));
                       } ,
                     itemCount: box.length,
                   );
                },
              )
          ),
        ),
      ],
    );
  }
}
