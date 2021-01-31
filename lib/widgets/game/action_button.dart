import 'package:flutter/material.dart';
import '../../utilities/constants.dart';


class ActionButton extends StatelessWidget {
  ActionButton({this.buttonTitle, this.onPress,this.buttoncolor,this.textcolor});

  final Function onPress;
  final String buttonTitle;
  final Color buttoncolor;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 3.0,
      color: buttoncolor==null? kActionButtonColor:buttoncolor,
      highlightColor: kActionButtonHighlightColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: onPress,
      child: Text(
        buttonTitle,
        style: textcolor==null?kActionButtonTextStyle:TextStyle(color: textcolor),
      ),
    );
  }
}
