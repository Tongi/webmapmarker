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
    //MapTest(getLocationProvider);
    MapTest(getLocationProvider);
    return Scaffold(
//body kald

      body: _body(getLocationProvider),
    );
  }

//body metode
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> MapTest(GetLocationProvider getLocationProvider) async {
    final db = FirebaseFirestore.instance;
    var result = await db.collection('Location').get();
    result.docs.forEach((res) {
      print(res.id);
    });

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
              title:
                  getLocationProvider.glocationList[i].markerTitle.toString(),
              snippet: getLocationProvider.glocationList[i].markerDescription
                  .toString(),
              anchor: Offset(0.5, 1.5),
            ),
          ));
        }
      });
    } else {
      print('no data found');
    }
  }

  Future<Null> sleepLoop(GetLocationProvider getLocationProvider) =>
      Future.delayed(const Duration(hours: 2), () async {
        print('delayed execution');

        await MapTest(getLocationProvider);
      });
}
