import 'package:flutter/material.dart';
import '../models/deal.dart';


class DealProvider with ChangeNotifier{


  bool thisdealalreadyhasimage=false;

  void dealalreadyhasimage(){
    thisdealalreadyhasimage=true;
    notifyListeners();
    
  }


  bool dealaddimage(){
    thisdealalreadyhasimage=false;
    notifyListeners();
  }


  List<Deal> dealsinprovider = [];
  DealProvider(this.dealsinprovider);

  Deal findById(String id){
    print('in find deal by id');
    print(dealsinprovider);
    return dealsinprovider.firstWhere((prod) => prod.id==id);
}


List<Deal> getDealsFrom(String region){
  List<Deal> newlist = [for (var e in dealsinprovider) if (e.region==region) e];
  return newlist;
}


















}