
import 'package:cloud_firestore/cloud_firestore.dart';
class Deal{

  String dealname;
  String location;
  String latitude;
  String longitude;
  String imageUrl;
  String dealdetails;
  String id;
  String createdBy;
  String region;


  Deal({this.id,this.dealname,this.longitude,this.latitude,this.location,this.dealdetails,this.createdBy,this.region,this.imageUrl});

  factory Deal.fromDocument(QueryDocumentSnapshot data) {
    return Deal(
      dealname: data.data()['dealname'],
      location: data.data()['location'],
      createdBy: data.data()['userId'],
      dealdetails: data.data()['dealdetails'],
        imageUrl: data.data()['imageUrl'],
      longitude: data.data()['longitude'],
      latitude: data.data()['latitude'],
      region: data.data()['region'],
      id: data.id,
    );
  }

}