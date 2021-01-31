import 'package:amcollective/screens/game.dart';
import 'package:flutter/material.dart';

class GamesOverallScreen

 extends StatelessWidget {
   static const routeName = '/gameoverall';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(children: <Widget>[
        SizedBox(height: 50,),


        Card(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Container(


              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text('SAVE THE LUCK ',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  Text('Guess the word correctly to save the Four Leaf Clover from the menacing fiery pot wizard! ',style: TextStyle(fontSize: 20),),
              Image.asset(
                'assets/images/gallow.png',
                fit: BoxFit.contain,

              ),
                  SizedBox(height: 20,),
                  TextButton(onPressed: (){
                    Navigator.pushReplacementNamed(context, GameHomeScreen.routeName);
                  }, child: Text('  Play!  '),style: TextButton.styleFrom(textStyle:TextStyle(fontSize: 30),primary: Colors.white,backgroundColor: Colors.purple,),)

                ],
              )
          ),
        )

      ],),
    );
  }
}