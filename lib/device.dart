import 'package:flutter/material.dart';
import 'database_helper.dart';
class Device{
  final int id;
  final String name;
  final String iconLocation;
  final String deviceStatus;

  const Device({@required this.id,@required this.name, @required this.iconLocation, @required this.deviceStatus,})
    :assert(id!=null),assert(name!=null),assert(iconLocation!=null),assert(deviceStatus!=null);

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'icon_location': iconLocation,
      'device_status': deviceStatus
    };
  }

  bool operator ==(other) {
    return (other is Device && other.id == id);
  }
}

