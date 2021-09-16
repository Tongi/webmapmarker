import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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

var testError;

class ReusableContainer extends StatefulWidget {
  ReusableContainer({required this.text});

  final String text;

  @override
  _ReusableContainerState createState() => _ReusableContainerState();
}

class _ReusableContainerState extends State<ReusableContainer> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return new GestureDetector(
      child: Container(
        width: kIsWeb ? 120 : 95,
        decoration: BoxDecoration(
            color: selected ? Colors.blue.shade400 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
                color: selected ? Colors.white : Colors.grey.shade600,
                fontSize: kIsWeb ? 12 : 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }
}

/*
Used for https://www.saew-soapery.com/shops.html
for only seeing the map, kindly comment out map.dart and use CheckMarkers instead.

thanks @allanvester.
*/
class _MapScreenState extends State<MapScreen> {
  String valueChooser = "test";

  static const LatLng _center = const LatLng(55.36009, 9.61607);
  final _locationFormKey = GlobalKey<FormState>();

  TextEditingController _latTextfieldController = new TextEditingController();
  TextEditingController _markersTitleTextfieldController =
      new TextEditingController();
  TextEditingController _longTextfieldController = new TextEditingController();
  TextEditingController _markerDescriptionTextfieldController =
      new TextEditingController();
  TextEditingController _DeletemarkerDocumentTextfieldController =
      new TextEditingController();
  TextEditingController _UpdateDocumentTextfieldController =
      new TextEditingController();
  TextEditingController _markerDocumentNameTextfieldController =
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
    hallo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.maybeOf(context)!.size.width;
    GetLocationProvider getLocationProvider =
        Provider.of<GetLocationProvider>(context, listen: true);
    return Scaffold(
      body: _body(getLocationProvider),
    );
  }

  Widget _body(GetLocationProvider getLocationProvider) {
    return Container(
      width: width,
      height: height,
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
                        Container(
                          width: kIsWeb ? 200 : 200,
                          height: kIsWeb ? 40 : 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 4,
                                    color: Colors.black38,
                                    blurRadius: 10,
                                    offset: Offset(0, 5))
                              ]),
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade500),
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Seach for Location',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.grey.shade900,
                                  ),
                                  onPressed: () {},
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: kIsWeb ? 50 : 40,
                            width: kIsWeb ? 600 : 500,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 4,
                                      color: Colors.black38,
                                      blurRadius: 10,
                                      offset: Offset(0, 5))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  new GestureDetector(
                                    child: new ReusableContainer(
                                      text: 'Add Location',
                                    ),
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialog(context),
                                    ),
                                  ),
                                  new GestureDetector(
                                    child: new ReusableContainer(
                                      text: 'Remove Location',
                                    ),
                                    onTap: () => sletDokument(),
                                    //thanks https://github.com/AllanVester for fixing dropdown.
                                  ),
                                  new GestureDetector(
                                      child: new ReusableContainer(
                                        text: 'Show all locations',
                                      ),
                                      onTap: () => viewMarkersButton(
                                          getLocationProvider)),
                                  new GestureDetector(
                                    child: new ReusableContainer(
                                      text: 'Edit stores',
                                    ),
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          opdatereDokument(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )),

// =================it is use for addLocationMarker Button view Method calll========================
                // addLocationMarkerButton(),
                //viewMarkersButton(getLocationProvider),
                //   Idiot(),

                //de tre voids over skal tændes igen :TODO:
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Add Lokation'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: [
            Expanded(
              child: TextField(
                textAlign: TextAlign.center,
                controller: _latTextfieldController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle:
                        TextStyle(fontSize: 15, color: Colors.grey.shade500),
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Add Latitude"),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: TextField(
                textAlign: TextAlign.center,
                controller: _longTextfieldController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle:
                        TextStyle(fontSize: 15, color: Colors.grey.shade500),
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Add Longitude"),
              ),
            )
          ]),

          TextField(
            textAlign: TextAlign.center,
            controller: _markerDocumentNameTextfieldController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Dokument Title',
            ),
          ),
          TextField(
            textAlign: TextAlign.center,
            controller: _markersTitleTextfieldController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Title',
            ),
          ),
          TextField(
            textAlign: TextAlign.center,
            controller: _markerDescriptionTextfieldController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'description',
            ),
          ),
          // det er bare en test
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            addLocationMarkerButton();
            //  Navigator.of(context).pop();
            sackbar(context);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Add'),
        ),
      ],
    );
  }

  List<Object> items = [];

  Future<void> hallo() async {
    //  print(list);
    await getData();
  }

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Location');

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    var test = querySnapshot.docs.map((doc) => doc.id).toList();

    test.asMap().forEach((key, value) {
      //splitter test så det er ikke i en list string.
      items.add(value.replaceAll(',${key + 1}', ''));
    });

    // items.add(test);
    if (items.length == 0) {
      print("List " + items.toString() + " is empty");
    } else {
      print(items.toString() + "<-- in use");
    }
  }

  void sletDokument() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return new AlertDialog(
              title: const Text('Remove document from Database'),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButton<String>(
                      value: valueChooser,
                      onChanged: (changedValue) {
                        setState(() {
                          valueChooser = changedValue!;
                        });

                        print(valueChooser + "<--- valueChooser");
                        print(changedValue! + "<--- changedValue");
                      },
                      items: items.map((value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString()),
                        );
                      }).toList()),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    final collection =
                        FirebaseFirestore.instance.collection('Location');
                    collection
                        .doc(valueChooser)
                        .delete()
                        .then((_) => sackbar(context))
                        .catchError((error) => print('Delete failed: $error'));
                    Navigator.of(context).pop();
                    sackbar(context);
                  },
                  textColor: Theme.of(context).primaryColor,
                  child: const Text('Remove from database.'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget opdatereDokument(BuildContext context) {
    return new AlertDialog(
      title: const Text('Opdatere dokument fra Database'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            textAlign: TextAlign.center,
            controller: _markerDocumentNameTextfieldController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              //////////////////////////////// hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500)
              disabledBorder: InputBorder.none,
              hintText: 'Write the name of the document in the desired rubic.',
            ),
          ),
          TextField(
            textAlign: TextAlign.center,
            controller: _UpdateDocumentTextfieldController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Write in this rubic for the desired document.',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            final collection =
                FirebaseFirestore.instance.collection('Location');

            collection
                .doc(_markerDocumentNameTextfieldController
                    .text) // <-- Doc ID to be Updated.
                .update({
                  'markerDescription': _UpdateDocumentTextfieldController.text
                }) // <-- Update
                .then((_) => sackbar(context))
                .catchError((error) => error = testError);
            print(testError);
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Update to database'),
        ),
      ],
    );
  }

  Future<void> addLocationMarkerButton() async {
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
          .doc(_markerDocumentNameTextfieldController.text)
          .set(user);

      _latTextfieldController.text = '';
      _longTextfieldController.text = '';
      _markersTitleTextfieldController.text = '';
      _markerDescriptionTextfieldController.text = '';
      _markerDocumentNameTextfieldController.text = '';
      print('add data');
    }
  }

  Future<void> sackbar(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Code to execute.
          },
        ),
        content: const Text('Something happend! :-)'),
        duration: const Duration(milliseconds: 4000),
        width: 280.0, // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
    await context;
  }

  Future<void> viewMarkersButton(
      GetLocationProvider getLocationProvider) async {
    if (getLocationProvider.glocationList != null) {
      getLocationProvider.checkforLocation();

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
    }
    await getLocationProvider;
  }
}
