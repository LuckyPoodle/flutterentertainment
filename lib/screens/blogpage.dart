import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'blogposts.dart';
import 'package:provider/provider.dart';
import '../providers/selected_category.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/category_model.dart';
import '../widgets/category_tile.dart';
import '../utilities/networkhelper.dart';
import '../widgets/article_tile.dart';
import 'package:amcollective/widgets/bottomtab.dart';
import '../models/article_model.dart';

class BlogPage extends StatefulWidget {

  static const routeName='/blog-page';

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  ScrollController categorytilesscrollController = ScrollController();
  ScrollController postscrollController = ScrollController();

  bool _loading = false;
  bool _pressloadmore=false;

  List<Article> articlelisttoshow = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    print("init");

      Provider.of<SelectedCategory>(context, listen: false)
          .fetchArticles(false)
          .then((value) {
        print("heyy in blogpage");

        print(value);
        setState(() {

          _loading = false;
        });
        //Provider.of<SelectedCategory>(context, listen: false).updateLocation('blogpage');
      });


  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
    


  }

/*  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    currentcategory = Provider.of<SelectedCategory>(context).category;
    _loading=true;
    Provider.of<SelectedCategory>(context,listen: false).fetchArticles().then((_){
      setState(() {
        _loading=false;
      });
    });


    super.didChangeDependencies();
  }*/

//  void scrolllistener(){
//        if (categorytilesscrollController.positions.length>0 && postscrollController.position.extentAfter==0.0){
//      print ('CATEGORY!!');
//    }else if (postscrollController.positions.length>0 && categorytilesscrollController.position.extentAfter==0.0){
//      print ('POSTS!!!');
//    }
//
//  }

  bool onNotification(ScrollNotification notification) {
    if (categorytilesscrollController.hasClients) {
      if (categorytilesscrollController.positions.length > 0) {
        //print('CATEGORY!!');
        //print(categorytilesscrollController.position);
      }
    }
    if (postscrollController.hasClients) {
      if (notification is ScrollUpdateNotification) {
        //print('is update!!!!!!!!!!!');
      }
      //print('hYEYEE');

      if (postscrollController.positions.length > 0) {
        if (notification.metrics.pixels ==
            notification.metrics.maxScrollExtent) {
          //print('REAHED POOST ENDDDDDD!!');

          //currentPage+=1;
//          getArticles(currentPage+1);
//          currentPage+=1;
        }
      }
    }

    return true;
  }

  void _pressbutton() {
    setState(() {
      _pressloadmore=true;
    });
    Provider.of<SelectedCategory>(context, listen: false).addPagenum();
    print("current page now pres sbutton become ");
    print(Provider.of<SelectedCategory>(context, listen: false)
        .currentpagenumber);
    Provider.of<SelectedCategory>(context, listen: false).fetchArticles(true).then((_){
      setState(() {
        _pressloadmore=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //listener
    final categoryprovider = Provider.of<SelectedCategory>(context);
    articlelisttoshow = categoryprovider.providerArticles;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title:Text(Provider.of<SelectedCategory>(context, listen: false).category)
        ),

        body: ListView(
          children: <Widget>[
            Column(

              children: _loading
                  ? <Widget>[
                SizedBox(height:100.0),
                Center(
                  child: SpinKitChasingDots(
                    color:Colors.black,
                    size: 100.0,
                  ),
                )
              ]
                  : <Widget>[
                ListView.builder(
                    itemCount: articlelisttoshow.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    controller: postscrollController,
                    itemBuilder: (context, index) {
                      return ArticleTile(
                        origin: 'blogpage',
                        id:articlelisttoshow[index].id,
                        blogname: articlelisttoshow[index].blogname,
                        date: articlelisttoshow[index].publishedAt ??
                            "",
                        imgUrl:
                        articlelisttoshow[index].urlToImage ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Smiley_green_alien_KO.svg/163px-Smiley_green_alien_KO.svg.png",
                        title: articlelisttoshow[index].title ?? "",
                        desc:
                        articlelisttoshow[index].shortdesc ?? "",
                        content:
                        articlelisttoshow[index].content ?? "",
                        posturl:
                        articlelisttoshow[index].articleUrl ?? "",
                        modifiedby:
                        articlelisttoshow[index].modifiedby ?? "",
                      );
                    }),
                TextButton(style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.black,
                    textStyle: TextStyle(fontSize: 24, fontStyle: FontStyle.italic)),
                    onPressed: _pressbutton, child: Text('LOAD MORE')),
                SizedBox(height: 10,),
                _pressloadmore?CircularProgressIndicator():SizedBox(height: 1,),


                SizedBox(height: 80,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}


//Padding(
//padding: EdgeInsets.symmetric(horizontal: 20.0),
//child: Row(
//mainAxisAlignment: MainAxisAlignment.spaceBetween,
//children: <Widget>[
//Text(
//'Instagram',
//style: TextStyle(
//fontFamily: 'Billabong',
//fontSize: 32.0,
//),
//),
//Row(
//children: <Widget>[
//IconButton(
//icon: Icon(Icons.live_tv),
//iconSize: 30.0,
//onPressed: () => print('IGTV'),
//),
//SizedBox(width: 16.0),
//Container(
//width: 35.0,
//child: IconButton(
//icon: Icon(Icons.send),
//iconSize: 30.0,
//onPressed: () => print('Direct Messages'),
//),
//)
//],
//)
//],
//),
//),