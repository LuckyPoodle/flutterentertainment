import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../providers/dealprovider.dart';
import 'package:provider/provider.dart';
import '../screens/deals.dart';
class DealsMapScreen extends StatefulWidget {

   static const routeName='/deals-map';

  @override
  _DealsMapScreenState createState() => _DealsMapScreenState();
}

class _DealsMapScreenState extends State<DealsMapScreen> {
  final Scaffold scaffold= Scaffold();

  final Map<String, Marker> _markers = {};
  void displayBottomSheet(BuildContext context,String title,String desc,String imageUrl,String imageUrlfromStorage) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height  * 0.4,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
                  Text(desc,style: TextStyle(fontSize: 25),),
                  Image(
                    height:MediaQuery.of(context).size.height  * 0.2,
                    width:MediaQuery.of(context).size.width *.8 ,
                    fit: BoxFit.contain,
                    image: NetworkImage(imageUrl.isNotEmpty?imageUrl:imageUrlfromStorage.isNotEmpty?imageUrlfromStorage:''),
                  )
                ],
              ),
            )
          );
        });
  }

  void _onMapCreated(GoogleMapController controller)  {

    final mydeals =Provider.of<DealProvider>(context,listen: false).dealsinprovider;
    setState(() {
      _markers.clear();
      for (final deal in mydeals) {
        final marker = Marker(
          markerId: MarkerId(deal.dealname),
          onTap: (){
//            setState(() {
//              viewVisible = true ;
//            });
            displayBottomSheet(context, deal.dealname, deal.dealdetails,deal.imageUrl,deal.imageUrlfromStorage);


//            showModalBottomSheet<void>(
//              context: context,
//
//              builder: (BuildContext context) {
//                return Container(
//                  height: 100,
//                  color: Colors.amber,
//                  child: Center(
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        const Text('Modal BottomSheet'),
//                        ElevatedButton(
//                          child: const Text('Close BottomSheet'),
//                          onPressed: () => Navigator.pop(context),
//                        )
//                      ],
//                    ),
//                  ),
//                );
//              },
//            );

          },



          position: LatLng(double.parse(deal.latitude),double.parse(deal.longitude)),
          infoWindow: InfoWindow(
            title: deal.dealname,

          ),
        );

        _markers[deal.dealname] = marker;
        print('the markers --------------------');
        print(_markers);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed:(){

          Navigator.pop(context);
}),
          title: const Text('Deals Locations', style:TextStyle(color: Colors.white) ,),
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(1.364917, 103.822872),
                zoom: 10,
              ),
              markers: _markers.values.toSet(),

            ),
//            Visibility(
//                maintainSize: true,
//                maintainAnimation: true,
//                maintainState: true,
//                visible: viewVisible,
//
//                child: Container(
//                    height: 200,
//                    width: 200,
//                    color: Colors.green,
//
//
//                    margin: EdgeInsets.only(top: 50, bottom: 30),
//                    child: Column(
//                      children: <Widget>[
//                        IconButton(
//                          icon: Icon(Icons.icecream),
//                          onPressed:(){
//                            setState(() {
//                              viewVisible = false ;
//                            });
//                          },
//                        ),
//                        Center(child: Text(title,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(color: Colors.white,
//                                fontSize: 23))),
//                        Center(child: Text(desc,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(color: Colors.white,
//                                fontSize: 23)))
//                      ],
//                    )
//                )
//            ),


          ],
        ),
      ),
    );
  }
}