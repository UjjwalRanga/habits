import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:habits/player/notifier/play_button_notifier.dart';
import 'package:habits/player/notifier/progress_notifier.dart';
import 'package:habits/player/page_manager.dart';
import 'package:habits/widgets/imageWidget.dart';
import 'package:hive/hive.dart';
import 'class/book.dart';

enum ProgressState{
  idle,loading,buffering,ready,completed
}

class AudioPlayerPage extends StatefulWidget {

  int audioFileNo ;
  final Book book;
   AudioPlayerPage({required this.book,required this.audioFileNo});
  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}
late PageManager _pageManager;

class _AudioPlayerPageState extends State<AudioPlayerPage> {


  @override
  void initState(){

    var box =  Hive.box<Book>('play');
    if(box.isNotEmpty && box.getAt(0) != widget.book){
      box.clear();
      box.add(widget.book);
    }else{
      box.add(widget.book);
    }
    _pageManager = PageManager(widget.book);
    if(widget.audioFileNo != 0){
      _pageManager.setUrl(widget.book.audio[widget.audioFileNo]);
    }
    super.initState();
  }



  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  Duration seekValue = const Duration(seconds: 5);
  double speed = 1.0;

  @override
  Widget build(BuildContext context) {
    var val = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround ,
          children: [

            SizedBox(
              height: val.height*0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: val.height*0.09,),
                  Expanded(
                    child: Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ImageWidget(width: 300,book: widget.book,)
                      ),
                    ),
                  ),
                  SizedBox(height: val.height*0.02,),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: FittedBox(child: Text(widget.book.getBookName(),style: const TextStyle(color:Colors.white,fontSize: 45,fontWeight: FontWeight.bold),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: FittedBox(child: Text(widget.book.getAuthor(),style: const TextStyle(color:Colors.white,fontSize: 15,),)),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: val.height*0.2,
              child: Column(
                children: [

                   const Padding(
                        padding:  EdgeInsets.only(left: 20,right: 20),
                              child: AudioProgressBar(),
                           ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10,),
                      IconButton(
                        iconSize: 25,
                        color: Colors.white,
                        onPressed: (){},
                        icon:const Icon(Icons.favorite_border_rounded,),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        iconSize: 50,
                        color: Colors.white,
                        onPressed: (){

                          setState(() {
                            if(_pageManager.progressNotifier.value.current < seekValue ){

                              _pageManager.seek( const Duration(seconds: 0));

                            }else{
                              _pageManager.seek( Duration(seconds: _pageManager.progressNotifier.value.current.inSeconds -seekValue.inSeconds));
                            }
                          });
                        },
                        icon:const Icon(Icons.fast_rewind_rounded,),
                      ),
                      const PlayButton(),
                      IconButton(
                        iconSize: 50,
                        color: Colors.white,
                        onPressed: (){
                          setState(()  {
                            if(_pageManager.progressNotifier.value.current >  Duration(seconds: _pageManager.progressNotifier.value.total.inSeconds -seekValue.inSeconds)){

                              _pageManager.seek( Duration(seconds: _pageManager.progressNotifier.value.total.inSeconds));
                            }else{
                              _pageManager.seek( Duration(seconds: _pageManager.progressNotifier.value.current.inSeconds +seekValue.inSeconds));
                            }
                          });
                        },
                        icon:const Icon(Icons.fast_forward_rounded),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        iconSize: 25,
                        color: Colors.white,
                        onPressed: (){




                          showDialog(context: context, builder: (ctx){
                            return  StatefulBuilder(
                            builder: (context, setState) {
                              return
                                AlertDialog(
                                backgroundColor: const Color(0xff101010),
                                title:const Center(child:  Text("Adjust Speed",style: TextStyle(color: Colors.white,fontSize: 20),)),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(onPressed: (){
                                      if(speed < 0.5)return;
                                      setState((){
                                        speed -= 0.1;
                                        _pageManager.setSpeed(speed);
                                      });
                                    },child: const Text("-",style: TextStyle(color: Colors.white,fontSize: 20),) ,),
                                    Text(speed.toStringAsFixed(1),style:const  TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                    TextButton(onPressed: (){
                                      if(speed > 3.0)return;
                                      setState((){
                                        speed += 0.1;
                                        _pageManager.setSpeed(speed);
                                      });
                                    },child: const Text("+",style: TextStyle(color: Colors.white,fontSize: 20),) ,),
                                  ],
                                ),
                              );

                          }
                          );
                          });



                        },
                        icon:const Icon(Icons.speed,),
                      ),
                      const SizedBox(width: 10,),
                    ],
                  ),


                ],
              ),
            ),

            SizedBox(
              height: val.height*0.1,
              child: ListView.builder(itemBuilder: (ctx,index){

                return  GestureDetector(
                  onTap: (){
                    setState(()  {
                        _pageManager.setUrl(widget.book.audio[index]);
                        _pageManager.play();
                      });
                    },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: (index == widget.audioFileNo)
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColor.withOpacity(0.2)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(borderRadius: BorderRadius.circular(10),child: ImageWidget(book: widget.book, width: 55,height: 55,),),
                          Text("Part ${index+1}",style: const TextStyle(color: Colors.white,fontSize: 8),)
                        ],
                      ),
                    ),
                  ),
                );
              },scrollDirection: Axis.horizontal,
                itemCount: widget.book.audio.length,),
            )
          ],
        ),
      ),
    );
  }
}


class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: _pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          timeLabelTextStyle: const TextStyle(color: Colors.white),
          timeLabelPadding: 8,
          progressBarColor: Theme.of(context).primaryColor,
          baseBarColor: Colors.white.withOpacity(0.24),
          bufferedBarColor: Theme.of(context).primaryColor.withOpacity(0.24),
          thumbColor: Colors.white,

          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: _pageManager.seek,
        );
      },
    );
  }
}


class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: _pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Stack(
              alignment: Alignment.center,
              children: [

                IconButton(
                color: Colors.white,
                icon: const Icon(Icons.play_circle_rounded),
                splashRadius: 20,
                iconSize: 70,
                onPressed: _pageManager.play,
              ),
                SizedBox(
                    height: 70,
                    width: 70,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Theme.of(context).primaryColor,
                    )),
              ],
            );
          case ButtonState.paused:
            return IconButton(
              color: Colors.white,
              icon: const Icon(Icons.play_circle_rounded),
              iconSize: 70,
              splashRadius: 20,
              onPressed: _pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              color: Colors.white,
              icon: const Icon(Icons.pause_circle_rounded),
              splashRadius: 20,
              iconSize: 70,
              onPressed: _pageManager.pause,
            );
        }
      },
    );
  }
}