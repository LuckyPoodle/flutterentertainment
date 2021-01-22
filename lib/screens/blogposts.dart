//import '../providers/selected_category.dart';
//
//import 'package:flutter/material.dart';
//import '../utilities/networkhelper.dart';
//import 'package:provider/provider.dart';
//import '../widgets/category_tile.dart';
//import '../widgets/article_tile.dart';
//import '../models/category_model.dart';
//import 'dart:developer';
////////TO DO , listen to current category change in provider
//
//class BlogPosts extends StatefulWidget {
//  @override
//  _BlogPostsState createState() => _BlogPostsState();
//}
//
//class _BlogPostsState extends State<BlogPosts> {
//  ScrollController _scrollController = ScrollController();
//  int currentPage = 1;
//  bool _loading;
//  var currentcategory='Alvinology';
//  var articlelisttoshow;
//
//
//
//
//
//  void getArticles(int page) async {
//    String pagenumber=page.toString();
//
//    if (currentcategory=='Alvinology'){
//      print("fetching from Alvinology");
//      print("page");
//      print(pagenumber);
//      NetworkHelper networkHelper=NetworkHelper('https://alvinology.com/wp-json/wp/v2/posts?page=$pagenumber');
//      await networkHelper.getData();
//      articlelisttoshow = networkHelper.listofarticlescurrent;
//      print(articlelisttoshow[0]);
//      setState(() {
//        _loading = false;
//      });
//    }else if (currentcategory=='Lemon-Film'){
//      print("fetching from another blog!!!!------");
//      print("page");
//      print(pagenumber);
//      NetworkHelper networkHelper=NetworkHelper('https://lemon-film.com/wp-json/wp/v2/posts?page=$pagenumber');
//      await networkHelper.getData();
//      articlelisttoshow = networkHelper.listofarticlescurrent;
//      print(articlelisttoshow[0]);
//      setState(() {
//        _loading = false;
//      });
//    }
//
//  }
//
//  @override
//  void initState() {
//    _loading = true;
//    // TODO: implement initState
//    super.initState();
//    getArticles(currentPage);
//    print("init");
//    log('hi!');
//
//
//  }
//
//  @override
//  void didChangeDependencies() {
//    // TODO: implement didChangeDependencies
//
//    currentcategory=Provider.of<SelectedCategory>(context).category;
//    _loading = true;
//    currentPage=1;
//
//    getArticles(currentPage);
//
//
//    super.didChangeDependencies();
//  }
//
//  bool onNotification (ScrollNotification notification){
//    print('onNotification');
//
//    if (notification is OverscrollNotification) {
//      print("ENDDDDD");
//      Provider.of<SelectedCategory>(context,listen: false).setShow(true);
//    }
//
//    if (notification is ScrollUpdateNotification) {
//      print('offset');
//      Provider.of<SelectedCategory>(context,listen: false).setShow(false);
//
//      print(_scrollController.offset);
//
//
//    }
//    return true;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    currentcategory=Provider.of<SelectedCategory>(context).category;
//
//    return Container(
//      child: _loading
//          ? Center(
//        child: CircularProgressIndicator(),
//      )
//          :
//
//      NotificationListener<ScrollNotification>(
//        onNotification: (notification){
//          onNotification(notification);
//
//          return true;
//        },
//        child: ListView.builder(
//            itemCount: articlelisttoshow.length,
//            shrinkWrap: true,
//            controller: _scrollController,
//            physics: ClampingScrollPhysics(),
//
//            itemBuilder: (context, index) {
//              return ArticleTile(
//                date:articlelisttoshow[index].publishedAt??"",
//                imgUrl: articlelisttoshow[index].urlToImage ?? "",
//                title: articlelisttoshow[index].title ?? "",
//                desc: articlelisttoshow[index].shortdesc ?? "",
//                content: articlelisttoshow[index].content ?? "",
//                posturl: articlelisttoshow[index].articleUrl ?? "",
//                modifiedby: articlelisttoshow[index].modifiedby??"",
//              );
//            }),
//      ),
//
//
//    );
//
//
//  }
//}