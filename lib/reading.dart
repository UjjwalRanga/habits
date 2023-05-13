
import 'package:flutter/material.dart';

class Reading extends StatelessWidget {
  final String title;
  final String story;
  Reading({required this.story,required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        centerTitle: true,
        title: const Text("AudioBooks",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(story,),
            ),
          ],
        ),
      ),
    );
  }
}
