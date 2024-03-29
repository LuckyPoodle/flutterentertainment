import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' show parse;

import 'dart:convert';
import '../models/article_model.dart';




class TimeAgo{
  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime notificationDate = DateFormat("yyyy-MM-dd'T'HH:mm").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

}
class NetworkHelper {

  List<Article> listofarticlescurrent  = [];

  NetworkHelper(this.url);

  final String url;

  String parseHtml(String html){
    var document=parse(html);
    return parse(document.body.text).documentElement.text;

  }

  String extractFirstUrl(String str){
    int start=str.indexOf('src');
    print(start);
    String url='';

    if (start>0){
      for (int i=start+5;i<str.length;i++){
        if (str[i]!='"'){
          url+=str[i];
        }else{
          print('extracted');
          print(url);
          return url;

        }

      }
    }else{
      return url;
    }
  }


  Future<void> getData(String blogname) async {
    //print('fetching data');
    //print(url);
    Response response = await get(url,headers: {"Accept":"application/json"});
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);

      for (int i=0;i<decodedData.length;i++){

        //DateTime dt=DateTime.parse(decodedData[i]['modified']);
        String date=TimeAgo.timeAgoSinceDate(decodedData[i]['modified']);
        DateTime dateforcomparison=DateTime.parse(decodedData[i]['modified']);

        String titlee=parseHtml(decodedData[i]['title']['rendered']);
        String shortdescc=parseHtml(decodedData[i]['excerpt']['rendered']);
        //String contentt=parseHtml(decodedData[i]['content']['rendered']);
        String id=decodedData[i]['id'].toString();
        //print("FETCHING!!!!! , imgrul ");
        //print(decodedData[i]['jetpack_featured_media_url']);
        String urlimage='';
        if (decodedData[i]['jetpack_featured_media_url']==null){
          if (decodedData[i]['_embedded']['wp:featuredmedia']==null){
            urlimage=extractFirstUrl(decodedData[i]['content']['rendered']);

          }else{
            urlimage=decodedData[i]['_embedded']['wp:featuredmedia'][0]['source_url'];
          }
        }else{
          urlimage=decodedData[i]['jetpack_featured_media_url'];
        }
        blogname=decodedData[i]['_embedded']['author']==null?'AMCollective':decodedData[i]['_embedded']['author'][0]['name'];


        Article article=Article(
          id:id,
          dateforcomparison: dateforcomparison,
          title:titlee,
          urlToImage:urlimage,
          content: decodedData[i]['content']['rendered'],
          shortdesc:shortdescc,
          articleUrl: decodedData[i]['link'],
          author: decodedData[i]['author'],
            publishedAt: date,
            modifiedby: decodedData[i]['modified_by'],
          blogname: blogname

        );
        listofarticlescurrent.add(article);
      }


    } else {
      print(response.statusCode);

    }
  }

}