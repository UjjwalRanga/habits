import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import '../audioPlayerUrl.dart';
import '../class/book.dart';

class SearchView extends StatefulWidget {
    Book book;

  SearchView({
    required this.book,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  List<Book> books= [];

  bool isInLib = false;

  @override
  void initState(){

    var box = Hive.box<Book>("Lib");


    if(box.containsKey(widget.book.id)) {
      isInLib = true;
    }

    getWebsiteData();
    super.initState();
  }


  Future getWebsiteData() async {
    if(widget.book.getAuthor() == ' ')return;

    String searchUrl = 'https://dailyaudiobooks.com/?s=${widget.book.getAuthor()}';
    final url = Uri.parse(searchUrl);

    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    List<Book> b= [];

    final data = html.querySelectorAll('body article').map((e) {
      String? id = e.attributes['id'];
      String title = e.querySelector('h2 > a')!.innerHtml.toString();
      String? image = e.querySelector('img')?.attributes['src'].toString();
      List<String> audio = e.querySelectorAll('audio.wp-audio-shortcode > a').map((e) => e.attributes['href']!).toList();

      Book book = Book(audio: audio, title: title, imageUrl: image,id: id!);
      b.add(book);

    });
    print(data);
      books = b;
      setState((){
      _showCircle = false;

      });
  }

  late bool _showCircle = true;

  @override
  Widget build(BuildContext context) {
    var val = MediaQuery.of(context).size;
    return Scaffold(

        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    height: val.height*0.3,
                    width: val.width,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.book.getImage(),
                            width: 175,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Image.asset('audiobook.png',fit: BoxFit.cover,width: 175,);
                            },

                          ),
                        ),
                        const SizedBox(width: 10,),
                        SizedBox(
                          width: val.width/2,
                          height: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10,top: 8,right: 10,),
                                child: Text(widget.book.getBookName(),
                                  maxLines: 3,
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
                                              return AudioPlayerUrl(book: widget.book,audioFileNo: 0,);
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

                                          if(box.containsKey(widget.book.id)){
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
                  height: val.height*0.62,
                  child: (_showCircle == true ) ? Center(
                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
              ) : ListView.builder(itemCount: books.length,itemBuilder: (ctx,index){

                    if(books[index].id == widget.book.id) return Container();
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
                                return AudioPlayerUrl(book: books[index],audioFileNo: index,);
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
              }),
                ),
            ]),
          ),
        )


    );
  }
}
