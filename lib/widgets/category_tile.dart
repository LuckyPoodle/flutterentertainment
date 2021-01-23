import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/selected_category.dart';


class CategoryCard extends StatelessWidget {
  final String imageAssetUrl, categoryName;

  CategoryCard({this.imageAssetUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    var currentcategory=Provider.of<SelectedCategory>(context).category;
    return Container(
        width: MediaQuery.of(context).size.width / 2,
        margin: EdgeInsets.only(right: 5),
        child: Stack(
          children: <Widget>[


            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: categoryName==currentcategory?Colors.blueGrey:Colors.black26
              ),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      );



  }
}
