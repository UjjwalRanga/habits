import 'package:flutter/material.dart';
import 'package:habits/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String user = 'Guest' ;

  // final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  // SharedPreferences pref = await prefs;

  @override
  void initState(){

    //user = pref.get("user") as String;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi There,",style: TextStyle(color: Theme.of(context).primaryColor,
                    fontSize: 40,fontWeight: FontWeight.bold),),
                Row(
                  children: [
                     Text(user,style: const TextStyle(color: Colors.white,
                        fontSize: 20),),
                    IconButton(onPressed: (){
                      showDialog(context: context, builder: (ctx){
                        return AlertDialog(
                          title:  TextField(
                            onSubmitted: (val){

                              setState((){
                                user = val;
                             //   pref.setString('user', val);
                              });
                            },
                            decoration:const InputDecoration(labelText: "Name",),

                          ),
                          actions: [
                            MaterialButton(onPressed: (){},
                                color:Theme.of(context).primaryColor,
                                child:const Text("ok",style: TextStyle(color: Colors.white),) ),

                        MaterialButton(
                                onPressed: (){
                              Navigator.of(context).pop();},
                           color:Theme.of(context).primaryColor,
                        child:const Text("cancel",style: TextStyle(color: Colors.white)) ),
                          ],
                        );
                      });
                    },icon: const Icon(Icons.edit),color: Colors.white,),
                  ],
                ),
              ],
            ),
             SizedBox(height: 20,),
             Container(

              child: Row(
                children: const [
                  Icon(Icons.home_rounded,color: Colors.white),
                  SizedBox(width: 10,),
                  Text("Home Settings",style: TextStyle(color: Colors.white),),

               ]
              ),
            ),
            const SizedBox(height: 20,),
            Container(

              child: Row(
                  children: const [
                    Icon(Icons.collections_bookmark_rounded,color: Colors.white,),
                    SizedBox(width: 10,),
                    Text("Library Settings",style: TextStyle(color: Colors.white),),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
