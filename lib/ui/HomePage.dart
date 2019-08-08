import 'package:firebase_database/firebase_database.dart';
import 'package:first_screen/Posts.dart';
import 'package:flutter/material.dart';
import 'package:first_screen/Authentication.dart';
import 'package:first_screen/PhotoUpload.dart';

class HomePage extends StatefulWidget {

 HomePage ({
 this.auth,
 this.onSignedOut,

 });

 final AuthImplementation auth;
 final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 List<Posts> postsList = [];

 @override
  void initState() {
    
    super.initState();

    DatabaseReference postsRef=FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;


      postsList.clear();

      for(var individualKey in KEYS){
        Posts posts = new Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
          );

          postsList.add(posts);
      }

      setState(() {
        
        print('Length : $postsList.length');
      });

    });
  }

 void _logoutUser() async
 {
   try{
     await widget.auth.signOut();
     widget.onSignedOut();
   }
   catch(e)
   {
     print(e.toString());
   }
   
 }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'),),
      body: Container(
          child: postsList.length==0? Text("No Blog Post avaliable"):ListView.builder(
            itemCount: postsList.length,
            itemBuilder: (_,index){
              return PostsUI(postsList[index].image,postsList[index].description,postsList[index].date,postsList[index].time);
            },
          ),
      ),

      bottomNavigationBar: BottomAppBar(
        color:Colors.pink,

        child: Container(
          margin: EdgeInsets.only(left: 70,right: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,

            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 50,
                color: Colors.white,
                onPressed: _logoutUser,
              ),

               IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 40,
                color: Colors.white,
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context){
                      return UploadPhotoPage();
                  })
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget PostsUI(String image,String description,String date,String time)
  {
    return new Card
    (
      elevation: 10,
      margin: EdgeInsets.all(15),

      child: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(date,style:Theme.of(context).textTheme.subtitle,textAlign: TextAlign.center),
                new Text(time,style:Theme.of(context).textTheme.subtitle,textAlign: TextAlign.center),
              ],
            ),
            
            SizedBox(height: 10,),

            new Image.network(image,fit:BoxFit.cover),

            SizedBox(height: 10,),

            new Text(description,style:Theme.of(context).textTheme.subhead,textAlign: TextAlign.center),

            
          ],
        ),



      ),

    );
  }




}