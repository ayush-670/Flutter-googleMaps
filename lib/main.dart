import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google map Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Google map Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String api = 'AIzaSyA72jcZBMDaCgAH5sNNXABRpIYDtupnDo0';
  double _originLatitude = 22.541090;
  double _originLongitude = 88.369957;
  double _destLatitude = 22.471787;
  double _destLongitude = 88.356525;
  List<Marker> _markers = [];
  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              _controller.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(_originLatitude, _originLongitude),
                ),
              );
              setState(() {
                _markers.add(
                  Marker(
                    markerId: MarkerId(
                      "Office",
                    ),
                    position: LatLng(_originLatitude, _originLongitude)
                  ),
                );
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              _controller.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(_destLatitude, _destLongitude),
                ),
              );
              setState(() {
                _markers.add(
                  Marker(
                    markerId: MarkerId(
                      "Office",
                    ),
                    position: LatLng(_destLatitude, _destLongitude)
                  ),
                );
              });
            },
          ),
        ],
        title: Text(widget.title),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _originLatitude,
            _originLongitude,
          ),
          zoom: 17.0,
        ),
        markers: _markers.toSet(),
      ),
    );
  }
}

// void setPermissions() async{
//    Map<PermissionGroup, PermissionStatus> permissions =
//    await PermissionHandler().requestPermissions([PermissionGroup.location]);
// }
