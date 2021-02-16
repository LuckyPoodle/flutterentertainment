
import 'package:amcollective/models/deal.dart';
import 'package:amcollective/utilities/authservice.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/image_picker.dart';
import '../providers/roleprovider.dart';
import '../providers/dealprovider.dart';
import 'package:provider/provider.dart';
import '../widgets/bottomtab.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditDealScreen extends StatefulWidget {

  static const routeName='/edit-deal';


  EditDealScreen();
  @override
  _EditDealScreenState createState() => _EditDealScreenState();
}

class _EditDealScreenState extends State<EditDealScreen> {
  File _userImageFile;

 
String dropdownValue = 'North';


 void _pickedImage(File image) {
    
    _userImageFile = image;

  }


  final _locationFocusNode=FocusNode(); //so when u press the next button in keyboard for title, go to next input field
  final _descriptionFocusNode=FocusNode();
  final _imageUrlFocusNode=FocusNode();
  //you have to get rid of the focus node when the state get cleared else when u leave the screen,
  //if the focus nodes still around, it will lead to memory leak
  final AuthService auth=AuthService();
  final _imageUrlController=TextEditingController();
  //global key for form
  final _form=GlobalKey<FormState>();
  var _editedProduct=Deal(id:null,dealname:'', imageUrlfromStorage:'',imagefile:null,region:'',latitude:'',longitude:'',location:'',dealdetails: '',createdBy: '',imageUrl:'');
  var _initValues={

    'dealname':'',
    'location':'',
    'dealdetails':'',
    'createdBy':'',
    'imageUrl':'',
    'latitude':'',
    'longitude':'',
    'region':'',
     'imageUrlfromStorage':''
   
  };
  var _isInit = true;
  var _isLoading=false;

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
      final productId=ModalRoute.of(context).settings.arguments as String;

      print(productId);
      if(productId!=null){
        final productwewanttoedit=Provider.of<DealProvider>(context,listen: false).findById(productId);
        dropdownValue=productwewanttoedit.region;


        _editedProduct=productwewanttoedit;
  
        print(_editedProduct);
        _initValues={
          'dealname':_editedProduct.dealname,
          'location':_editedProduct.location,
          'dealdetails':_editedProduct.dealdetails,
          'createdBy':_editedProduct.createdBy,
          'imageUrl':_editedProduct.imageUrl,
          'latitude':_editedProduct.latitude,
          'longitude':_editedProduct.longitude,
          'region':_editedProduct.region,
          'imageUrlfromStorage':_editedProduct.imageUrlfromStorage
         
        };
        

        _imageUrlController.text=_editedProduct.imageUrl;
       
        if (_editedProduct.imageUrlfromStorage.isNotEmpty || _editedProduct.imageUrl.isNotEmpty){
          Provider.of<DealProvider>(context,listen: false).dealalreadyhasimage();
          print('in changedependency, updating product and this deal already has image ');
          print( Provider.of<DealProvider>(context,listen: false).thisdealalreadyhasimage);
        }

      }

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
    _locationFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    // TODO: implement dispose
    super.dispose();

  }


  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {

      try {

        String brandname=Provider.of<RoleProvider>(context,listen: false).currentuser.brandname;
        print('CURRENT USER IS');
        print(brandname);

        _editedProduct.brandname=brandname;
        _editedProduct.region=dropdownValue;
        _editedProduct.imagefile=_userImageFile;
        bool useralreadyhasimage=Provider.of<DealProvider>(context,listen: false).thisdealalreadyhasimage;
                print('useralreadyhasimage?');
                print(useralreadyhasimage);
        if (!useralreadyhasimage){
          print('gg to upload an image');
          if (_userImageFile!=null){
            final ref = FirebaseStorage.instance
            .ref()
            .child('deal_image')
            .child('deal'+_editedProduct.dealname);

        //await ref.putFile(image).onComplete;
        UploadTask uploadTask=ref.putFile(_userImageFile);
        uploadTask.whenComplete(() async{
        final url = await ref.getDownloadURL();
        print('in EDIT DEAL UPDATE image uploading area');
        print(url.toString());
        _editedProduct.imageUrlfromStorage=url.toString();
       
        auth.updateDeal(_editedProduct);
        });
          
        }
        }else{
          
          auth.updateDeal(_editedProduct);
        }
       
      } catch (error) {
        print('CANNOT SAVE');
        print(error);
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
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      try {
        _editedProduct.region=dropdownValue;
        _editedProduct.imagefile=_userImageFile;
        String brandname=Provider.of<RoleProvider>(context,listen: false).currentuser.brandname;

        _editedProduct.brandname=brandname;
        bool useralreadyhasimage=Provider.of<DealProvider>(context,listen: false).thisdealalreadyhasimage;
                print('useralreadyhasimage?');
                print(useralreadyhasimage);
        if (!useralreadyhasimage) {
          if (_editedProduct.imageUrl.isEmpty && _userImageFile!=null) {
           final ref = FirebaseStorage.instance
            .ref()
            .child('deal_image')
           .child('deal'+_editedProduct.dealname);


        
        UploadTask uploadTask=ref.putFile(_userImageFile);
        uploadTask.whenComplete(() async{
        final url = await ref.getDownloadURL();
        print('in EDIT DEAL image uploading area');
        print(url.toString());
        _editedProduct.imageUrlfromStorage=url.toString();
  
        print('....');
        print(_editedProduct.imageUrlfromStorage);
       auth.addDeal(_editedProduct);
        });
      
      }}else{
         auth.addDeal(_editedProduct);
      }
      
      
      
      }
        
      
       catch (error) {
        print('error...');
        print(error);
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
        
        setState(() {
          _isLoading = false;
        });
       
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TabsScreen(
                      3
                  ),
            ),
          );;
      }
    }
    
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TabsScreen(
                      3
                  ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Deal Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,)
        ],),
      body: SingleChildScrollView(
        
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        //Form manages our input values
        child: Form(
          key: _form,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
              children:<Widget>[
                TextFormField(

                  initialValue: _initValues['dealname'],

                  decoration:InputDecoration(labelText:'Deal Name',hintText: 'Deal Name'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (valueinputtofield){
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);

                  },
                  onSaved: (value){
                    _editedProduct=Deal(dealname:value,
                        dealdetails:_editedProduct.dealdetails,
                        location: _editedProduct.location,
                        id:_editedProduct.id,
                        latitude: _editedProduct.latitude,
                        longitude: _editedProduct.longitude,
                        imageUrl: _editedProduct.imageUrl);
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
                  initialValue: _initValues['dealdetails'],
                  decoration:InputDecoration(labelText:'Description',hintText: 'Description'),
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onFieldSubmitted: (valueinputtofield){
                    FocusScope.of(context).requestFocus(_locationFocusNode);

                  },
                  onSaved: (value){
                    _editedProduct=Deal(region:_editedProduct.region,id:_editedProduct.id,dealname:_editedProduct.dealname,  latitude: _editedProduct.latitude,
                        longitude: _editedProduct.longitude,dealdetails: value,location:_editedProduct.location,imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (value){
                    //null is returned when input is correct, return a text when its wrong
                    if(value.isEmpty){
                      return 'Please provide a value';
                    }
                    if(value.length<10){
                      return 'Please write at least 10 characters for description';
                    }
                    if (value.length>300){
                      return 'Please write less than 300 characters';
                    }
                    return null;
                  },


                ),
                TextFormField(
                  initialValue: _initValues['location'],
                  decoration:InputDecoration(labelText:'Location of Deal',hintText: 'Location of Deal'),
            
                  textInputAction: TextInputAction.next,
               
                  focusNode: _locationFocusNode,
                  onSaved: (value){
                    _editedProduct=Deal(region:_editedProduct.region,id:_editedProduct.id,dealname:_editedProduct.dealname,dealdetails: _editedProduct.dealdetails,location:value,imageUrl: _editedProduct.imageUrl , latitude: _editedProduct.latitude,
                        longitude: _editedProduct.longitude,);
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
                  initialValue: _initValues['latitude'],
                  decoration:InputDecoration(labelText:'Location Latitude',hintText: 'Location Latitude'),
                 
                  textInputAction: TextInputAction.next,
                 

                  onSaved: (value){
                    _editedProduct=Deal(region:_editedProduct.region,latitude:value,id:_editedProduct.id,dealname:_editedProduct.dealname,dealdetails: _editedProduct.dealdetails,location:_editedProduct.location,imageUrl: _editedProduct.imageUrl,longitude: _editedProduct.longitude);
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
                  initialValue: _initValues['longitude'],
                  decoration:InputDecoration(labelText:'Location Longitude',hintText: 'Location Longitude'),
                 
                  textInputAction: TextInputAction.next,
                

                  onSaved: (value){
                    _editedProduct=Deal(region:_editedProduct.region,longitude:value,latitude:_editedProduct.latitude,id:_editedProduct.id,dealname:_editedProduct.dealname,dealdetails: _editedProduct.dealdetails,location:_editedProduct.location,imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (value){
                    //null is returned when input is correct, return a text when its wrong
                    if(value.isEmpty){
                      return 'Please provide a value';
                    }
                    return null;
                  },
                ),
                   SizedBox(height: 10,),
                Text('Deal region'),
            DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['North', 'South', 'West', 'East','Central']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20,),
          Text('Upload image by pasting in your image URL OR uploading it via your phone gallery'),
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

                        decoration: InputDecoration(labelText:'Image URL',hintText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onEditingComplete: () async{
                          Provider.of<DealProvider>(context,listen: false).dealalreadyhasimage();
                          setState(() {
                            //this forces a state change (i.e screen update even though we didnt pass any data to setState)
                            //so that the changed data in textcontroller is bound to the image input being used
                          });
                          if (_editedProduct.imageUrlfromStorage!=null){
                            if (_editedProduct.imageUrlfromStorage.isNotEmpty) {
                              try {
                                        var linktodelete=FirebaseStorage.instance.refFromURL(_editedProduct.imageUrlfromStorage);
                                        print(linktodelete.fullPath);
                                        //linktodelete.delete();
                                        //print(linktodelete.toString());
                                        FirebaseStorage.instance.ref(linktodelete.fullPath.toString()).delete();

                                        print('deleted image file from storage :)');
                                        return true;
                                      } catch (e) {
                                        print('hmm not deleted');
                                        print(e.toString());
                                        return e.toString();
                                      }
                            }

                          }
                      
                          _editedProduct.imageUrlfromStorage='';
                          
                        },
                      
                        onSaved: (value){

                          _editedProduct=Deal(region:_editedProduct.region,id:_editedProduct.id,dealname:_editedProduct.dealname, imageUrlfromStorage:  _editedProduct.imageUrlfromStorage, latitude: _editedProduct.latitude,
                        longitude: _editedProduct.longitude,dealdetails: _editedProduct.dealdetails,location:_editedProduct.location,imageUrl: value);
                        },

                      ), 
                    ),
                    

                  ],),
                  Text('OR via your phone gallery'),
                   UserImagePicker(_pickedImage,_editedProduct.imageUrlfromStorage,false),
                     SizedBox(height: 50,)
              ]),
        ),
      ) ,
      ),
    );
  }
}