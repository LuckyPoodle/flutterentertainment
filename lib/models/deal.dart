import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
class Deal{

  String dealname;
  String location;
  String latitude;
  String longitude;
  String imageUrl;
  String imageUrlfromStorage;
  File imagefile;
  String dealdetails;
  String id;
  String createdBy;
  String region;


  Deal({this.id,this.dealname,this.longitude,this.latitude,this.imageUrlfromStorage,this.location,this.dealdetails,this.createdBy,this.region,this.imagefile,this.imageUrl});

  factory Deal.fromDocument(QueryDocumentSnapshot data) {
    return Deal(
      dealname: data.data()['dealname'],
      location: data.data()['location'],
      createdBy: data.data()['userId'],
      dealdetails: data.data()['dealdetails'],
        imageUrl: data.data()['imageUrl'],
        imageUrlfromStorage: data.data()['imageUrlfromStorage'],
      longitude: data.data()['longitude'],
      latitude: data.data()['latitude'],
      region: data.data()['region'],
      imagefile: data.data()['imagefile'],
      
      id: data.id,
    );
  }

}