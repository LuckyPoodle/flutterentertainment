import 'package:flutter/material.dart';
import '../models/deal.dart';


class DealProvider with ChangeNotifier{


  List<Deal> dealsinprovider = [];


  DealProvider(this.dealsinprovider);

  Deal findById(String id){
    print('in find deal by id');
    print(dealsinprovider);
    return dealsinprovider.firstWhere((prod) => prod.id==id);
}












}