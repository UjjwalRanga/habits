import 'package:flutter/material.dart';
import 'package:habits/services/getWebData.dart';
import 'package:habits/widgets/searchView.dart';
import 'class/book.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final _textController = TextEditingController();
  late String searchUrl = 'https://dailyaudiobooks.com/?s=';
  late String searchQuery = '';

  List<Book> books= [];


  @override
  void dispose(){
    _textController.dispose();
    super.dispose();
  }

  bool _showCircle = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: const Color.fromRGBO(25, 25 , 25, 1),

        title: TextField(
          onSubmitted: (value) async {
            books = [];
            searchQuery = "";
            searchUrl = 'https://dailyaudiobooks.com/?s=';
            searchQuery = value;
            searchQuery.trim();
            searchQuery = searchQuery.replaceAll(' ', '%20');
            searchUrl = searchUrl + searchQuery;

            setState((){
              _showCircle = true;
            });
            await GetWebData.getWebsiteDataInFormOfBook(searchUrl,true).then((value) => setState((){
              books = value;
            }));
            setState(() {
              _showCircle = false;
            });

          },
          style: const TextStyle(color: Colors.white),
          controller: _textController,
          autofocus: true,
          cursorColor: Colors.white,
          decoration:const InputDecoration(
              hintText: "Search audiobook",
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,

          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.close,color: Colors.white,),onPressed: (){
            setState((){
               searchQuery = '';
              _textController.clear();
            });
          },)
        ],
      ),
      backgroundColor: Colors.black,
      body: (_showCircle == true ) ? Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      ) :
            ListView.builder(itemCount: books.length,itemBuilder: (ctx,index){

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
                          MaterialPageRoute(builder: (_) {
                            return SearchView(
                              book: books[index],
                            );

                          })
                      );
                    },

                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          books[index].getImage(),
                          width: 55,

                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Image.asset('audiobook.png',fit: BoxFit.cover,width: 55,);
                        },

                      ),
                    ),
                    title: Text(books[index].getBookName(),style: const TextStyle(color: Colors.white),),
                    subtitle:Text(books[index].getAuthor(),style:const TextStyle(color: Colors.white),),
                  ),
                ),
              );
            })


    );
  }
}
