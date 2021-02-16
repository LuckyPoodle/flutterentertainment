import 'package:amcollective/models/address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/roleprovider.dart';
import '../models/appuser.dart';
import '../utilities/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/bottomtab.dart';
import 'dart:io';
import '../widgets/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
class EditProfileScreen extends StatefulWidget {
  static const routeName='/edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

File _userImageFile;




 void _pickedImage(File image) {
    
    _userImageFile = image;

  }



  final _formKey = GlobalKey<FormState>();
  var numofoutlets=1;
  final _imageUrlFocusNode=FocusNode();
  final _imageUrlController=TextEditingController();
  var _isInit = true;
  AppUser thisappuser;
  var _editedProduct=AppUser();

  var _initValues={

  };
  List<PlaceLocation> formoutletlist=[];
  final AuthService auth=AuthService();
  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //this is run when build is executed. we use isinit condition cos we only want to run once
    if (_isInit){
      //ModalRoute which we use to get the setting and argument does not work in initState
      thisappuser=ModalRoute.of(context).settings.arguments as AppUser;
      Provider.of<RoleProvider>(context,listen: false).hasnotuploadedImage();

        _editedProduct=thisappuser;

        _initValues={
          'brandname':_editedProduct.brandname,
          'description':_editedProduct.description,
          'outletlist':_editedProduct.outletlist,
          'profileimg':_editedProduct.profileimg,
          'dealsbybusiness':_editedProduct.dealsbybusiness,
          'isBrand':_editedProduct.isBrand,
          'imageUrlfromStorage':_editedProduct.imageUrlfromStorage
          

        };
        print('___________________in didchangedependency of editprofile______________________');

 

        numofoutlets=_editedProduct.outletlist.length;

        _imageUrlController.text=_editedProduct.profileimg;

    }


    _isInit=false;
    super.didChangeDependencies();
  }

  void _updateImageUrl(){

    if (!_imageUrlFocusNode.hasFocus){
      //if not in focus anymore, update ui with latest state
      setState(() {

      });
    }

  }

  @override
  void dispose() {

    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    // TODO: implement dispose
    super.dispose();

  }

  Future<void> _saveForm() async {

    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
        if (Provider.of<RoleProvider>(context,listen: false).uploadedImage==true){
             final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(_editedProduct.id);

        //await ref.putFile(image).onComplete;
        UploadTask uploadTask=ref.putFile(_userImageFile);
        uploadTask.whenComplete(() async{
        final url = await ref.getDownloadURL();
        print('in EDIT PROFILE image uploading area');
        print(url.toString());
try{
          _editedProduct.imageUrlfromStorage=url.toString();
        _editedProduct.profileimg=url.toString();
       _editedProduct.outletlist=formoutletlist;
     
        auth.updateUser(_editedProduct);
}catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        Provider.of<RoleProvider>(context,listen: false).hasnotuploadedImage();
        Provider.of<RoleProvider>(context,listen: false).getUpdatedUserData();
        //Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TabsScreen(
                3
            ),
          ),
        );
      }
        });
        }else{
  try {
        print('save form no image change');
        _editedProduct.outletlist=formoutletlist;
     
        auth.updateUser(_editedProduct);

      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        Provider.of<RoleProvider>(context,listen: false).hasnotuploadedImage();
        Provider.of<RoleProvider>(context,listen: false).getUpdatedUserData();
        //Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TabsScreen(
                3
            ),
          ),
        );
      }
        }

    

    // Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Edit Profile Details'),
        automaticallyImplyLeading: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,)
        ],),
      body:SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
            key: _formKey,
            child: Column(
                children: <Widget>[
                    UserImagePicker(_pickedImage,_editedProduct.imageUrlfromStorage,true),

                  TextFormField(
                    initialValue: _initValues['brandname'],
                    decoration:InputDecoration(labelText:'Your Display Name',hintText: 'Display Name'),

                    onSaved: (value){
                      _editedProduct=AppUser(brandname:value,
                          description:_editedProduct.description,
                          outletlist: _editedProduct.outletlist,
                          id:_editedProduct.id,
                          dealsbybusiness: _editedProduct.dealsbybusiness,
                          isBrand: _editedProduct.isBrand,
                          profileimg: _editedProduct.profileimg);
                    },
                    validator: (value){
                      //null is returned when input is correct, return a text when its wrong
                      if(value.isEmpty){
                        return 'Please provide a value';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    decoration:InputDecoration(labelText:'Description',hintText: 'Description'),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    onSaved: (value){
                      _editedProduct=AppUser(brandname:_editedProduct.brandname,
                          description:value,
                          outletlist: _editedProduct.outletlist,
                          id:_editedProduct.id,
                          dealsbybusiness: _editedProduct.dealsbybusiness,
                          isBrand: _editedProduct.isBrand,
                          profileimg: _editedProduct.profileimg);
                    },
                    validator: (value){
                      //null is returned when input is correct, return a text when its wrong
                      if(value.isEmpty){
                        return 'Please provide a value';
                      }

                      if (value.length>100){
                        return 'Please write less than 100 characters';
                      }
                      return null;
                    },

                  ),


                  TextFormField(
                    initialValue: _editedProduct.outletlist.length.toString(),
                    
                    decoration:InputDecoration(labelText:'Number of Physical Location',hintText: 'Number of Physical Location'),

                    keyboardType: TextInputType.number,

                    onFieldSubmitted: (valueinputtofield){
                      setState(() {
                        numofoutlets=int.parse(valueinputtofield);
                      });

                    },

                    validator: (value){
                      //null is returned when input is correct, return a text when its wrong
                      if(value.isEmpty){
                        return 'Please provide a value';
                      }

                      return null;
                    },


                  ),

                  for (var i=0;i<numofoutlets;i++)
                    (

                        TextFormField(

                          decoration:InputDecoration(labelText:'Address',hintText: 'Address'),
                          initialValue: thisappuser.outletlist.length<=i?'':thisappuser.outletlist[i].address,
                          keyboardType: TextInputType.multiline,
                          onFieldSubmitted: (valueinputtofield){


                          },
                          onSaved: (value){
                            PlaceLocation pl = PlaceLocation(address: value);
                            formoutletlist.add(pl);
                          },
                        )),





                ]
            )
        ),
      )
    );
  }
}