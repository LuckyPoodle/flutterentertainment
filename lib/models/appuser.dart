import 'deal.dart';
import 'address.dart';
class AppUser{

  String brandname;
  String description;
  String id;
  //List<PlaceLocation> outletlist;
  List<PlaceLocation> outletlist;
  List<Deal> dealsbybusiness=[];
  bool isBrand;



  AppUser({this.id,this.brandname,this.description,this.dealsbybusiness,this.outletlist,this.isBrand});



}