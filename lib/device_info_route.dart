
import 'package:firebase_database/firebase_database.dart';

import 'device.dart';
import 'package:flutter/material.dart';

class DeviceInfoRoute extends StatefulWidget {
//  final Device device;
//  DeviceInfoRoute({Key key,this.device}): super(key: key);

  @override
  _DeviceInfoRoute createState() => _DeviceInfoRoute();
}

class _DeviceInfoRoute extends State<DeviceInfoRoute> with SingleTickerProviderStateMixin {
  Device device;
  bool isSwitchedRed = false;
  bool isSwitchedBlue = false;
  bool isSwitchedGreen = false;
  final DBRef = FirebaseDatabase.instance.reference();

  void updateRed(bool value) {
    String ledstate = 'OFF';
    if (value)
      ledstate = 'ON';
    DBRef.child("led1").update({
      'status': ledstate
    });
  }

  void updateBlue(bool value) {
    String ledstate = 'OFF';
    if (value)
      ledstate = 'ON';
    DBRef.child("led3").update({
      'status': ledstate
    });
  }

  void updateGreen(bool value) {
    String ledstate = 'OFF';
    if (value)
      ledstate = 'ON';
    DBRef.child("led2").update({
      'status': ledstate
    });
  }

  void getledstates() async {
    String redledstate = (await DBRef.child("led1/status").once()).value;
    String greenledstate = (await DBRef.child("led2/status").once()).value;
    String blueledstate = (await DBRef.child("led3/status").once()).value;
    print("Hey");
    setState(() {
      if(redledstate=='ON')
        isSwitchedRed=true;
      print('Green led state'+greenledstate);
      if(greenledstate=='ON')
        isSwitchedGreen=true;

      if(blueledstate=='ON')
        isSwitchedBlue=true;
    });

}



  @override
  Widget build(BuildContext context) {
    final Device device = ModalRoute
        .of(context)
        .settings
        .arguments;
    var toggleSwitchRed = Switch(
      value: isSwitchedRed,
      onChanged: (value) {
        setState(() {
          isSwitchedRed = value;
          updateRed(value);
          print("Red light " + isSwitchedRed.toString());
        });
      },
      activeTrackColor: Colors.redAccent,
      activeColor: Colors.red,
    );

    var toggleSwitchBlue = Switch(
      value: isSwitchedBlue,
      onChanged: (value) {
        setState(() {
          isSwitchedBlue = value;
          updateBlue(value);
          print("Blue light " + isSwitchedBlue.toString());
        });
      },
      activeTrackColor: Colors.lightBlueAccent,
      activeColor: Colors.blue,
    );

    var toggleSwitchGreen = Switch(
      value: isSwitchedGreen,
      onChanged: (value) {
        setState(() {
          isSwitchedGreen = value;
          updateGreen(value);
          print("Green light " + isSwitchedGreen.toString());
        });
      },
      activeTrackColor: Colors.lightGreenAccent,
      activeColor: Colors.green,
    );
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
              device.name
          ),
        ),
        body: Container(
        child: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Padding(
        padding: EdgeInsets.all(24.0),
        child:  Image.asset(device.iconLocation,
        height: 125),

        )
        ,
        Text(
        "Red LED"
        ), toggleSwitchRed,
        Text(
        "Green LED"
        ), toggleSwitchGreen,
        Text(
        "Blue LED"
        ), toggleSwitchBlue

        ]
        )
        ),

        ));

  }

  @override
  void initState() {
    super.initState();
        getledstates();
        print('Got led states');


    }
  }
