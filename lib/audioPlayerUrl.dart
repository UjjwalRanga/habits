import 'dart:core';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:habits/widgets/imageWidget.dart';
import 'package:hive/hive.dart';
import 'class/book.dart';
import 'main.dart';

class AudioPlayerUrl extends StatefulWidget {
  int audioFileNo ;
      Book book;
  AudioPlayerUrl({Key? key,
     required this.book,
    required this.audioFileNo,
 }) : super(key: key);

  @override
  _AudioPlayerUrlState createState() => _AudioPlayerUrlState();
}

class _AudioPlayerUrlState extends State<AudioPlayerUrl> {

  AudioPlayer audioPlayer = AudioPlayer();


  PlayerState audioPlayerState = PlayerState.paused;
  int timeProgress = 0;
  int audioDuration = 0;

  Widget slider() {
    return SizedBox(
      width: 300.0,
      child: Slider.adaptive(
        activeColor: Colors.white, 
          inactiveColor: Theme.of(context).primaryColor.withOpacity(0.2) ,
          value: timeProgress.toDouble(),
          max: audioDuration.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }


  @override
  void initState() {
    var box =  Hive.box<Book>('play');
    if(box.isNotEmpty && box.getAt(0) != widget.book){
      box.clear();
      box.add(widget.book);
    }else{
      box.add(widget.book);
    }

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
     setState(() {
        audioPlayerState = state;
      });
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) async {
      setState(() {
        timeProgress = position.inSeconds;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }


  playMusic() async {
    await audioPlayer.setVolume(double.maxFinite);
    await audioPlayer.play(UrlSource(widget.book.audio[widget.audioFileNo],)).then((value) {
      setState((){
        _loading = false;
      });
    });

    }



  pauseMusic() async {
    await audioPlayer.pause();
  }


  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer.seek(newPos);
  }


  static String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

 // bool _showLoading = false;

  void _showBottomSheet(){
    showModalBottomSheet(constraints: const BoxConstraints(maxHeight: 400),
        backgroundColor: Colors.black,
        context: context, builder: (_){
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: 250,
              child: Column(
                children:const [
                  Icon(Icons.minimize_rounded,color: Colors.white,size: 60),
                  SizedBox(height: 10,),
                  Text("Up Next",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          SizedBox(
            height: 300,
            child: ListView.builder(

                itemCount: widget.book.audio.length,
                itemBuilder: (ctx,index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: const Color(0xff191919),
                      child: ListTile(

                        textColor: Colors.white,
                        title: Text(widget.book.getBookName()),
                        subtitle: Text(widget.book.getAuthor()),
                      ),
                    ),
                  ),
                );
            }),
          ),
        ],
      );
    });
  }
  bool _loading  =  false;

  @override
  Widget build(BuildContext context) {
    var val = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center ,
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
              height: val.height*0.3,
              child: Column(
                children: [

                  SizedBox(width: double.infinity, child: slider()),

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getTimeString(timeProgress),style:const TextStyle(color: Colors.white),),
                        const SizedBox(width: 20),
                        Text(getTimeString(audioDuration),style:const TextStyle(color: Colors.white))
                      ],
                    ),
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
                        color: (widget.audioFileNo==0) ?  Colors.white.withOpacity(0.3)  : Colors.white,
                        onPressed: (){
                          if(widget.audioFileNo==0)return;
                                    setState(() async {
                                      widget.audioFileNo--;
                                      await audioPlayer.play(UrlSource(widget.book.audio[widget.audioFileNo]),);

                                    });
                        },
                        icon:const Icon(Icons.skip_previous_rounded,),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            color: Colors.white,
                            iconSize: 70,
                            splashRadius: 10,
                            onPressed: () {

                              if(audioPlayerState == PlayerState.playing){

                                pauseMusic();

                              }else{
                                setState((){
                                  _loading = true;
                                miniPlayer = true;
                                });
                                playMusic();
                              }


                            },
                            icon: Icon(audioPlayerState == PlayerState.playing
                                ? Icons.pause_circle_rounded
                                : Icons.play_circle_rounded,color: Colors.white)),
                         if(_loading)
                           SizedBox(
                             height: 75,
                             width: 75,
                             child: CircularProgressIndicator(
                               strokeWidth: 5,

                              color: Theme.of(context).primaryColor,
                          ),
                           )
                      ],
                      ),
                      IconButton(
                        iconSize: 50,
                        color: (widget.audioFileNo== widget.book.audio.length) ? Colors.white.withOpacity(0.3)  :Colors.white,
                        onPressed: (){
                          if(widget.audioFileNo== widget.book.audio.length)return;
                                    setState(() async {
                                      widget.audioFileNo++;
                                      await audioPlayer.play(UrlSource(widget.book.audio[widget.audioFileNo]),);

                                    });
                        },
                        icon:const Icon(Icons.skip_next_rounded),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        iconSize: 25,
                        color: Colors.white,
                        onPressed: (){},
                        icon:const Icon(Icons.file_download_outlined,),
                      ),
                      const SizedBox(width: 10,),
                    ],
                  ),

                  GestureDetector(
                    onTap: _showBottomSheet,
                    child: SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: Column(
                        children:const [
                          Icon(Icons.minimize_rounded,color: Colors.white,size: 60),
                          SizedBox(height: 10,),
                          Text("Up Next",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     IconButton(
                  //         color: Colors.white,
                  //         iconSize: 50,
                  //         onPressed: () {
                  //           if(audioFileNo==0)return;
                  //           setState(() async {
                  //             audioFileNo--;
                  //             await audioPlayer.play(UrlSource(widget.book.audio[audioFileNo]),);
                  //
                  //           });
                  //         },
                  //         icon:const Icon(Icons.keyboard_arrow_left,color: Colors.white,)),
                  //     IconButton(
                  //         color: Colors.white,
                  //         iconSize: 50,
                  //         onPressed: () {
                  //           if(audioFileNo== widget.book.audio.length)return;
                  //           setState(() async {
                  //             audioFileNo++;
                  //             await audioPlayer.play(UrlSource(widget.book.audio[audioFileNo]),);
                  //
                  //           });
                  //         },
                  //         icon:const Icon(Icons.keyboard_arrow_right,color: Colors.white,)),
                  //   ],
                  // )

                ],
              ),
            ),
            // MaterialButton(onPressed: (){
            //
            // },child: Text("Play With JustAudio"),)
          ],
        ),
      ),
    );
  }
}