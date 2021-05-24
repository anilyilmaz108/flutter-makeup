import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makeup/data/auth.dart';
import 'package:provider/provider.dart';

enum FormStatus {signIn,register,reset}


class EmailSignInPage extends StatefulWidget {
  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  bool _obscure = true;

  void _toggle() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  FormStatus _formStatus = FormStatus.signIn;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: _formStatus == FormStatus.signIn
            ? buildSignInForm()
            : _formStatus == FormStatus.register
            ? buildRegisterForm()
            :buildResetForm(),
      ),
    );
  }

  Widget buildSignInForm() {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    final _signInFormKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter the Login",style: TextStyle(fontSize: 25),),
            SizedBox(height: 10,),
            TextFormField(
              controller: _emailController,
              validator: (value){
                if(!EmailValidator.validate(value)){return "Please enter a valid address";}
                else{return null;}
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "E-Mail",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _passwordController,
              validator: (value){
                if(value.length<6){return "Password must contain at least 6 characters";}
                else{return null;}
              },
              obscureText: _obscure,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                      Icons.remove_red_eye,
                    color: _obscure == true ? Colors.grey : Colors.pink,
                  ),
                  onPressed: _toggle
                ),
                prefixIcon: Icon(Icons.lock),
                hintText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: ()async{
                if(_signInFormKey.currentState.validate()){}
                final user = await Provider.of<Auth>(context,listen: false).signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                if(!user.emailVerified){
                  await _showMyDialog();
                  await Provider.of<Auth>(context,listen: false).SignOut();
                }
                Navigator.pop(context);
              },
              child: Text("Login"),
            ),
            TextButton(
              onPressed: (){
                setState(() {
                  _formStatus = FormStatus.register;
                });
              },
              child: Text("Click For New Registration"),
            ),
            TextButton(
              onPressed: (){
                setState(() {
                  _formStatus = FormStatus.reset;
                });
              },
              child: Text("I forgot my password"),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildRegisterForm() {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _passwordConfirmController = TextEditingController();
    final _registerFormKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Registration form",style: TextStyle(fontSize: 25),),
            SizedBox(height: 10,),
            TextFormField(
              controller: _emailController,
              validator: (value){
                if(!EmailValidator.validate(value)){return "You entered the wrong e-mail";}
                else{return null;}
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "E-Mail",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _passwordController,
              validator: (value){
                if(value.length<6){return "Password must contain at least 6 characters";}
                else{return null;}
              },
              obscureText: _obscure,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: _obscure == true ? Colors.grey : Colors.pink,
                    ),
                    onPressed: _toggle
                ),
                hintText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _passwordConfirmController,
              validator: (value){
                if(value != _passwordController.text){return "Passwords do not match";}
                else{ return null;}
              },
              obscureText: _obscure,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: _obscure == true ? Colors.grey : Colors.pink,
                    ),
                    onPressed: _toggle
                ),
                prefixIcon: Icon(Icons.lock),
                hintText: "Verify",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: ()async{
                try{
                  if (_registerFormKey.currentState.validate()) {
                    final user = await Provider.of<Auth>(context, listen: false)
                        .CreateUserWithEmailAndPassword(
                        _emailController.text, _passwordController.text);
                    if (!user.emailVerified) {
                      await user.sendEmailVerification();
                    }
                    await _showMyDialog();
                    await Provider.of<Auth>(context, listen: false).SignOut();

                    setState(() {
                      _formStatus = FormStatus.signIn;
                    });

                  }
                }
                on FirebaseAuthException catch(e){
                }
              },
              child: Text("Register"),
            ),
            TextButton(
              onPressed: (){
                setState(() {
                  _formStatus = FormStatus.signIn;
                });
              },
              child: Text("Already a Member? Click Here"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResetForm() {
    TextEditingController _emailController = TextEditingController();

    final _resetFormKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _resetFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Password Renewal",style: TextStyle(fontSize: 25),),
            SizedBox(height: 10,),
            TextFormField(
              controller: _emailController,
              validator: (value){
                if(!EmailValidator.validate(value)){return "You entered the wrong e-mail";}
                else{return null;}
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "E-Mail",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(height: 10,),

            ElevatedButton(
              onPressed: ()async{
                if(_resetFormKey.currentState.validate()){
                  await Provider.of<Auth>(context,listen: false).sendPasswordResetEmail(_emailController.text);

                  await _showResetPasswordDialog();
                  Navigator.pop(context);
                  //print(user.emailVerified);
                }
              },
              child: Text("Submit"),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('REQUIRES APPROVAL'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Hello Please Check Your Mail.'),
                Text('You must close the confirmation link and log in again.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Understood'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showResetPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Renewal'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Hello Please Check Your Mail.'),
                Text('Click on the link to change your password.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Understood'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}
