import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:webmapmarker/Model/LocationModel.dart';

class GetLocationProvider with ChangeNotifier {
  LocationModel? locationmodel;
  List<LocationModel> _locationList = [];

  get glocationList => _locationList;
  set slocationList(value) {
    _locationList = value;
    notifyListeners();
  }

  Future<void> checkforLocation() async {
    return Future.delayed(const Duration(seconds: 1), () async {
      _locationList = [];

      await FirebaseFirestore.instance
          .collection('Location')
          .get()
          .then((value) {
        print("Value ${value.docs.length}");
        value.docs.forEach((element) {
          LocationModel locationModel = LocationModel.fromSnapShot(element);
          if (!_locationList.contains(locationModel)) {
            _locationList.add(locationModel);

            notifyListeners();
            print('locationlistYES==>${_locationList.length}');
            print("" +
                'List Size :-YES==> ' +
                _locationList[0].markerTitle.toString() +
                "   length--" +
                _locationList.length.toString());
          } else {
            int index = _locationList.indexOf(locationModel);
            if (index >= 0 && index < _locationList.length) {
              _locationList[index] = locationModel;
              notifyListeners();
              print('locationlistNO==>${_locationList.length}');
              print("" +
                  'List Size :-NO==> ' +
                  _locationList.toString() +
                  "   length--" +
                  _locationList.length.toString());
            }
          }
        });
      });
      return;
    });
  }

  Future<void> GetDocuments() async {
    final db = FirebaseFirestore.instance;
    var result = await db.collection('Location').get();
    result.docs.forEach((res) {
      print(res.id);
    });
    return;
  }
}
