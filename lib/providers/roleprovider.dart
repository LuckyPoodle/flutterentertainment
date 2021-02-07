import '../utilities/authservice.dart';
import 'package:flutter/material.dart';
import '../models/appuser.dart';

class RoleProvider with ChangeNotifier{


  bool userRoleisBrand=false;
  AuthService authService=AuthService();
  AppUser currentuser=AppUser(
  brandname: 'username',
  dealsbybusiness: [],
  description: 'account description',
  outletlist: [],
  isBrand: false

  );

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
  void setUserData(AppUser appuser){
    currentuser=appuser;
    print('setuserdata');
    notifyListeners();
  }

  void signOut(){
    currentuser=AppUser(
      brandname: 'username',
      dealsbybusiness: [],
      description: 'account description',
      outletlist: [],
      isBrand: false

    );
    notifyListeners();
  }









}