import 'package:amcollective/models/deal.dart';
import 'package:amcollective/utilities/authservice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/dealprovider.dart';
import 'package:provider/provider.dart';

class EditDealScreen extends StatefulWidget {

  static const routeName='/edit-deal';


  EditDealScreen();
  @override
  _EditDealScreenState createState() => _EditDealScreenState();
}

class _EditDealScreenState extends State<EditDealScreen> {

  final _locationFocusNode=FocusNode(); //so when u press the next button in keyboard for title, go to next input field
  final _descriptionFocusNode=FocusNode();
  final _imageUrlFocusNode=FocusNode();
  //you have to get rid of the focus node when the state get cleared else when u leave the screen,
  //if the focus nodes still around, it will lead to memory leak
  final AuthService auth=AuthService();
  final _imageUrlController=TextEditingController();
  //global key for form
  final _form=GlobalKey<FormState>();
  var _editedProduct=Deal(id:null,dealname:'',latitude:'',longitude:'',location:'',dealdetails: '',createdBy: '',imageUrl:'');
  var _initValues={
    'dealname':'',
    'location':'',
    'dealdetails':'',
    'createdBy':'',
    'imageUrl':'',
    'latitude':'',
    'longitude':''
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
      print('in EDIT DEAL, the user id if any is ');
      print(productId);
      if(productId!=null){
        final productwewanttoedit=Provider.of<DealProvider>(context,listen: false).findById(productId);

        _editedProduct=productwewanttoedit;
        print('is updating existing____');
        print(_editedProduct);
        _initValues={
          'dealname':_editedProduct.dealname,
          'location':_editedProduct.location,
          'dealdetails':_editedProduct.dealdetails,
          'createdBy':_editedProduct.createdBy,
          'imageUrl':_editedProduct.imageUrl,
          'latitude':_editedProduct.latitude,
          'longitude':_editedProduct.longitude
        };

        _imageUrlController.text=_editedProduct.imageUrl;

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
        auth.updateDeal(_editedProduct);
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
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      try {
        auth.addDeal(_editedProduct);
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
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
    // Navigator.of(context).pop();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        //Form manages our input values
        child: Form(
          key: _form,
          child: ListView(
              children:<Widget>[
                TextFormField(

                  initialValue: _initValues['dealname'],

                  decoration:InputDecoration(labelText:'Deal Name'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (valueinputtofield){
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);

                  },
                  onSaved: (value){
                    _editedProduct=Deal(dealname:value,
                        dealdetails:_editedProduct.dealdetails,
                        location: _editedProduct.location,
                        id:_editedProduct.id,
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
                  decoration:InputDecoration(labelText:'Description'),
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onFieldSubmitted: (valueinputtofield){
                    FocusScope.of(context).requestFocus(_locationFocusNode);

                  },
                  onSaved: (value){
                    _editedProduct=Deal(id:_editedProduct.id,dealname:_editedProduct.dealname,dealdetails: value,location:_editedProduct.location,imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (value){
                    //null is returned when input is correct, return a text when its wrong
                    if(value.isEmpty){
                      return 'Please provide a value';
                    }
                    if(value.length<10){
                      return 'Please write at least 10 characters for description';
                    }
                    return null;
                  },


                ),
                TextFormField(
                  initialValue: _initValues['location'],
                  decoration:InputDecoration(labelText:'Location of Deal'),
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  focusNode: _locationFocusNode,
                  onSaved: (value){
                    _editedProduct=Deal(id:_editedProduct.id,dealname:_editedProduct.dealname,dealdetails: _editedProduct.dealdetails,location:value,imageUrl: _editedProduct.imageUrl);
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
                  decoration:InputDecoration(labelText:'Location Latitude'),
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,

                  onSaved: (value){
                    _editedProduct=Deal(latitude:value,id:_editedProduct.id,dealname:_editedProduct.dealname,dealdetails: _editedProduct.dealdetails,location:_editedProduct.location,imageUrl: _editedProduct.imageUrl);
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
                  decoration:InputDecoration(labelText:'Location Longitude'),
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,

                  onSaved: (value){
                    _editedProduct=Deal(longitude:value,latitude:_editedProduct.latitude,id:_editedProduct.id,dealname:_editedProduct.dealname,dealdetails: _editedProduct.dealdetails,location:_editedProduct.location,imageUrl: _editedProduct.imageUrl);
                  },
                  validator: (value){
                    //null is returned when input is correct, return a text when its wrong
                    if(value.isEmpty){
                      return 'Please provide a value';
                    }

                    return null;
                  },


                ),
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

                          _editedProduct=Deal(id:_editedProduct.id,dealname:_editedProduct.dealname,dealdetails: _editedProduct.dealdetails,location:_editedProduct.location,imageUrl: value);
                        },

                      ),
                    ),

                  ],)
              ]),
        ),
      ) ,
    );
  }
}