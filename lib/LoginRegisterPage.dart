import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'DialogBox.dart';

class LoginRegisterPage extends StatefulWidget {

  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();

}


enum FormType
{
  login,
  register
}




class _LoginRegisterPageState extends State<LoginRegisterPage> {

 DialogBox dialogBox=new DialogBox();

 final formKey=new GlobalKey<FormState>();
 FormType _formType = FormType.login;
 String _email ="";
 String _password="";



 //Methods
 bool validateAndSave()
 {
   final form = formKey.currentState;
   if(form.validate()){
     form.save();
     return true;
   }
   else{
     return false;
   }
 }


void validateAndSubmit() async 
{
  if(validateAndSave())
  {
    try{
      if(_formType == FormType.login)
      {
        String userId = await widget.auth.SignIn(_email, _password);
        //dialogBox.information(context, "CongratulationS ", "your are logged in successfully.");
        print("login userId ="+ userId);
      }
      else{
         String userId = await widget.auth.SignUp(_email, _password);
        // dialogBox.information(context, "CongratulationS ", "your account has beeen created successfully.");
        print("Register userId ="+ userId);
      }

      widget.onSignedIn();
    }
    catch(e)
    {
      dialogBox.information(context, "Error = ", e.toString());
      print("Error = "+ e.toString());
    }
  }

}



 void moveToRegister(){

   formKey.currentState.reset();

   setState(() {
     _formType = FormType.register; 
   });
 }

 void moveToLogin(){

   formKey.currentState.reset();

   setState(() {
     _formType = FormType.login; 
   });
 }



  //Design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On Care'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs()+createButtons(),
          ),
        )
      )
    );
  }


  List<Widget> createInputs()
  {
    return [
      SizedBox(height: 10,), 
      logo(),
      SizedBox(height: 20,),

      new TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value){
          return value.isEmpty ? 'Email is required.' : null;
        },
        onSaved: (value){
          return _email=value;
        },
      ),
      SizedBox(height: 10,),
      new TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value){
          return value.isEmpty ? 'Password is required.' : null;
        },
        onSaved: (value){
          return _password=value;
        },
      ),
      SizedBox(height: 20,),

    
    ];
    
  }

  Widget logo()
  {
    return Hero
    (
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110,
        child: Image.asset('assets/walking.jpg'),
      
      )
    );

  }

   List<Widget> createButtons()
  {
    if(_formType==FormType.login)
    {
      return [
      
      new RaisedButton(
        child: Text("Login",style: TextStyle(fontSize: 20),),
        textColor: Colors.white,
        color: Colors.pink,
        onPressed: validateAndSubmit,
      ),

      new FlatButton(
        child: Text("Not have an account? Create Account?",style: TextStyle(fontSize: 14),),
        textColor: Colors.red,
        onPressed: moveToRegister,
        
      ),
    
    ];
    }

    else 
    {
      return [
      
      new RaisedButton(
        child: Text("Create Account",style: TextStyle(fontSize: 20),),
        textColor: Colors.white,
        color: Colors.pink,
        onPressed: validateAndSubmit,
      ),

      new FlatButton(
        child: Text("Already have an Account? Login.",style: TextStyle(fontSize: 14),),
        textColor: Colors.red,
        onPressed: moveToLogin,
        
      ),
    
    ];
    }
    
  }


}