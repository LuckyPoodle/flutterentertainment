import 'deal.dart';
import 'address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AppUser{

  String profileimg;
  String brandname;
  String description;
  String id;
  //List<PlaceLocation> outletlist;
  List<PlaceLocation> outletlist;
  List<Deal> dealsbybusiness=[];
  bool isBrand;



  AppUser({this.id,this.profileimg,this.brandname,this.description,this.dealsbybusiness,this.outletlist,this.isBrand});

  factory AppUser.fromDocument(QueryDocumentSnapshot data) {
    print('in appuser from document');
    print(data['brandname']);
    print(data.id);
    print(data.reference.id);



    return AppUser(
      brandname: data['brandname'],
      profileimg: data['profileimg'],
      description: data['descriptiom'],
      isBrand: data['isBrand'],
      outletlist: (data['outletlist'] as List??[]).map((v)=>PlaceLocation.fromMap(v)).toList(),
      id:  data.reference.id,

    );
  }
  static List<Map> ConvertCustomStepsToMap(List<PlaceLocation> customSteps) {
    List<Map> steps = [];
    customSteps.forEach((PlaceLocation customStep) {
      Map step = customStep.toMap();
      steps.add(step);
    });
    return steps;
  }

  Map<String, dynamic> toMap() {
    return {
      'brandname': brandname,
      'profileimg': profileimg,
      'description': description,
      'isBrand':isBrand,
      'outletlist':ConvertCustomStepsToMap(outletlist),
      'id':id
    };
  }




/*  Stream<User> userData(String uid) {
    return Firestore.instance.document('users/$uid').snapshots().map((doc) {
      return User.fromDocument(doc);
    });
  }*/





}