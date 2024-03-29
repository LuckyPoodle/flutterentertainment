import 'package:amcollective/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utilities/constants.dart';
import '../utilities/authservice.dart';
import '../widgets/bottomtab.dart';
import '../screens/deals.dart';

import 'package:provider/provider.dart';
import '../providers/roleprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utilities/httpexception.dart';
enum AuthMode { Signup, Login,ForgetPassword }
class AuthCard extends StatefulWidget {

  AuthService thisauth;
  AuthCard(this.thisauth);
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _submit() async{
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try{
      if (_authMode == AuthMode.Login)  {
        // Log user in
        //await Provider.of<Auth>(context,listen: false).login(_authData['email'], _authData['password']);
        var user = await widget.thisauth.signInWithEmail(
            _authData['email'], _authData['password']);
        print('loggin in!!!!!!');

        print('oooh gg to push!!!');
        if (user != null) {
         // await Provider.of<RoleProvider>(context).getUserData();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TabsScreen(
                      3
                  ),
            ),
          );
        }
      } else if (_authMode == AuthMode.Signup) {
        // Sign user up
        //await Provider.of<Auth>(context,listen: false).signup(_authData['email'], _authData['password']);
        var user = await widget.thisauth.registerWithEmail(
            _authData['email'], _authData['password']);

        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TabsScreen(
                      1
                  ),
            ),
          );
        }
      }else{
        //reset password
        await widget.thisauth.resetPassword(_authData['email']);
        final snackBar = SnackBar(content: Text('Reset password email sent!'));

        // Find the Scaffold in the widget tree and use it to show a SnackBar.
        Scaffold.of(context).showSnackBar(snackBar);
        setState(() {
          _authMode=AuthMode.Login;
        });


      }
      // Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
    }on HttpException catch (error){
      var errorMessage='Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')){
        errorMessage='Email address is already in use';
      }else if (error.toString().contains('INVALID_EMAIL')){
        errorMessage='Email not valid';
      }else if (error.toString().contains('WEAK_PASSWORD')){
        errorMessage='Please use a stronger password';
      }else if (error.toString().contains('EMAIL_NOT_FOUND')){
        errorMessage='Invalid login details';
      }else if (error.toString().contains('INVALID_PASSWORD')){
        errorMessage='Invalid login details';
      }
      _showErroDialog(errorMessage);

    }catch(error){
      //to catch error not caught by httpexception if any
      const errorMessage='Please try again later';
      _showErroDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErroDialog(String message){
    showDialog(context: context,builder: (ctx)=>AlertDialog(title: Text('An Error Occurred'),content: Text(message),actions: <Widget>[
      FlatButton(onPressed: (){
        Navigator.of(ctx).pop();
      }, child: Text('Okay'))
    ],));
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  void _switchToResetPw(){
    setState(() {
      _authMode=AuthMode.ForgetPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 300,
        constraints:
        BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (_authMode==AuthMode.ForgetPassword)
                  Text('Enter your account email, we will send a reset link',style: TextStyle(fontSize: 20),),

                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
               if(_authMode==AuthMode.Signup||_authMode==AuthMode.Login)
                 TextFormField(
                   decoration: InputDecoration(labelText: 'Password'),
                   obscureText: true,
                   controller: _passwordController,
                   validator: (value) {
                     if (value.isEmpty || value.length < 5) {
                       return 'Password is too short!';
                     }
                   },
                   onSaved: (value) {
                     _authData['password'] = value;
                   },
                 ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match!';
                      }
                    }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                    _authMode==AuthMode.ForgetPassword?Text('Submit'):Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',style: TextStyle(color: Colors.black),),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
                if(_authMode==AuthMode.Signup||_authMode==AuthMode.Login)
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      _switchToResetPw();
                    },
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )
              ],

            ),

          ),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  final double extent;

  MyCustomClipper({this.extent});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, extent);
    path.lineTo(extent, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class StripsWidget extends StatelessWidget {
  final Color color1;
  final Color color2;
  final double gap;
  final noOfStrips;

  const StripsWidget(
      {Key key, this.color1, this.color2, this.gap, this.noOfStrips})
      : super(key: key);

  List<Widget> getListOfStripes() {
    List<Widget> stripes = [];
    for (var i = 0; i < noOfStrips; i++) {
      stripes.add(
        ClipPath(
          child: Container(color: (i%2==0)?color1:color2),
          clipper: MyCustomClipper(extent: i*gap),
        ),
      );
    }
    return stripes;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: getListOfStripes());
  }
}
class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}



class _AuthScreenState extends State<AuthScreen> {
  AuthService auth = AuthService();


  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {

        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }


  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => print('Login Button Pressed'),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }


  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          _buildSocialBtn(
                () async{
                 var user= await auth.signInWithGoogle();
                 if (user!=null){
                   Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => TabsScreen(
                        1
                        ),
                        ),
                        );
                 }

                },
            AssetImage(
              'assets/images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {





    return SafeArea(child: Scaffold(
      appBar: AppBar(
automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.home),
        onPressed:(){

            Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TabsScreen(
                                        1
                                    ),
                                  ),
                                );
}),
         
          title:Text('Sign in/Sign up')
        ),

        
      
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                child: StripsWidget(
                  color1:Color.fromRGBO(0, 0, 0, 0.5),
                  color2:Color.fromRGBO(255, 255, 255, 0.5),
                  gap: 100,
                  noOfStrips: 10,
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      AuthCard(auth),



                      _buildSignInWithText(),
                      _buildSocialBtnRow(),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
