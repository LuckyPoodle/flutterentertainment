import 'package:flutter/material.dart';
import '../screens/PostDetail.dart';

class ArticleTile extends StatelessWidget {
  final String imgUrl, title, desc,content,posturl,date,modifiedby;
  final String id;

  ArticleTile({this.id,this.imgUrl, this.desc, this.title, this.content, @required this.posturl,this.date,this.modifiedby});

  @override
  Widget build(BuildContext context) {
    return Material(
        child:Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  ListTile(

                    title: Text(
                      modifiedby,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(date),

                  ),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      width: double.infinity,
                      height: 300.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 5),
                            blurRadius: 8.0,
                          ),
                        ],
                        image: DecorationImage(
                          image:NetworkImage(
                            imgUrl,

                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[

                        Text(
                          title,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          desc,
                          maxLines: 2,
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.menu_book),
                    iconSize: 50.0,
                    alignment: Alignment.bottomRight,
                    onPressed: () => Navigator.of(context).pushNamed(PostDetail.routeName,arguments:id),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}