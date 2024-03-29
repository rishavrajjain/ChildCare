import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:first_screen/ui/HomePage.dart';


class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {


  File sampleImage;
  String _myValue;
  String url;

  final formKey = new GlobalKey<FormState>();


  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      
      sampleImage=tempImage;
    });
  }
 

  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else
    {
      return false;
    }

  }

  void uploadStatusImage() async
  {
    if(validateAndSave())
    {
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");

      var timeKey = new DateTime.now();

      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString()+".jpg").putFile(sampleImage);

      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();

      print("Image Url=" + url);

      goToHomePage();

      saveToDatabase(url);
    }
  }


  void saveToDatabase(url)
  {
     var dbTimeKey = new DateTime.now();
     var formatDate = new  DateFormat('MMM d,yyyy');
     var formatTime = new  DateFormat('EEEE, hh::mm aaa');

     String date = formatDate.format(dbTimeKey);
     String time = formatTime.format(dbTimeKey);

     DatabaseReference ref = FirebaseDatabase.instance.reference();

     var data = {
       "image": url,
       "description": _myValue,
       "date": date,
       "time": time,
     };

     ref.child("Posts").push().set(data);

  }

  void goToHomePage()
  {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context){
          return HomePage();
      })
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image"),centerTitle: true,),
      body: Center(
        child: sampleImage == null ? Text("Select an Image"): enableUpload(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
 
  Widget enableUpload(){

    return new Container(
      padding: const EdgeInsets.fromLTRB(30,10,30,30),
      child: Form(
        key: formKey,
        child:   SingleChildScrollView(child:Column(
        children: <Widget>[
          Image.file(sampleImage,height: 330,width: 390,),

          //SizedBox(height: 15,),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(labelText: 'Description'),
            validator: (value){
              return value.isEmpty ? 'Description is required' : null;

            } ,

            onSaved: (value){
              return _myValue=value;
            },
          ),

          SizedBox(height: 15,),

          RaisedButton(
            elevation: 10,
            child: Text('Add a New Post'),
            textColor: Colors.white,
            color: Colors.pink,

            onPressed: uploadStatusImage,
          )



        ],
      ),),
      ),
    );

  }



}