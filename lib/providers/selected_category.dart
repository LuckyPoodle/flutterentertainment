import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/article_model.dart';
import '../utilities/networkhelper.dart';

class SelectedCategory with ChangeNotifier{

  int selectedIndex=0;
  bool toshow=true;
  String category='Alvinology';
  List<Article> providerArticles=[];
  List<Article> combinedArticles=[];
  List<Article> nonFeaturedArticles=[];
  List<Article> latestArticlefromEachBlog=[];

  int currentpagenumber=1;
  String screenlocation='consolidated';
  List<CategoryModel> categories =
  [CategoryModel('Alvinology','assets/images/alvinology.JPG'),
    CategoryModel('Lemon-Film','assets/images/lemon-film.JPG'),
    CategoryModel('RiceMedia','assets/images/rice.JPG'),
    CategoryModel('SethLui','assets/images/sethlui.JPG'),
    CategoryModel('My Lovely Blue Sky','assets/images/blusky.JPG'),
    CategoryModel('Salary.sg','assets/images/salary.JPG'),
  ];


  void updateLocation(String newlocation){
    screenlocation=newlocation;
  }


  void changeSelectedIndex(int newindex){
    selectedIndex=newindex;
    notifyListeners();

  }



  Article findById(String id){
//    if (screenlocation=='consolidated'){
//      print('FIND IN COMBINEDARTICLES');
//      return combinedArticles.firstWhere((prod) => prod.id==id);
//    }else if (screenlocation=='blogpage')
//      print('FIND IN BLOGPAGE');{
//      return providerArticles.firstWhere((prod) => prod.id==id);
//    }

  Article target=combinedArticles.firstWhere((prod) => prod.id==id);

  if (target ==''){
    print('FINDING IN PROVIDER!!!!!!!!!!!');
    target=providerArticles.firstWhere((prod) => prod.id==id);
  }

    return target;
  }



  void addPagenum(){
    currentpagenumber++;
    print("currentpagenumber is now ");
    print(currentpagenumber);
  }

  void resetPagenum(){
    currentpagenumber=1;
  }

  void setShow(bool showornot){
    toshow=showornot;
    print("TO SHOW ____");
    print(toshow);
    notifyListeners();

  }

  Future<void> clearArticles(){
    currentpagenumber=1;
    providerArticles.clear();
  }

  void changeCategory(String newcategory){
//    if (category=='Alvinology'){
//      category='Lemon-Film';
//      currentpagenumber=1;
//    }else{
//      category='Alvinology';
//      currentpagenumber=1;
//    }

    category=newcategory;
    currentpagenumber=1;
    providerArticles.clear();

    notifyListeners();
  }

  Future<List<Article>> fetchFromNonFeaturedBlogs(bool nextpage) async{
    if (nextpage!=true){
      nonFeaturedArticles.clear();
      currentpagenumber=1;
    }

    List<Article> templist=[];
    String pagenumber=currentpagenumber.toString();


//from lemonfilm
    NetworkHelper networkHelper2=NetworkHelper('https://lemon-film.com/wp-json/wp/v2/posts?page=$pagenumber');
    await networkHelper2.getData('Lemon-Film');

    templist.addAll(networkHelper2.listofarticlescurrent);
    if(nextpage!=true){
      latestArticlefromEachBlog.add(networkHelper2.listofarticlescurrent[0]);
    }


    //from mylovelyblueskies
    NetworkHelper networkHelper5=NetworkHelper('https://mylovelybluesky.com/wp-json/wp/v2/posts?page=$pagenumber&_embed');
    await networkHelper5.getData('My Lovely Blue Sky');

    templist.addAll(networkHelper5.listofarticlescurrent);
    if(nextpage!=true){
      latestArticlefromEachBlog.add(networkHelper5.listofarticlescurrent[0]);
    }

    //Salary.sg
    NetworkHelper networkHelper6=NetworkHelper('https://www.salary.sg//wp-json/wp/v2/posts?page=$pagenumber&_embed');
    await networkHelper6.getData('Salary.sg');

    templist.addAll(networkHelper6.listofarticlescurrent);
    if(nextpage!=true){
      latestArticlefromEachBlog.add(networkHelper6.listofarticlescurrent[0]);
    }
    //Juneunicorn
    NetworkHelper networkHelper7=NetworkHelper('http://juneunicorn.com/wp-json/wp/v2/posts?page=$pagenumber&_embed');
    await networkHelper7.getData('Juneunicorn');

    templist.addAll(networkHelper7.listofarticlescurrent);

    if(nextpage!=true){
      latestArticlefromEachBlog.add(networkHelper7.listofarticlescurrent[0]);
    }

    //travelintern
    NetworkHelper networkHelper8=NetworkHelper('https://thetravelintern.com/wp-json/wp/v2/posts?page=$pagenumber&_embed');
    await networkHelper8.getData('Juneunicorn');

    templist.addAll(networkHelper8.listofarticlescurrent);

    if(nextpage!=true){
      latestArticlefromEachBlog.add(networkHelper8.listofarticlescurrent[0]);
    }


    print('FETCH FINISHED!!!!!!!!!!!!!!!!!');

    templist.sort((a,b)=>b.dateforcomparison.compareTo(a.dateforcomparison));

    nonFeaturedArticles.addAll(templist);

    notifyListeners();


    return nonFeaturedArticles;


    notifyListeners();
    return combinedArticles;


  }




  Future<List<Article>> fetchFromFeaturedBlogs(bool nextpage) async{
    if (nextpage!=true){
      combinedArticles.clear();
      currentpagenumber=1;
    }

    List<Article> templist=[];
    String pagenumber=currentpagenumber.toString();

    //first fetch from alvinology
    NetworkHelper networkHelper=NetworkHelper('https://alvinology.com/wp-json/wp/v2/posts?page=$pagenumber');
    await networkHelper.getData('Alvinology');

    templist.addAll(networkHelper.listofarticlescurrent);
    if(nextpage!=true){
      latestArticlefromEachBlog.add(networkHelper.listofarticlescurrent[0]);
    }


    //from ricemedia
    NetworkHelper networkHelper3=NetworkHelper('https://ricemedia.co/wp-json/wp/v2/posts?page=$pagenumber');
    await networkHelper3.getData('RiceMedia');

    templist.addAll(networkHelper3.listofarticlescurrent);
    if(nextpage!=true){
      latestArticlefromEachBlog.add(networkHelper3.listofarticlescurrent[0]);
    }

    //from sethlui
    NetworkHelper networkHelper4=NetworkHelper('https://sethlui.com/wp-json/wp/v2/posts?page=$pagenumber&_embed');
    await networkHelper4.getData('SethLui');

    templist.addAll(networkHelper4.listofarticlescurrent);
    if(nextpage!=true){
      latestArticlefromEachBlog.add(networkHelper4.listofarticlescurrent[0]);
    }



    print('FETCH FINISHED from featured blogs!!!!!!!!!!!!!!!!!');

    templist.sort((a,b)=>b.dateforcomparison.compareTo(a.dateforcomparison));

    combinedArticles.addAll(templist);

    notifyListeners();


    return combinedArticles;


    notifyListeners();
    return combinedArticles;


  }



  Future<List<Article>> fetchArticles(bool nextpage) async{

    if (nextpage!=true){
      providerArticles.clear();
      currentpagenumber=1;
    }
    String pagenumber=currentpagenumber.toString();

   // print('category is ...........');
    //print(category);


    if (category=='Alvinology'){
     // print("fetching from Alvinology");
    //  print("page");
     // print(pagenumber);
      NetworkHelper networkHelper=NetworkHelper('https://alvinology.com/wp-json/wp/v2/posts?page=$pagenumber');
      await networkHelper.getData('Alvinology');

      providerArticles.addAll(networkHelper.listofarticlescurrent);

      notifyListeners();
      //storeArticles(providerArticles);
      return providerArticles;


    }else if (category=='Lemon-Film'){
     // print("fetching from another blog!!!!------");
     // print("page");
      print(pagenumber);
      NetworkHelper networkHelper=NetworkHelper('https://lemon-film.com/wp-json/wp/v2/posts?page=$pagenumber');
      await networkHelper.getData('Lemon-Film');

     providerArticles.addAll(networkHelper.listofarticlescurrent);

      notifyListeners();
      //storeArticles(providerArticles);
      return providerArticles;
    }else if (category=='RiceMedia'){
      NetworkHelper networkHelper=NetworkHelper('https://ricemedia.co/wp-json/wp/v2/posts?page=$pagenumber');
      await networkHelper.getData('RiceMedia');
      providerArticles.addAll(networkHelper.listofarticlescurrent);
    }else if (category=='SethLui'){
      NetworkHelper networkHelper=NetworkHelper('https://sethlui.com/wp-json/wp/v2/posts?page=$pagenumber&_embed');
      await networkHelper.getData('SethLui');
      providerArticles.addAll(networkHelper.listofarticlescurrent);
    }else if (category=='My Lovely Blue Sky'){
      NetworkHelper networkHelper=NetworkHelper('https://mylovelybluesky.com/wp-json/wp/v2/posts?page=$pagenumber&_embed');
      await networkHelper.getData('My Lovely Blue Sky');
      providerArticles.addAll(networkHelper.listofarticlescurrent);
    }else if (category=='Salary.sg'){
      NetworkHelper networkHelper=NetworkHelper('https://www.salary.sg/wp-json/wp/v2/posts?page=$pagenumber&_embed');
      await networkHelper.getData('Salary.sg');
      providerArticles.addAll(networkHelper.listofarticlescurrent);
    }


  }






}