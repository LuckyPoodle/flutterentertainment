import 'dart:io';

import 'package:amcollective/models/ScreenArguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../providers/selected_category.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/style.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/article_model.dart';

class PostDetail extends StatefulWidget {
  static const routeName='/product-detail';

  const PostDetail({ Key key }) : super(key: key);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {

  var productId;
  bool webview=false;
  Article loadedProduct;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

  }

  @override
  Widget build(BuildContext context) {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    loadedProduct=Provider.of<SelectedCategory>(context,listen:false).findById(args.origin,args.id);
    webview=loadedProduct.blogname=='RiceMedia';
    return
      webview?
          Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: true,
                title:Text(loadedProduct.blogname)
            ),
            body:  WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: loadedProduct.articleUrl,
            ) ,

          )

      :SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title:Text(loadedProduct.blogname)
        ),
        body: LayoutBuilder(
          builder: (context, _) => Stack(
            children: <Widget>[
              Positioned.fill(
                bottom: MediaQuery.of(context).size.height * .55,
                child: Image.network(
                  "${loadedProduct.urlToImage}",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),

                  ],
                ),
              ),
              Positioned.fill(
                child: DraggableScrollableSheet(
                  initialChildSize: .65,
                  minChildSize: .65,
                  builder: (context, controller) => Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                    ),
                    child: ListView(
                      controller: controller,
                      children: <Widget>[

                        SizedBox(height: 9),
                        Html(
                          data: "${loadedProduct.content}",
                          style: {
                            "html": Style(


                            ),
                            "h2": Style(
                                fontSize: FontSize(40.0)
                            ),
                            "span":Style(
                                fontSize: FontSize(25.0)
                            ),
                            "p":Style(
                                fontSize: FontSize(20.0)
                            ),
                            "table": Style(
                              backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                            ),
                            "tr": Style(
                              border: Border(bottom: BorderSide(color: Colors.grey)),
                            ),
                            "th": Style(
                              padding: EdgeInsets.all(6),
                              backgroundColor: Colors.grey,
                            ),
                            "td": Style(
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.topLeft,
                            ),
                            "var": Style(fontFamily: 'serif'),
                          },



                          onLinkTap: (url) async {
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



/*class PostDetail extends StatelessWidget {

  //for when navigating on the fly
  // final String title;
  // ProductDetailScreen(this.title);

  static const routeName='/product-detail';


  @override
  Widget build(BuildContext context) {
    //extract id
    final productId=ModalRoute.of(context).settings.arguments as String;

    // ... want to get all product data using the id, we NEED A CENTRE STATE MANAGEMENT
    //we have provider access

    bool webview=Provider.of<SelectedCategory>(context,listen:false).category=='RiceMedia';
    final loadedProduct=Provider.of<SelectedCategory>(context,listen:false).findById(productId);


    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, _) => Stack(
            children: <Widget>[
              Positioned.fill(
                bottom: MediaQuery.of(context).size.height * .55,
                child: Image.network(
                  "${loadedProduct.urlToImage}",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),

                  ],
                ),
              ),
              Positioned.fill(
                child: DraggableScrollableSheet(
                  initialChildSize: .65,
                  minChildSize: .65,
                  builder: (context, controller) => Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                    ),
                    child: ListView(
                      controller: controller,
                      children: <Widget>[

                        SizedBox(height: 9),
                        Html(
                          data: "${loadedProduct.content}",
                            style: {
                              "html": Style(


                              ),
                              "h2": Style(
                                fontSize: FontSize(40.0)
                              ),
                              "span":Style(
                                  fontSize: FontSize(25.0)
                              ),
                              "p":Style(
                                fontSize: FontSize(20.0)
                              ),
                              "table": Style(
                                backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                              ),
                              "tr": Style(
                                border: Border(bottom: BorderSide(color: Colors.grey)),
                              ),
                              "th": Style(
                                padding: EdgeInsets.all(6),
                                backgroundColor: Colors.grey,
                              ),
                              "td": Style(
                                padding: EdgeInsets.all(6),
                                alignment: Alignment.topLeft,
                              ),
                              "var": Style(fontFamily: 'serif'),
                            },



                          onLinkTap: (url) async {
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}*/










//return Scaffold(
//appBar: AppBar(
//title: Text(loadedProduct.title),
//
//),
//body: SingleChildScrollView(
//child: Column(
//children: <Widget>[
//SizedBox(height: 10,),
//Container(
//padding: EdgeInsets.symmetric(horizontal:10),
//height: 300,
//width: double.infinity,
//child:Image.network(loadedProduct.urlToImage,fit: BoxFit.cover,), ),
//SizedBox(height:10),
//
//SizedBox(height:10),
//Html(
//data: "${loadedProduct.content}",
//
//),
//]
//),
//),
//
//
//);