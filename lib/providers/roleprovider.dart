import '../utilities/authservice.dart';
import 'package:flutter/material.dart';
import '../models/appuser.dart';

class RoleProvider with ChangeNotifier{

  bool uploadedImage=false;
  bool userRoleisBrand=false;
  AuthService authService=AuthService();
  AppUser currentuser=AppUser(
  brandname: 'username',
  dealsbybusiness: [],
  description: 'account description',
  outletlist: [],
  isBrand: false,
  imageUrlfromStorage: ''

  );

  void hasUploadedImage(){
    uploadedImage=true;
    notifyListeners();
  }

  void hasnotuploadedImage(){
    uploadedImage=false;
    notifyListeners();
  }

  AppUser mycurrentuser;

  RoleProvider(this.mycurrentuser);

  Future<AppUser> getUserData() async{
    print('IN GET USER DATA IN ROLEPROVIDER');
    if (currentuser.brandname=='username'){
      currentuser=await authService.getAppUserData();
      print('current user is now ');
      print(currentuser.brandname);
      
      notifyListeners();
      return currentuser;
    }
  }
  Future<AppUser> getUpdatedUserData() async{
    print('IN GET UPDATE USER DATA IN ROLEPROVIDER');
      currentuser=await authService.fetchupdateduser();
      print('current user is now ');
      print(currentuser.brandname);
      notifyListeners();
      return currentuser;

  }


  void signOut(){
    currentuser=AppUser(
      brandname: 'username',
      dealsbybusiness: [],
      description: 'account description',
      outletlist: [],
      isBrand: false,
      imageUrlfromStorage: ''

    );
    notifyListeners();
  }









}