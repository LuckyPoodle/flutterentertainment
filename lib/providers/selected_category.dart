import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/article_model.dart';
import '../utilities/networkhelper.dart';

class SelectedCategory with ChangeNotifier{

  bool toshow=true;

  String category='Alvinology';
  List<Article> providerArticles=[];
  var numberofstoredarticles=0;
  int currentpagenumber=1;
  List<CategoryModel> categories = [CategoryModel('Alvinology','https://media.alvinology.com/uploads/2020/11/am-logo-new%402x.png'),CategoryModel('Lemon-Film','https://cdn.britannica.com/84/188484-050-F27B0049/lemons-tree.jpg')];

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

  void changeCategory(){
    if (category=='Alvinology'){
      category='Lemon-Film';
      currentpagenumber=1;
    }else{
      category='Alvinology';
      currentpagenumber=1;
    }

    providerArticles.clear();

    fetchArticles();

    notifyListeners();
  }



  void storeArticles(List<Article> articlelist){
    providerArticles.addAll(articlelist);
    numberofstoredarticles+=articlelist.length;
  }

  Future<List<Article>> fetchArticles() async{
    String pagenumber=currentpagenumber.toString();

    print('category is ...........');
    print(category);

    if (category=='Alvinology'){
      print("fetching from Alvinology");
      print("page");
      print(pagenumber);
      NetworkHelper networkHelper=NetworkHelper('https://alvinology.com/wp-json/wp/v2/posts?page=$pagenumber');
      await networkHelper.getData();

      providerArticles.addAll(networkHelper.listofarticlescurrent);

      notifyListeners();
      return providerArticles;


    }else if (category=='Lemon-Film'){
      print("fetching from another blog!!!!------");
      print("page");
      print(pagenumber);
      NetworkHelper networkHelper=NetworkHelper('https://lemon-film.com/wp-json/wp/v2/posts?page=$pagenumber');
      await networkHelper.getData();

      providerArticles.addAll(networkHelper.listofarticlescurrent);

      notifyListeners();
      return providerArticles;
    }


  }






}