import 'package:flutter/material.dart';
import 'package:smart_home/device_info_route.dart';
import 'device.dart';
import 'device_tile.dart';
import 'add_new_device_route.dart';
import 'database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainRoute extends StatefulWidget{
  Device device;

  MainRoute({Key key,this.device}): super(key: key);


    @override
    _MainRouteState createState()=> _MainRouteState();

    }

    class _MainRouteState extends State<MainRoute>{
      Device _selectedDevice;
      List<Device> savedDevices;
      static var _devices = <Device>[];
      bool isDeviceListEmpty = true;
      final dbHelper = DatabaseHelper.instance;
      AppBar _appBar,_selectAppBar,_defaultAppbar;


    void _onDeviceTap(Device device){
      print(device.name+" was tapped");

      Navigator.push(context,MaterialPageRoute(
        builder: (context) => DeviceInfoRoute(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: device,
        ),
      ),
      );

    }
    void _onLongPress(Device device){
      print('Long press detected');
      setState(() {
        _selectedDevice=device;
        _appBar =_selectAppBar;
      });


    }

    void _changeAppBar(){
      setState(() {
        _appBar = _defaultAppbar;
      });

    }
/**
 showAlertDialog(BuildContext context) {

          // set up the buttons

          }
**/




      void _deleteDevice() async{
        Widget cancelButton = FlatButton(
          child: Text("Cancel"),
          onPressed:  () {
            Navigator.of(context).pop();
            return;// dismiss dialog
          },
        );
        Widget continueButton = FlatButton(
          child: Text("OK"),
          onPressed:  () {
            Navigator.of(context).pop();
          },
        );

        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text("AlertDialog"),
          content: Text("Are you sure you want to delete this device?"),
          actions: [
            cancelButton,
            continueButton,
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
        await dbHelper.deleteDevice(_selectedDevice.id);
        print('Device deleted');

        setState(() {
        _devices.remove(_selectedDevice);
        _appBar = _defaultAppbar;
      });
    }


    Widget _buildDeviceWidgets(bool isDeviceListEmpty) {
      final weatherViewStack = Stack(
          children:<Widget>[
            Container(
        //padding: EdgeInsets.all(8.0),
        child: Image.asset('assets/icons/weather_background.jpg',width: 500,),
      ),
          Container(
            margin: EdgeInsets.only(left: 24),
            child: new Text('Karwar',
            style: TextStyle(
              color:Colors.white,fontSize: 28
            ),),

          ),
          Container(
            margin: EdgeInsets.all(28.0),
            child: new Text('67.87F',
      style: TextStyle(
      color:Colors.white,fontSize: 18),
          ))]);
      if (isDeviceListEmpty) {
        print("came here");
        var column=
        Column(
          children: [weatherViewStack,
            Container(
            //padding: EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/no_devices.png'),
          ),
              Container(
              //padding: EdgeInsets.all(8.0),
              child: Text(
                'No connected devices, Please click on '+' button to add a device',
                textAlign: TextAlign.center,
                style:TextStyle(
                  fontSize: 18
                ),
            ))]);
        return Center(
          child: Container(
            child: Align(
              alignment: Alignment.center,
              child: column
              ),
            ),
          );
      }
      else {
        return Column(
          children: <Widget>[weatherViewStack,
            Expanded(child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.9,
              children: _devices.map((Device device) {
                return DeviceTile(
                  device: device,
                  onTap: _onDeviceTap,
                  onLongPress: _onLongPress
                );
              }).toList(),
            ))
          ],
        );
      }
    }


       void addDevicetoLocalStorage(device) async {
      if(savedDevices!=null) {
        for (int i = 0; i < savedDevices.length; i++) {
          if (identical(device,savedDevices[i])) {
            print('yes same');
            Fluttertoast.showToast(
                msg: "Device already added!!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
            return;
          }
          else{
            print('Not same');
          }
        }
      }
         await dbHelper.insert(device);

      }

      void getSavedDevices() async {

        savedDevices = await dbHelper.retreiveDevices();
        _devices=[];
        setState(() {
        for(int i=0;i<savedDevices.length;i++){
          _devices.add(savedDevices[i]);
          print(savedDevices[i].deviceStatus.runtimeType);
          isDeviceListEmpty = false;
        }
        print('got saved devices len is');
        print(savedDevices.length);

      });

      }

      Future<bool> _onBackPressed() {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('You are going to exit the application!!'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('NO'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('YES'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });
      }

      @override
      void initState() {
      super.initState();
      if(widget.device!=null)
      addDevicetoLocalStorage(widget.device);
          getSavedDevices();
          print('Executed this getsaveddevices');

      }

      Future<Map> getWeather(String city)async{


      }
      @override
  Widget build(BuildContext context) {
  print(_devices.length.toString()+"is the devices array len");
    final listView = Container(
        child:_buildDeviceWidgets(isDeviceListEmpty)
    );

    _selectAppBar = AppBar(
    title: Text('1'),
    leading: IconButton(
      icon: Icon(Icons.close),
      onPressed: _changeAppBar,

    ),
    actions: <Widget>[
      IconButton(
        icon:Icon(Icons.delete),
        onPressed: _deleteDevice,
      )
    ],
    backgroundColor: Colors.deepPurple,
  );


   _defaultAppbar = AppBar(
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
            Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return Scaffold(

                  body: AddNewDeviceRoute(

                  ),
                );
              },
            ));
          },
        ),
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: ()=> print('pressed menu button'),
        )
      ],
    );
  print('Appbar is'+_appBar.toString());
   if(_appBar==null){
     _appBar = _defaultAppbar;
   }




    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
      appBar: _appBar,
      body:
       Container(
         child: listView,
    )));
  }


}