// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habits/audioPlayerPage.dart';
import 'package:habits/class/book.dart';
import 'package:habits/profile.dart';
import 'package:habits/search.dart';
import 'package:habits/widgets/horizontalList.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:habits/widgets/imageWidget.dart';
import 'package:habits/widgets/libraryView.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'class/library.dart';
import 'package:miniplayer/miniplayer.dart';



late Directory directory;
bool miniPlayer = true;
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  directory = await getApplicationDocumentsDirectory();

  //print(directory.path);
  Hive.init(directory.path);
  Hive.registerAdapter<Book>(BookAdapter());

  await Hive.openBox<Book>('Books101');
  await Hive.openBox<Book>('play');
  await Hive.openBox<Book>('Lib');

  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light),
        ),

        primaryColor:  const Color(0xFFE50914),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  Widget sliverItems(String name,String url){
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
              padding: const EdgeInsets.only(left: 15,right: 10,top: 10,bottom: 5),
              child: Text(name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),),
            ),

           HorizontalList(url: url),

        ],
      ),
    );

  }
  int bottomIndex = 0;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: GNav(
        onTabChange: (index){
          setState((){
          bottomIndex = index;

          });
        },
        rippleColor: Colors.transparent, // tab button ripple color when pressed
        hoverColor: Colors.transparent, // tab button hover color
        haptic: true, // haptic feedback
        tabBorderRadius: 25,
        tabMargin:const EdgeInsets.only(top: 10,bottom: 10,right: 10,left: 10),
       // tabActiveBorder: Border.all(color: Theme.of(context).primaryColor, width: 1,), // tab button border
        //tabBorder: Border.all(color: Colors.white, width: 1), // tab button border
       //tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
        //curve: Curves.easeOutExpo, // tab animation curves
        //duration: const Duration(milliseconds: 1000), // tab animation duration
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        gap: 5, // the tab button gap between icon and text
        iconSize: 25, // tab button icon size
        tabBackgroundColor:  Theme.of(context).primaryColor.withOpacity(0.15), // selected tab background color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // navigation bar padding

        color: Colors.white,

        textStyle:  TextStyle(fontSize: 15,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),

        activeColor: Theme.of(context).primaryColor,

        tabs: const [
          GButton(

            icon: Icons.home_rounded,
            text: 'Home',
          ),
          GButton(
            icon: Icons.search_rounded,
            text: 'Search',

          ),
          GButton(
            icon: Icons.collections_bookmark_rounded,
            text: 'Library',

          ),
          GButton(
            icon: Icons.person_rounded,
            text: 'Profile',

          )
        ],

      ),

      backgroundColor: Colors.black,

      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [ (bottomIndex ==0 ) ? CustomScrollView(
            slivers:  [
              SliverAppBar(
                elevation: 0,
                pinned: true,

                backgroundColor: Colors.transparent,
                expandedHeight: 220,
                collapsedHeight: 70,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding:const EdgeInsets.only(left: 15,right: 15,bottom: 15),

                  //collapseMode: CollapseMode.pin,
                  background: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hi There,",style: TextStyle(color: Theme.of(context).primaryColor,
                                  fontSize: 40,fontWeight: FontWeight.bold),),
                              const Text("Guest",style: TextStyle(color: Colors.white,
                                  fontSize: 20),),
                            ],

                          ),

                        ],
                      ),
                    ),
                  ),
                  expandedTitleScale: 1,
                  title: GestureDetector(
                    onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_){
                            return const Search();
                          })
                        );
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
                            padding:const EdgeInsets.only(left: 10,right: 10),
                            child: Icon(Icons.search,color: Theme.of(context).primaryColor,size: 25,),
                          ),
                          const Text("Search audiobook",style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.normal ),)
                        ],
                      )
                    ),
                  ),
                ),
              ),


              sliverItems('Adventure', Library.adventure),
              sliverItems('Audio', Library.audio),
              sliverItems('Autobiography-Biography', Library.autobiography),
              sliverItems('BestSeller', Library.bestsellers),
              sliverItems('Book', Library.book),
              sliverItems('Books', Library.books),
              sliverItems('Classic', Library.classic),
              sliverItems('Fantasy', Library.fantasy),
              sliverItems('Fiction', Library.fiction),
              sliverItems('Herry Potter', Library.harryPotter),
              sliverItems('Historical Fiction', Library.historicalFiction),
              sliverItems('History', Library.history),
              sliverItems('Horror', Library.horror),
              sliverItems('Literature Fiction', Library.literatureFiction),
              sliverItems('Non Fiction', Library.nonfiction),
              sliverItems('Novel', Library.novel),
              sliverItems('Other', Library.other),
              sliverItems('Romance', Library.romance),
              sliverItems('Science Fiction', Library.scienceFiction),
              sliverItems('Self Help', Library.selfHelp),
              sliverItems('Spiritual Religious', Library.spiritualReligious),
              sliverItems('Star Wars', Library.starWars),
              sliverItems('Stephen King', Library.stephenKing),
              sliverItems('Suspense', Library.suspense),
              sliverItems('Thriller', Library.thriller),
              sliverItems('Uncategorized', Library.uncategorized),
             ],
          ) : (bottomIndex ==1 ) ? const Search() : (bottomIndex == 2 ) ? const LibraryView() : Profile(),
          if(miniPlayer && Hive.box<Book>('play').isNotEmpty)
            Miniplayer(
              onDismissed: (){
              },
            minHeight: 75,
            builder: (double height, double percentage) {

                if(height>200){

                  return AudioPlayerPage(book: Hive.box<Book>('play').getAt(0)!, audioFileNo: 0);
                }
              return Container(
                color: const Color(0xff191919),
                child: Dismissible(
                  onDismissed: (dir){
                    setState((){
                      miniPlayer = false;
                    });
                  },
                  key: UniqueKey(),
                  child: Container(
                    color:  Colors.black,
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
              );
            },
            maxHeight: double.maxFinite,

          ),
          //  MiniPlayerWidget(),
        ]),
    );
  }
}

