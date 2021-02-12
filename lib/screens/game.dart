import 'package:flutter/material.dart';
import 'package:amcollective/widgets/bottomtab.dart';
import '../utilities/hangman_words.dart';
import '../widgets/game/action_button.dart';
import './game_screen.dart';
import './loading_screen.dart';
class GameHomeScreen extends StatefulWidget {
  static const routeName='/game';
  final HangmanWords hangmanWords = HangmanWords();

  @override
  _GameHomeScreenState createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    widget.hangmanWords.readWords();
    return Scaffold(

      body: SafeArea(
          child:SingleChildScrollView(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 8.0),
                    child: Text(
                      'SAVE THE LUCK',
                      textAlign: TextAlign.center,
                      style: TextStyle(

                          color: Colors.black,
                          fontSize: 58.0,
                          fontFamily: 'Alfa Slab One',
                          fontWeight: FontWeight.w300,
                          letterSpacing: 3.0),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: Image.asset(
                      'assets/images/gallow.png',
                      height: height * 0.49,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Center(
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
//                    width: 155,
                          height: 30,
                          child: ActionButton(
                            buttonTitle: 'Start',
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameScreen(
                                    hangmanObject: widget.hangmanWords,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 18.0,
                        ),
                        Container(
//                    width: 155,
                          height: 30,
                          child: ActionButton(
                            buttonTitle: 'High Scores',
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoadingScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 18.0,
                        ),
                        Container(
//                    width: 155,
                            height: 40,

                            child: ActionButton(
                              buttoncolor: Colors.red,
                              textcolor:Colors.white,
                              buttonTitle: 'EXIT',
                              onPress: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TabsScreen(
                                        2
                                    ),
                                  ),
                                );
                              },
                            )
                        ),
                        SizedBox(height: 5,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
