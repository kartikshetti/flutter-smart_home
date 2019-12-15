
import 'package:flutter/material.dart';
import 'device.dart';
import 'device_tile.dart';
import 'add_new_device_route.dart';
class MainRoute extends StatefulWidget{

  @override
  _MainRouteState createState() => _MainRouteState();

}

class _MainRouteState extends State<MainRoute>{
  Device _currentDevice;
  final _devices = <Device>[];
  bool isDeviceListEmpty = true;


  void _addDevices(Device device){
    setState(() {
      isDeviceListEmpty = false;
      _devices.add(device);
    });
  }

    void _onDeviceTap(Device device){
        setState(() {
          _currentDevice = device;
        });
    }

    void _navigateToAddNewDevices(BuildContext context){

        Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                elevation: 1.0,
                title: Text(
                  "Add New Device",
                ),
              ),
              body: AddNewDeviceRoute(

              ),
            );
          },
        ));
      }


    Widget _buildDeviceWidgets(bool isDeviceListEmpty) {
      if (isDeviceListEmpty) {
        var column=
        Column(
          children: [Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/no_devices.png'),
          ),
              Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
              'No connected devices, Please add a device'
            )),

      RaisedButton(
      child: Text('Add Device'),
      onPressed: () => _navigateToAddNewDevices(context),
      textColor: Colors.white,
      color: Colors.blue,
      splashColor: Colors.blue[300],
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: BorderSide(color: Colors.blue)
      ),
      padding: const EdgeInsets.all(8.0),

      )]);
        return Center(
          child: Container(
              height: 240,
            child: Align(
              alignment: Alignment.center,
              child: column
              ),
            ),
          );
      }
      else {
        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1,
          children: _devices.map((Device device) {
            return DeviceTile(
              device: device,
              onTap: _onDeviceTap,
            );
          }).toList(),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    final listView = Padding(
      padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 48.0
      ),
      child: _buildDeviceWidgets(isDeviceListEmpty),
    );

    final appBar = AppBar(
      elevation: 0.0,
      title: Text(
        'Smart Home',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }


}