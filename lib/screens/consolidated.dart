import 'package:amcollective/models/ScreenArguments.dart';
import 'package:amcollective/models/category_model.dart';
import 'package:amcollective/screens/blogpage.dart';
import 'package:amcollective/screens/nonfeaturedblogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/article_model.dart';
import 'package:provider/provider.dart';
import '../providers/selected_category.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/article_tile.dart';
import '../screens/PostDetail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Consolidated extends StatefulWidget {
  const Consolidated({ Key key }) : super(key: key);

  @override
  _ConsolidatedState createState() => _ConsolidatedState();
}

class _ConsolidatedState extends State<Consolidated> {
  final PageController _pageController = PageController();

  Timer _timer;
  int _start;
  List<Article> featureSection=[];
  List<Article> allthearticles=[];
  List<CategoryModel> categorieslist=[];
  bool _pressloadmore=false;
  bool _loading=false;

  @override
  void initState() {
    print('IN INIT NOW ___________________________***********************');
    _loading=true;
    _startTimer();
    _pageController.addListener((){
      _timer.cancel();
      _startTimer();
    });
    if (Provider.of<SelectedCategory>(context, listen: false).combinedArticles.length>0){
      print("not first visit!!!!!!!");
      print(Provider.of<SelectedCategory>(context, listen: false).combinedArticles.length);
      setState(() {
        _loading=false;
      });

    }else{
//      Provider.of<SelectedCategory>(context, listen: false).fetchFromFeaturedBlogs(false).then((_){
//        setState(() {
//          _loading=false;
//        });
//      });

      Provider.of<SelectedCategory>(context, listen: false).fetchFromOxygen(false).then((_){
        setState(() {
          _loading=false;
        });
      });
    }

    Provider.of<SelectedCategory>(context, listen: false).updateLocation('consolidated');
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
 
    _timer.cancel();
    _pageController.dispose();
    
       super.dispose();
  }

  void _startTimer() {
    _start = 4;
    _timer = new Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      // setState(() {
      if (_start < 1) {
        timer.cancel();
      //  print('move to next feature and reStart');
      //  print('now pagecontroller.page..');
       // print(_pageController.page);
        _pageController.animateToPage(_pageController.page == 5.0 ? 0 : _pageController.page.toInt()+1, duration: Duration(seconds:1), curve: Curves.ease);
        _startTimer();
      } else {
        _start = _start - 1;
      //  print('current time is $_start');
      //  print('current page is ');
       //print(_pageController.page);
      }
      // });
    });
  }

//  Widget _featureItem(Article data) {
//    return GestureDetector(
//        onTap: () => print('TAPPED ON FEATURED'),
//        child: Image.network(data.urlToImage,fit: BoxFit.fitWidth)
//    );
//  }

  void _pressbutton() {
    setState(() {
      _pressloadmore=true;
    });
    Provider.of<SelectedCategory>(context, listen: false).addPagenum();
    print("current page now pres sbutton become ");
    print(Provider.of<SelectedCategory>(context, listen: false)
        .currentpagenumber);
//    Provider.of<SelectedCategory>(context, listen: false).fetchFromFeaturedBlogs(true).then((_){
//      setState(() {
//        _pressloadmore=false;
//      });
//    });

    Provider.of<SelectedCategory>(context, listen: false).fetchFromOxygen(true).then((_){
      setState(() {
        _loading=false;
      });
    });
  }

  Future<void> _refreshConsolidatedpage(BuildContext context) async {
    setState(() {
      _loading=true;
    });

    await Provider.of<SelectedCategory>(context, listen: false).fetchFromFeaturedBlogs(true).then((_){
      setState(() {
        _loading=false;
      });
    });
  }

  Widget _featureItem(Article data) {
    return GestureDetector(
        onTap: () =>Navigator.of(context).pushNamed(PostDetail.routeName,arguments:ScreenArguments(
          'toprow',
          data.id
          ,
        )),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              child:  Image.network(data.urlToImage,fit: BoxFit.cover),
            ),
            Container(
                alignment: Alignment.center,
                
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    data.title,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,  fontSize: 25.0,backgroundColor: Colors.black26),
                  ),
                )),
            Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom:20.0,),
                  child: Text(
                    data.publishedAt,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic,  fontSize: 20.0,backgroundColor: Colors.black26),
                  ),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top:20.0,),
                  child: Text(
                    data.blogname.isNotEmpty?data.blogname:'',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,  fontSize: 10.0,backgroundColor: Colors.black26),
                  ),
                ))
          ],
        )
    );
  }

  Widget _categoriesItems (CategoryModel data){
    return GestureDetector(
      onTap: (){
        Provider.of<SelectedCategory>(context,listen: false).changeCategory(data.categoryName);
        Navigator.of(context).pushNamed(BlogPage.routeName,arguments:'specificblog');

      },
      child: Padding(

        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon(itemIcon,size:28),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                  width: 220,
                  height: 120,
                  child:  Image.asset(data.imageAssetUrl,fit: BoxFit.cover),
              ),
            ),

          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final size=MediaQuery.of(context).size;
    final categoryprovider = Provider.of<SelectedCategory>(context);
    featureSection=categoryprovider.latestArticlefromEachBlog;
    allthearticles=categoryprovider.combinedArticles;
    categorieslist=categoryprovider.categories;
    return  Scaffold(

      body: _loading? Center(
        child: SpinKitChasingDots(
          color:Colors.black,
          size: 100.0,
        ),
      ) :
      RefreshIndicator(
        onRefresh: ()=>_refreshConsolidatedpage(context),

        child: ListView(
            padding: const EdgeInsets.all(2.0),

            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20,),
                  Container(
                    width: size.width,
                    height: 210,
                    child: PageView(
                      controller: _pageController,
                      children: featureSection.map(_featureItem).toList(),
                      //List<Widget>.generate(3,(index) => _featureItem('images/Feature${index+1}.png')).toList(),
                    ),
                  ), Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: categorieslist.length,
                          effect: ExpandingDotsEffect(expansionFactor: 2,),
                        ),
                      ),
                    ),
                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text('Blogs',style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
//                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                      Text('All Blogs',style: TextStyle(color: Colors.black,fontSize: 26,fontWeight: FontWeight.bold),),
                      Expanded(
                        child: Container(
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5,),

                  Container(
                    height: 150,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: categorieslist.map(_categoriesItems).toList()
                    ),
                  ),

//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text('Latest from Featured',style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
//                  ),

          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.black,
                  height: 1,
                ),
              ),
              Text('Featured Blogs',style: TextStyle(color: Colors.black,fontSize: 26,fontWeight: FontWeight.bold),),
              Expanded(
                child: Container(
                  color: Colors.black,
                  height: 1,
                ),
              ),
            ],
          ),SizedBox(height: 5,),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: height*0.6, minHeight: 100,maxWidth: width*0.9),
                    child:
                  ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: <Widget>[
                        Column(
                          children:
                          <Widget>[
                            ListView.builder(
                                itemCount: allthearticles.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),

                                itemBuilder: (context, index) {
                                  return ArticleTile(
                                    origin: 'mainpage',
                                    id:allthearticles[index].id,
                                    blogname: allthearticles[index].blogname,
                                    date: allthearticles[index].publishedAt ??
                                        "",
                                    imgUrl:
                                    allthearticles[index].urlToImage ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Smiley_green_alien_KO.svg/163px-Smiley_green_alien_KO.svg.png",
                                    title: allthearticles[index].title ?? "",
                                    desc:
                                    allthearticles[index].shortdesc ?? "",
                                    content:
                                    allthearticles[index].content ?? "",
                                    posturl:
                                    allthearticles[index].articleUrl ?? "",
                                    modifiedby:
                                    allthearticles[index].modifiedby ?? "",
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
                    )
                    ,
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: width,
                    color: Colors.black,
                    height: 1,
                  ),
                  SizedBox(height: 20,),

                  Container(
                    width: width*0.8,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow:  [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(width: 0),),
                    child: FlatButton(child: Text('Read latest from other blogs',style: TextStyle(color: Colors.white)),onPressed: (){
                      Navigator.of(context).pushNamed(NonFeaturedBlogsScreen.routeName);
                    },),),
                  SizedBox(height: 100,)

                ],
              ),
            ]),
      )
    );
  }
}