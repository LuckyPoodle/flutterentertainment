import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/dealprovider.dart';
import '../providers/roleprovider.dart';
import 'package:provider/provider.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn,this.urlifany,this.inProfile);
  String urlifany='';
  bool inProfile=false;
  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  


  void _pickImage() async {
    if (widget.inProfile==false){
      Provider.of<DealProvider>(context,listen:false).dealaddimage();
    }else{
      Provider.of<RoleProvider>(context,listen: false).hasUploadedImage();
    }
    final pickedImageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    print('hi i am imagepicker widget and my imageurlifany is');
    print(widget.urlifany);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

//Image.file(File(_pickingType.path))
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
                      child:widget.urlifany==null? Text('Upload your image'):widget.urlifany.isEmpty&&_pickedImage == null?Text('Upload your image'):
                       widget.urlifany.isNotEmpty&&_pickedImage==null?Image(
             fit: BoxFit.contain,image: NetworkImage(widget.urlifany)):Image(
             fit: BoxFit.contain,
  image:  FileImage(_pickedImage),
)
                    

                    ),

SizedBox(width: 1,),
         
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          color: Colors.black,
          icon: Icon(Icons.image,color: Colors.white,),
          label: Text('Upload Image',style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
