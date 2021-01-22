import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'blogposts.dart';
import 'package:provider/provider.dart';
import '../providers/selected_category.dart';

import '../models/category_model.dart';
import '../widgets/category_tile.dart';
import '../utilities/networkhelper.dart';
import '../widgets/article_tile.dart';
import 'package:amcollective/widgets/bottomtab.dart';
import '../models/article_model.dart';

class BlogPage extends StatefulWidget {


  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  ScrollController categorytilesscrollController = ScrollController();
  ScrollController postscrollController = ScrollController();

  bool _loading = false;

  var currentcategory = 'Alvinology';
  List<Article> articlelisttoshow = [];

//  void getArticles(int page) async {
//    String pagenumber=page.toString();
//
//    if (currentcategory=='Alvinology'){
//      print("fetching from Alvinology");
//      print("page");
//      print(pagenumber);
//      NetworkHelper networkHelper=NetworkHelper('https://alvinology.com/wp-json/wp/v2/posts?page=$pagenumber');
//      await networkHelper.getData();
//
//      setState(() {
//        articlelisttoshow = networkHelper.listofarticlescurrent;
//        _loading = false;
//      });
//    }else if (currentcategory=='Lemon-Film'){
//      print("fetching from another blog!!!!------");
//      print("page");
//      print(pagenumber);
//      NetworkHelper networkHelper=NetworkHelper('https://lemon-film.com/wp-json/wp/v2/posts?page=$pagenumber');
//      await networkHelper.getData();
//
//
//      setState(() {
//        articlelisttoshow = networkHelper.listofarticlescurrent;
//        _loading = false;
//      });
//    }
//
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    print("init");

    Provider.of<SelectedCategory>(context, listen: false)
        .fetchArticles()
        .then((value) {
      print("heyy");
      print(value);
      setState(() {
        articlelisttoshow = value;
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

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
        print('CATEGORY!!');
        print(categorytilesscrollController.position);
      }
    }
    if (postscrollController.hasClients) {
      if (notification is ScrollUpdateNotification) {
        print('is update!!!!!!!!!!!');
      }
      print('hYEYEE');

      if (postscrollController.positions.length > 0) {
        if (notification.metrics.pixels ==
            notification.metrics.maxScrollExtent) {
          print('REAHED POOST ENDDDDDD!!');

          //currentPage+=1;
//          getArticles(currentPage+1);
//          currentPage+=1;
        }
      }
    }

    return true;
  }

  void _pressbutton() {
    Provider.of<SelectedCategory>(context, listen: false).addPagenum();
    print("current page now pres sbutton become ");
    print(Provider.of<SelectedCategory>(context, listen: false)
        .currentpagenumber);
    Provider.of<SelectedCategory>(context, listen: false).fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    //listener
    final categoryprovider = Provider.of<SelectedCategory>(context);
    List<CategoryModel> categories = categoryprovider.categories;

    articlelisttoshow = categoryprovider.providerArticles;
    return NotificationListener<ScrollNotification>(
        onNotification: onNotification,
        child:  ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Instagram',
                        style: TextStyle(
                          fontFamily: 'Billabong',
                          fontSize: 32.0,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.live_tv),
                            iconSize: 30.0,
                            onPressed: () => print('IGTV'),
                          ),
                          SizedBox(width: 16.0),
                          Container(
                            width: 35.0,
                            child: IconButton(
                              icon: Icon(Icons.send),
                              iconSize: 30.0,
                              onPressed: () => print('Direct Messages'),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  height: 70,
                  child: ListView.builder(
                      controller: categorytilesscrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            _loading=true;

                          Provider.of<SelectedCategory>(context, listen: false).changeCategory();
                          categoryprovider.fetchArticles().then((_){
                            _loading=false;
                          });
                          print('tapped!!');
                          print( Provider.of<SelectedCategory>(context, listen: false).category);

                        },

                          child: CategoryCard(
                            imageAssetUrl: categories[index].imageAssetUrl,
                            categoryName: categories[index].categoryName,
                          ),
                        );
                      }),
                ),
                Column(
                  children: _loading
                      ? <Widget>[
                          Center(
                            child: CircularProgressIndicator(),
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
                                  id:articlelisttoshow[index].id,
                                  date: articlelisttoshow[index].publishedAt ??
                                      "",
                                  imgUrl:
                                      articlelisttoshow[index].urlToImage ?? "",
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
                          TextButton(
                              onPressed: _pressbutton, child: Text('LOAD MORE')),
                    SizedBox(height: 80,)
                        ],
                ),
              ],
            ));
  }
}
