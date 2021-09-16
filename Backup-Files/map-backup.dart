import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webmapmarker/Utils/ThemeManger.dart';
import 'package:webmapmarker/Utils/appconst.dart';
import 'package:webmapmarker/notifier/GetLocationProvider.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _center = const LatLng(55.36009, 9.61607);
  final _locationFormKey = GlobalKey<FormState>();

  TextEditingController _latTextfieldController = new TextEditingController();
  TextEditingController _markersTitleTextfieldController =
      new TextEditingController();
  TextEditingController _longTextfieldController = new TextEditingController();
  TextEditingController _markerDescriptionTextfieldController =
      new TextEditingController();

  Set<Marker> _markers = Set();
  late BitmapDescriptor SaewPNG;
  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(40, 40)), 'assets/images/saew.png')
        .then((d) {
      SaewPNG = d;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.maybeOf(context)!.size.width;
    GetLocationProvider getLocationProvider =
        Provider.of<GetLocationProvider>(context, listen: true);
    return Scaffold(
//=======================it is body method calll===============================

      body: _body(getLocationProvider),
    );
  }

//=======================it is body method===============================
  Widget _body(GetLocationProvider getLocationProvider) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 8.0,
              ),
              markers: _markers,
            ),
          ),
          Container(
            height: width * 0.08,
            margin: EdgeInsets.only(bottom: width * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _locationFormKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.01),
                            decoration: BoxDecoration(
                              color: ThemeManager().getBgTextfieldColor(),
                              borderRadius: BorderRadius.circular(width * 0.05),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: width * 0.01),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                    size: width * 0.02,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: width * 0.2,
                                  child: TextFormField(
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.start,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter lat ';
                                      }
                                      return null;
                                    },
                                    controller: _latTextfieldController,
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                        fontSize: width * 0.008,
                                        color: Color(0xff535457)),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: "Enter your latitude",
                                      hintStyle: TextStyle(
                                          fontSize: width * 0.008,
                                          color: Color(0xff535457)),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.01),
                            decoration: BoxDecoration(
                              color: ThemeManager().getBgTextfieldColor(),
                              borderRadius: BorderRadius.circular(width * 0.05),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: width * 0.01),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                    size: width * 0.02,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: width * 0.2,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter long ';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                        fontSize: width * 0.008,
                                        color: Color(0xff535457)),
                                    controller: _longTextfieldController,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      hintText: "Enter your longitude",
                                      hintStyle: TextStyle(
                                          fontSize: width * 0.008,
                                          color: Color(0xff535457)),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.01),
                            decoration: BoxDecoration(
                              color: ThemeManager().getBgTextfieldColor(),
                              borderRadius: BorderRadius.circular(width * 0.05),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: width * 0.01),
                              alignment: Alignment.center,
                              width: width * 0.2,
                              child: TextFormField(
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter makers title ';
                                  }
                                  return null;
                                },
                                controller: _markersTitleTextfieldController,
                                cursorColor: Colors.black,
                                style: TextStyle(
                                    fontSize: width * 0.008,
                                    color: Color(0xff535457)),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: "Marker title",
                                  hintStyle: TextStyle(
                                      fontSize: width * 0.008,
                                      color: Color(0xff535457)),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.01),
                            decoration: BoxDecoration(
                              color: ThemeManager().getBgTextfieldColor(),
                              borderRadius: BorderRadius.circular(width * 0.05),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: width * 0.01),
                              alignment: Alignment.center,
                              width: width * 0.2,
                              child: TextFormField(
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'makers Description ';
                                  }
                                  return null;
                                },
                                controller:
                                    _markerDescriptionTextfieldController,
                                cursorColor: Colors.black,
                                style: TextStyle(
                                    fontSize: width * 0.008,
                                    color: Color(0xff535457)),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: "Marker Description",
                                  hintStyle: TextStyle(
                                      fontSize: width * 0.008,
                                      color: Color(0xff535457)),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

// =================it is use for addLocationMarker Button view Method calll========================
                addLocationMarkerButton(),
                //     Idiot(getLocationProvider),
// =================it is use for viewMarkers Button view Method calll========================
                viewMarkersButton(getLocationProvider),
                Idiot()
              ],
            ),
          ),
        ],
      ),
    );
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.white,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  Widget Idiot() {
    return TextButton(
      style: flatButtonStyle,
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('For Dag'),
          content: const Text(
              'For at markere en Lokalition, jeg vil anbefale at gå ind på https://www.latlong.net/convert-address-to-lat-long.html og så find adressen med longitude & latitude, efter du har fundet dem, sætter du dem i Latitude & Longitude TekstenHolderen. Efter du har fået sat de 2 Placements så kan du vælge Titlen og Beskrivelsen. For at at lave en ny linje skal du skrive <br> og for at afslutte skal du skrive </br> altså feks hvis du har skrevet om et produkt, så for gud lave en <br> for at lave en linje nedeunder. Fordi Ellers så skal jeg ind på en database og slette den :-).'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Hvordan får jeg det til at virke?'),
    );
  }

//======================it is use for addLocationMarkerButton View Method==================
  Widget addLocationMarkerButton() {
    return GestureDetector(
      onTap: () async {
        if (_locationFormKey.currentState!.validate()) {
          print('marker=title==>' + _markersTitleTextfieldController.text);
          Map<String, dynamic> user = new Map();
          user.putIfAbsent("lat", () => _latTextfieldController.text);
          user.putIfAbsent("long", () => _longTextfieldController.text);
          user.putIfAbsent(
              "markerTitle", () => _markersTitleTextfieldController.text);
          user.putIfAbsent("markerDescription",
              () => _markerDescriptionTextfieldController.text);
          await FirebaseFirestore.instance
              .collection("Location")
              .doc()
              .set(user);

          _latTextfieldController.text = '';
          _longTextfieldController.text = '';
          _markersTitleTextfieldController.text = '';
          _markerDescriptionTextfieldController.text = '';
          print('add data');
        }
      },
      child: Container(
        height: width * 0.03,
        width: width * 0.1,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: width * 0.01),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.01, vertical: width * 0.01),
        decoration: BoxDecoration(
            color: ThemeManager().getbgButtonColor(),
            borderRadius: BorderRadius.all(Radius.circular(width * 0.05))),
        child: Text(
          'Add Location',
          style: TextStyle(
              fontSize: width * 0.01,
              color: ThemeManager().getwhiteColor(),
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget viewMarkersButton(GetLocationProvider getLocationProvider) {
    return GestureDetector(
      onTap: () async {
        if (getLocationProvider.glocationList != null) {
          await getLocationProvider.checkforLocation();

          setState(() {
            for (int i = 0; i < getLocationProvider.glocationList.length; i++) {
              _markers.add(Marker(
                icon: SaewPNG,
                markerId: MarkerId("MakerId" + i.toString()),
                position: LatLng(
                    double.parse(getLocationProvider.glocationList[i].lat),
                    double.parse(getLocationProvider.glocationList[i].long)),
                infoWindow: InfoWindow(
                  title: getLocationProvider.glocationList[i].markerTitle
                      .toString(),
                  snippet: getLocationProvider
                      .glocationList[i].markerDescription
                      .toString(),
                  anchor: Offset(0.5, 1.5),
                ),
              ));
            }
          });
        } else {
          print('no data found');
        }
      },
      child: Container(
        height: width * 0.03,
        width: width * 0.1,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: width * 0.01),
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.01, vertical: width * 0.01),
        decoration: BoxDecoration(
            color: ThemeManager().getbgButtonColor(),
            borderRadius: BorderRadius.all(Radius.circular(width * 0.05))),
        child: Text(
          'View Markers',
          style: TextStyle(
              fontSize: width * 0.01,
              color: ThemeManager().getwhiteColor(),
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
