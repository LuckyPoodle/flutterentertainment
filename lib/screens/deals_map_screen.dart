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
  final Map<String, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller)  {

    final mydeals =Provider.of<DealProvider>(context,listen: false).dealsinprovider;
    setState(() {
      _markers.clear();
      for (final deal in mydeals) {
        final marker = Marker(
          
          markerId: MarkerId(deal.dealname),
          position: LatLng(double.parse(deal.latitude),double.parse(deal.longitude)),
          infoWindow: InfoWindow(
            
            title: deal.dealname,
            snippet: deal.dealdetails,
          ),
        );
        print('the parsed latitude --------------------');
        print(double.parse(deal.latitude));
        print('the parsed longitude --------------------');
        print(double.parse(deal.longitude));
        _markers[deal.dealname] = marker;
        print('the markers --------------------');
        print(_markers);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed:(){

          Navigator.pop(context);
}),
          title: const Text('Deals Locations', style:TextStyle(color: Colors.white) ,),
          backgroundColor: Colors.black,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(1.364917, 103.822872),
            zoom: 10,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}