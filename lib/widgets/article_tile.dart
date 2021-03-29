import 'package:amcollective/models/ScreenArguments.dart';
import 'package:flutter/material.dart';
import '../screens/PostDetail.dart';

class ArticleTile extends StatelessWidget {
  final String imgUrl, title, desc,content,posturl,date,modifiedby,blogname;
  final String id,origin;

  ArticleTile({this.blogname,this.origin,this.id,this.imgUrl, this.desc, this.title, this.content, @required this.posturl,this.date,this.modifiedby});

  @override
  Widget build(BuildContext context) {
    bool hasAuthor=modifiedby.isNotEmpty;
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
                      hasAuthor?modifiedby:blogname,
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
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          height: 6,
                        ),

                        Text(
                          title,
                          maxLines: 5,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          blogname=='RiceMedia'?'':desc,
                          maxLines: 10,
                          style: TextStyle(color: Colors.black54, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.menu_book),
                    iconSize: 50.0,
                    alignment: Alignment.bottomRight,
                    onPressed: () => Navigator.of(context).pushNamed(PostDetail.routeName,arguments:ScreenArguments(
                      origin,
                      id,
                    )),
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