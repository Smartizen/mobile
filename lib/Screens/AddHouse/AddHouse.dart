import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartizen/Redux/action.dart';
import 'package:smartizen/Redux/app_state.dart';
import 'package:smartizen/utils/app_color.dart';

class AddHouse extends StatefulWidget {
  @override
  _AddHouseState createState() => _AddHouseState();
}

class _AddHouseState extends State<AddHouse> {
  GoogleMapController mapController;

  LatLng viewPosition = LatLng(21.0309619, 106.773997);
  String searchAddr;
  String address = '';
  double lat;
  double long;
  Set<Marker> _markers = {};

  void initState() {
    super.initState();
    welcomeDialog();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      setState(() {
        mapController = controller;
      });
    });
    getFirstPosition();
  }

  welcomeDialog() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isHaveHouse = sharedPreferences.containsKey('houseId');
    if (!isHaveHouse)
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Chào mừng đã đến với nền tảng Smartizen"),
              content: Text("Hãy chọn vị trí căn nhà của bạn"),
              backgroundColor: Colors.white,
              elevation: 24.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
            );
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackgroud,
          title: Text("Xác nhận địa chỉ"),
        ),
        body: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  GoogleMap(
                      onMapCreated: _onMapCreated,
                      markers: _markers,
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      onCameraIdle: () => getCurrentPosition(),
                      initialCameraPosition:
                          CameraPosition(target: viewPosition, zoom: 20)),
                  DraggableScrollableSheet(
                    maxChildSize: 0.85,
                    minChildSize: 0.1,
                    builder: (BuildContext context,
                        ScrollController scrolController) {
                      return Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.footBarBackgroud,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  topLeft: Radius.circular(40)),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25, top: 50, right: 25),
                                  child: Container(
                                    height: 50.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Nhập địa chỉ',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15.0, top: 15.0),
                                          suffixIcon: IconButton(
                                              icon: Icon(Icons.search),
                                              onPressed: searchandNavigate,
                                              iconSize: 30.0)),
                                      onChanged: (val) {
                                        setState(() {
                                          searchAddr = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 25, top: 25, right: 25),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.house_outlined,
                                          color: AppColors.iconColor,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            address.length > 0 ? address : "",
                                            style: TextStyle(
                                                fontFamily: "SF Rounded",
                                                fontSize: 16,
                                                color: AppColors.fontColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 25, top: 25, right: 25),
                                    child: ButtonTheme(
                                      height: 50,
                                      child: RaisedButton(
                                        onPressed: () {
                                          addNewHouse(context);
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                        color: Color(0xFF0882fa),
                                        child: Text(
                                          'Xác Nhận',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  )
                ],
              );
            }));
  }

  addNewHouse(BuildContext context) async {
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(createHouse(context, address, lat, long));
  }

  searchandNavigate() async {
    List<Location> locations = await locationFromAddress(searchAddr);
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("id-1"),
          position: LatLng(locations[0].latitude, locations[0].longitude),
          infoWindow: InfoWindow(title: "Your House", snippet: "Your house")));

      lat = locations[0].latitude;
      long = locations[0].longitude;

      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(locations[0].latitude, locations[0].longitude),
          zoom: 20.0)));
    });
  }

  getCurrentPosition() async {
    double screenWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    double screenHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;

    double middleX = screenWidth / 2;
    double middleY = screenHeight / 3;
    LatLng position = await mapController.getLatLng(
      ScreenCoordinate(
        x: middleX.round(),
        y: middleY.round(),
      ),
    );
    List<Placemark> newPlace =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    var marker = Marker(markerId: MarkerId("id-1"), position: position);
    setState(() {
      _markers.add(marker);
      address = newPlace[0].street.toString();
      lat = position.latitude;
      long = position.longitude;
    });
  }

  getFirstPosition() async {
    List<Placemark> newPlace;
    await Geolocator.getCurrentPosition().then((value) async => {
          newPlace =
              await placemarkFromCoordinates(value.latitude, value.longitude),
          setState(() {
            _markers.add(Marker(
                markerId: MarkerId("id-1"),
                position: LatLng(value.latitude, value.longitude),
                infoWindow:
                    InfoWindow(title: "Your House", snippet: "Your house")));

            address = newPlace[0].street.toString();

            lat = value.latitude;
            long = value.longitude;

            mapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(value.latitude, value.longitude),
                    zoom: 20.0)));
          })
        });
  }
}
