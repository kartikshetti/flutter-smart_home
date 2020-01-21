import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:smart_home/device.dart';

//const _rowHeight = 100.0;
//final _borderRadius = BorderRadius.circular(_rowHeight/2);

class DeviceTile extends StatelessWidget {
  final Device device;
  final ValueChanged<Device> onTap;
  final ValueChanged<Device> onLongPress;

  /// The [CategoryTile] shows the name and color of a [Category] for unit
  /// conversions.
  ///
  /// Tapping on it brings you to the unit converter.
  ///
  /// We may want to pass in a null onTap when the Currency [Category]
  //    // is in a loading or error state. In build(), you'll want to update the UI
  //    // accordingly.
  const DeviceTile(
      {Key key, @required this.device, this.onTap, this.onLongPress})
      : assert(device != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 16.0),
        child: GestureDetector(
            onTap: () => onTap(device),
            onDoubleTap: () => onLongPress(device),
            child: Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Image.asset(device.iconLocation, height: 35),
                    ),
                    Text(
                      device.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ))));
  }
}
