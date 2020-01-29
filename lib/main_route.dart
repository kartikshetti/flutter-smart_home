import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/device_info_route.dart';
import 'device.dart';
import 'device_tile.dart';
import 'add_new_device_route.dart';
import 'database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'weather/change_location.dart';
import 'package:http/http.dart' as http;

class MainRoute extends StatefulWidget {
  Device device;

  MainRoute({Key key, this.device}) : super(key: key);

  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  Device _selectedDevice;
  List<Device> savedDevices;
  static var _devices = <Device>[];
  bool isDeviceListEmpty = true;
  final dbHelper = DatabaseHelper.instance;
  String currentCity, currentTemp,lastUpdatedTime;
  AppBar _appBar, _selectAppBar, _defaultAppbar;

  void _onDeviceTap(Device device) {
    print(device.name + " was tapped");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceInfoRoute(),
        // Pass the arguments as part of the RouteSettings. The
        // DetailScreen reads the arguments from these settings.
        settings: RouteSettings(
          arguments: device,
        ),
      ),
    );
  }

  void _onLongPress(Device device) {
    print('Long press detected');
    setState(() {
      _selectedDevice = device;
      _appBar = _selectAppBar;
    });
  }

  void _changeAppBar() {
    setState(() {
      _selectedDevice = null;
      _appBar = _defaultAppbar;
    });
  }
/**
 showAlertDialog(BuildContext context) {

          // set up the buttons

          }
**/

  void _deleteDevice() async {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          _selectedDevice = null;
          _appBar = _defaultAppbar;
        });
        return; // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        delete();
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
  }

  void delete() async{
    await dbHelper.deleteDevice(_selectedDevice.id);
    setState(() {
      _devices.remove(_selectedDevice);
      _appBar = _defaultAppbar;
    });
    print('Device deleted from database');

  }

  Widget _buildDeviceWidgets(bool isDeviceListEmpty) {
    final weatherViewStack = Stack(children: <Widget>[
      Container(
        child: Image.asset(
          'assets/icons/weather_background.jpg',
          width: 500,
        ),
      ),
      Container(child: updateTempWidget(currentCity))
    ]);
    if (isDeviceListEmpty) {
      print("came here");
      var column = Column(children: [
        weatherViewStack,
        Container(
          child: Image.asset('assets/icons/no_devices.png'),
        ),
        Container(
            child: Text(
          'No connected devices, Please click on ' + ' button to add a device',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ))
      ]);
      return Center(
        child: Container(
          child: Align(alignment: Alignment.center, child: column),
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          weatherViewStack,
          Expanded(
              child: Container(
                color: Colors.redAccent[200],
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.9,
                    children: _devices.map((Device device) {
                      return Container(
                        child: DeviceTile(
                            device: device,
                            onTap: _onDeviceTap,
                            onLongPress: _onLongPress),
                        color:(_selectedDevice!=null && device.id == _selectedDevice.id )?Colors.red[300]:Colors.transparent,
                      );
                    }).toList(),
                  )
                  ,
                  decoration: BoxDecoration(
                      color: Colors.redAccent[100],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)
                      )
                  ),
                ),
              ))
        ],
      );
    }
  }

  void addDevicetoLocalStorage(device) async {
    if (savedDevices != null) {
      for (int i = 0; i < savedDevices.length; i++) {
        if (identical(device, savedDevices[i])) {
          print('yes same');
          Fluttertoast.showToast(
              msg: "Device already added!!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return;
        } else {
          print('Not same');
        }
      }
    }
    await dbHelper.insert(device);
  }

  void getSavedDevices() async {
    savedDevices = await dbHelper.retreiveDevices();
    _devices = [];
    setState(() {
      for (int i = 0; i < savedDevices.length; i++) {
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
    if (widget.device != null) addDevicetoLocalStorage(widget.device);
    getSavedDevices();
    showWeather();
    print('Executed this getsaveddevices');
  }

  void showWeather() async {
    Map data = await getWeather(currentCity);
  }

  Future<Map> getWeather(String city) async {
    if (currentCity == null) {
      currentCity = 'Bangalore';
    }
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=dc9d731eb0d64685906466416d3c9f2a&units=metric';
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(city == null ? 'Bangalore' : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            if (content['cod'] == "404") {
              print('No such city');
              Fluttertoast.showToast(
                  msg: "This city is Unknown.Choose a different city",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                  fontSize: 16.0);
              return new Column(
                children: <Widget>[
                  Container(
                    child: new Text(
                      '${currentCity == null ? 'Bangalore' : currentCity}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(top: 4.0),
                    child: new Text(
                      'City Unknown to mankind',
                      style: TextStyle(color: Colors.white70, fontSize: 19.0),
                    ),
                  )
                ],
              );
            }
            lastUpdatedTime = readTimestamp(content['dt']);
            return new Container(
              margin: EdgeInsets.only(top:2.0),
              child: new Column(
                children: <Widget>[
                  new Container(
                      child: Text(
                        '${currentCity == null ? 'Bangalore' : content['name']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
 Row(
                      children: <Widget>[

                        new Container(
                          child: Text(
                            content['main']['temp'].toString().split('.')[0] +' C',
                            style: new TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 60,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          margin: EdgeInsets.only(left:14.0,right: 14.0,),
                        ),
                        new Container(
                          child: new Text(
                            'Humidity: ${content['main']['humidity'].toString()+"%"}\n'
                                'Min: ${content['main']['temp_min'].toString()} C\n'
                                'Max: ${content['main']['temp_max'].toString()} C',
                            style: new TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        new Container(
                          child:  CachedNetworkImage(
                              placeholder: (context, url) => CircularProgressIndicator(),
                              imageUrl:
                              'https://openweathermap.org/img/wn/${content['weather'][0]['icon']}@2x.png',
                              errorWidget: (context, url, error) => Icon(Icons.error)
                          ),
                        )
                      ],
                    )
                ],
              ),
            );
          } else {
            return new Container();
          }
        });
  }

  Future _gotoChangeCityRoute(BuildContext context) async {
    Map results =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new ChangeCityRoute();
    }));

    if (results != null && results.containsKey('enter')) {
      currentCity = results['enter'];
      showWeather();
    }
  }


  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  @override
  Widget build(BuildContext context) {
    print(_devices.length.toString() + "is the devices array len");
    final listView = Container(child: _buildDeviceWidgets(isDeviceListEmpty));

    _selectAppBar = AppBar(
      title: Text('1'),
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: _changeAppBar,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: _deleteDevice,
        )
      ],
      backgroundColor: Colors.red[400],
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
                  body: AddNewDeviceRoute(),
                );
              },
            ));
          },
        ),
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _gotoChangeCityRoute(context);
          },
        ),
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              showWeather();
              print('Updated weather');
              Fluttertoast.showToast(
                  msg: 'Updated weather now',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }),
      ],
    );
    print('Appbar is' + _appBar.toString());
    if (_appBar == null) {
      _appBar = _defaultAppbar;
    }

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: _appBar,
            body: Container(
              child: listView,
            )));
  }
}
