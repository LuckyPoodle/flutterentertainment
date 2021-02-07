import 'package:amcollective/models/address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/roleprovider.dart';
import '../models/appuser.dart';
import '../utilities/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/bottomtab.dart';
class EditProfileScreen extends StatefulWidget {
  static const routeName='/edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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

        _editedProduct=thisappuser;
        print('is updating existing____');
        print(_editedProduct.outletlist);
        print(_editedProduct.brandname);
        _initValues={
          'brandname':_editedProduct.brandname,
          'description':_editedProduct.description,
          'outletlist':_editedProduct.outletlist,
          'profileimg':_editedProduct.profileimg,
          'dealsbybusiness':_editedProduct.dealsbybusiness,
          'isBrand':_editedProduct.isBrand,

        };
        print('___________________in didchangedependency of editprofile______________________');
        print(_initValues['outletlist']);
        print(_initValues['outletlist'][0]);

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


    _formKey.currentState.save();
      try {
        print('save form !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        _editedProduct.outletlist=formoutletlist;

        print('save form gg to !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        print(_editedProduct.outletlist[0].address);
        print(_editedProduct.id);
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
        Provider.of<RoleProvider>(context,listen: false).getUpdatedUserData();
        Navigator.of(context).pop();
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
        child: Form(
            key: _formKey,
            child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      //a container to show image preview
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(top:8,right:10,),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width:1,
                              color:Colors.grey,
                            )
                        ),
                        child: _imageUrlController.text.isEmpty?Text('Enter your image url'):
                        FittedBox(child:Image.network(_imageUrlController.text, fit:BoxFit.cover,)),

                      ),
                      Expanded(
                        child: TextFormField(

                          decoration: InputDecoration(labelText:'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onEditingComplete: (){
                            setState(() {
                              //this forces a state change (i.e screen update even though we didnt pass any data to setState)
                              //so that the changed data in textcontroller is bound to the image input being used
                            });
                          },
                          validator: (value){
                            //null is returned when input is correct, return a text when its wrong
                            if(value.isEmpty){
                              return 'Please provide an image';
                            }
                            if (!value.startsWith('http') && !value.startsWith('https')){
                              return 'Please enter a valid URL';
                            }
                            if (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){
                              return 'Please submit a jpg/jpeg/png image';
                            }
                            return null;
                          },

                          onSaved: (value){

                            _editedProduct=AppUser(
                                description:_editedProduct.description,
                                outletlist: _editedProduct.outletlist,
                                id:_editedProduct.id,
                                dealsbybusiness: _editedProduct.dealsbybusiness,
                                isBrand: _editedProduct.isBrand,
                                profileimg: value);
                          },

                        ),
                      ),

                    ],),
                  // Add TextFormFields and ElevatedButton here.
                  TextFormField(
                    initialValue: _initValues['brandname'],
                    decoration:InputDecoration(labelText:'Your Display Name'),

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
                    decoration:InputDecoration(labelText:'Description'),
                    keyboardType: TextInputType.multiline,

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

                      if (value.length>300){
                        return 'Please write less than 300 characters';
                      }
                      return null;
                    },

                  ),


                  TextFormField(
                    initialValue: _editedProduct.outletlist.length.toString(),
                    decoration:InputDecoration(labelText:'Number of Physical Location'),

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

                          decoration:InputDecoration(labelText:'Address'),
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