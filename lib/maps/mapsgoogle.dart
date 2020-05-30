import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class PageMap extends StatefulWidget {
  @override
  _PageMapState createState() => _PageMapState();
}

class _PageMapState extends State<PageMap> {

  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;
  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
 // static  LatLng _lastMapPosition = _initialPosition;
  //String _locationMessage = "";
  GoogleMapController mapController;
 // var currentLocation;
//  final LatLng _center = const LatLng(45.521563, -122.677433);
  // current location function

  void _getCurrentLocation() async {

    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    //  _locationMessage = "${position.latitude}, ${position.longitude}";
    });

  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;


  }
  // permission deny

  Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (granted!=true) {
      requestLocationPermission();
    }
    debugPrint('requestContactsPermission $granted');
    return granted;
  } Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Can not Get the current location"),
              content:const Text('Please make sure you enable Location Service'
                  ' and try again'),
              actions: <Widget>[
                FlatButton(
                  color: Colors.deepPurpleAccent,
                  child:Text('Ok') ,
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).pop();
                    _gpsService();
                  },
                )
              ],
            );

          }

      );

    }

  }
  Future _gpsService() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      _checkGps();
      return null;
    } else
      return true;
  }




  @override
  void initState(){
    super.initState();
    _getCurrentLocation();
    requestLocationPermission();
    _gpsService();
  }

  @override
  Widget build(BuildContext context) {
    return _initialPosition == null ? Container(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ):
      Stack(
        children: <Widget>[
          GoogleMap(
        onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 11.0,
          ),

          ),
        ],

    );
  }
}
