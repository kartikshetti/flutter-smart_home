
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/device_info_route.dart';
import 'device.dart';
import 'device_tile.dart';
import 'add_new_device_route.dart';
class MainRoute extends StatelessWidget{
    Device device;
    BuildContext Context;
   //Tabcontroller for bottom navbar
   //TabController controller;

   Device _currentDevice;
   static final _devices = <Device>[];
   bool isDeviceListEmpty = true;
   MainRoute({Key key,this.device}): super(key: key);



/**void _navigateToAddNewDevices(BuildContext context){

        Navigator.of(context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return Scaffold(

              body: AddNewDeviceRoute(

              ),
            );
          },
        ));
      }**/
    void _onDeviceTap(Device device){
      print(device.name+" was tapped");

      Navigator.push(Context,MaterialPageRoute(
        builder: (context) => DeviceInfoRoute(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: device,
        ),
      ),
      );

    }


    Widget _buildDeviceWidgets(bool isDeviceListEmpty) {
      if (isDeviceListEmpty) {
        print("came here");
        var column=
        Column(
          children: [Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/no_devices.png'),
          ),
              Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
              'No connected devices, Please click on '+' button to add a device'
            ))]);

      /**RaisedButton(
      child: Text('Add Device'),
      onPressed: () => _navigateToAddNewDevices(BuildContext context),
      textColor: Colors.white,
      color: Colors.blue,
      splashColor: Colors.blue[300],
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: BorderSide(color: Colors.blue)
      )
      padding: const EdgeInsets.all(8.0),

      )]);**/
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
          childAspectRatio: 2,
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
  Context=context;
  print("Inside build");
    if(device!=null) {
      print(device.name+"reached main route");
      _devices.add(device);
      isDeviceListEmpty=false;
    }
  print(_devices.length.toString()+"is the devices array len");
    final listView = Padding(
      padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 48.0
      ),
        child:_buildDeviceWidgets(isDeviceListEmpty)
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
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            print('Clicked on + icon');
            Navigator.of(context).push(MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return Scaffold(

                  body: AddNewDeviceRoute(

                  ),
                );
              },
            ));
          },
        ),
      ],
    );
    /**final tabBar =TabBarView(
      // Add tabs as widgets
      children: <Widget>[FirstTab(), SecondTab(), ThirdTab()],
      // set the controller
      controller: controller,
    );**/

    return Scaffold(
      appBar: appBar,
      body: listView,


      /**bottomNavigationBar:Material(
        color: Colors.blue,
        // set the tab bar as the child of bottom navigation bar
        child: TabBar(
          tabs: <Tab>[
            Tab(
              // set icon to the tab
              icon: Icon(Icons.favorite),
            ),
            Tab(
              icon: Icon(Icons.adb),
            ),
            Tab(
              icon: Icon(Icons.airport_shuttle),
            ),
          ],
          // setup the controller
          controller: controller,
        ),
      ),**/
    );
  }


}