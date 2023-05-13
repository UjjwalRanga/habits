import 'package:flutter/material.dart';
import 'package:habits/widgets/libraryGrid.dart';
import 'package:habits/widgets/libraryList.dart';
import 'package:hive/hive.dart';

import '../class/book.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({Key? key}) : super(key: key);
  static bool listView = false;

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {

late int num =0;
final _textController = TextEditingController();
bool search = false;
@override
void initState(){
  super.initState();
  num = Hive.box<Book>('Lib').length;
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

          actions: [
            IconButton(onPressed: (){
              setState((){
                LibraryView.listView = !LibraryView.listView;
              });
            }, icon: (LibraryView.listView == false) ?  const Icon(Icons.grid_view) : const Icon(Icons.list),
            splashRadius: 20),
          ],
          backgroundColor: Colors.transparent,
          title: GestureDetector(
            onTap: (){
              setState((){
                search = true;
              });
            },
            child: Container(
                height: 50,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(25, 25 , 25, 1),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child:Row(
                  children:  [
                    Padding(
                      padding: EdgeInsets.only( left:(search == false) ? 10 :0,right: 10),
                      child: (search == false) ? Icon(Icons.search,  color: Theme.of(context).primaryColor,size: 25,)
                              : IconButton(
                        splashRadius: 1,
                                onPressed: (){
                                setState((){
                                  search = false;
                                });
                      }, icon: Icon(Icons.arrow_back_rounded,  color: Theme.of(context).primaryColor,size: 25,)),
                    ),
                    (search == false) ? Text("Search audiobook in library of $num books",style: const TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.normal ),)
                        : TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _textController,
                      cursorColor: Colors.white,
                      decoration:const InputDecoration(
                        // hintText: "Search audiobook",
                        // hintStyle: TextStyle(color: Colors.white38),
                        // border: InputBorder.none,
                      ),
                    ),
                  ],
                )
      ),
          ),
      ),
      body: SafeArea(
          child: (LibraryView.listView == false) ? const LibraryGrid() : const LibraryList(),

      ),
    );
  }
}
