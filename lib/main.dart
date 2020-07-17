import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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
  GoogleMapController _controller;


  List<Marker> _markers = [];
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  
  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

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
                      infoWindow: InfoWindow(
                          title: 'Home location', snippet: 'I work here'),
                      markerId: MarkerId(
                        "Home",
                      ),
                      position: LatLng(_originLatitude, _originLongitude)),
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
                      infoWindow: InfoWindow(
                          title: 'Office location',
                          snippet: 'I used to work here'),
                      markerId: MarkerId(
                        "Office",
                      ),
                      position: LatLng(_destLatitude, _destLongitude)),
                );
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.directions),
            onPressed: () async {
              PolylineResult result =
                  await polylinePoints.getRouteBetweenCoordinates(
                'AIzaSyA7ZjcZBMDaCgAH5sNNXABRpIYDtupnDo0',
                PointLatLng(_originLatitude, _originLongitude),
                PointLatLng(_destLatitude, _destLongitude),
                travelMode: TravelMode.driving,
                wayPoints: [
                  PolylineWayPoint(location: "Home to Office"),
                ],
              );
              if (result.points.isNotEmpty) {
                result.points.forEach((PointLatLng point) {
                  polylineCoordinates
                      .add(LatLng(point.latitude, point.longitude));
                  ;
                });
              }
            },
          )
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
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }
}
