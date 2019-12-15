import 'package:flutter/material.dart';

class Device{
  final String name;
  final String iconLocation;
  final bool isDeviceRunning;

  const Device({@required this.name, @required this.iconLocation, @required this.isDeviceRunning,})
    :assert(name!=null),assert(iconLocation!=null),assert(isDeviceRunning!=null);
}