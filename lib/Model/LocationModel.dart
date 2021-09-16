import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  String? id;
  String? lat;
  String? long;
  String? markerTitle;
  String? markerDescription;
  DocumentSnapshot? snapshot;
  DocumentReference? reference;
  LocationModel(
      {this.id,
      this.lat,
      this.long,
      this.markerTitle,
      this.markerDescription,
      this.snapshot,
      this.reference});
  LocationModel.fromSnapShot(DocumentSnapshot s)
      : this.fromjson(s.data() as Map<String, dynamic>, s.id,
            snapshot: s, reference: s.reference);

  LocationModel.fromjson(Map<String, dynamic> json, this.id,
      {this.snapshot, this.reference})
      : lat = json['lat'],
        markerTitle = json['markerTitle'],
        long = json['long'],
        markerDescription = json['markerDescription'];
  Map<String, dynamic> tojson() => {
        'lat': lat,
        'long': long,
        'markerTitle': markerTitle,
        'markerDescription': markerDescription
      };
}
