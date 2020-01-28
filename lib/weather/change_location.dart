import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
enum cityList { Ahmedabad,
Bangalore,
Chennai,
Hyderabad,
Kolkata,
Mumbai,
NewDelhi ,
Pune,
Surat, }

class ChangeCityRoute extends StatefulWidget {
  ChangeCityRoute({Key key}) : super(key: key);

  @override
  _ChangeCityRouteState createState() => _ChangeCityRouteState();
}

class _ChangeCityRouteState extends State<ChangeCityRoute> {
  cityList _currentCity = cityList.Bangalore;

  navigateBack(BuildContext context){
    Navigator.pop(context,{
      'enter':_currentCity
    });
  }




  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    double Height = MediaQuery.of(context).size.height;

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change city'),
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('assets/icons/city_background.jpg'
            ,
              fit: BoxFit.fill,
              width: Width,
              height: Height,
            ),
          ),
    Center(
      child:
      Column(
      children: <Widget>[
        RadioListTile<cityList>(
          title: const Text('Ahmedabad'),
          value: cityList.Ahmedabad,
          groupValue: _currentCity,
          onChanged: (cityList value) {
            setState(() {
              _currentCity = value;
            });

          },
        ),

        RadioListTile<cityList>(
          title: const Text('Chennai'),
          value: cityList.Chennai,
          groupValue: _currentCity,
          onChanged: (cityList value) {
            setState(() {
              _currentCity = value;
            });

          },
        ),
        RadioListTile<cityList>(
          title: const Text('Bangalore'),
          value: cityList.Bangalore,
          groupValue: _currentCity,
          onChanged: (cityList value) {
            setState(() {
              _currentCity = value;
            });

          },
        ),
        RadioListTile<cityList>(
          title: const Text('Hyderabad'),
          value: cityList.Hyderabad,
          groupValue: _currentCity,
          onChanged: (cityList value) {
            setState(() {
              _currentCity = value;
            });

          },
        ),
        RadioListTile<cityList>(
          title: const Text('Kolkata'),
          value: cityList.Kolkata,
          groupValue: _currentCity,
          onChanged: (cityList value) {
            setState(() {
              _currentCity = value;
            });

          },
        ),
        RadioListTile<cityList>(
          title: const Text('Mumbai'),
          value: cityList.Mumbai,
          groupValue: _currentCity,
          onChanged: (cityList value) {
            setState(() {
              _currentCity = value;
            });

          },
        ),
        RadioListTile<cityList>(
          title: const Text('New Delhi'),
          value: cityList.NewDelhi,
          groupValue: _currentCity,
          onChanged: (cityList value) {
            setState(() {
              _currentCity = value;
            });

          },
        ),
        RadioListTile<cityList>(
          title: const Text('Pune'),
          value: cityList.Pune,
          groupValue: _currentCity,
          onChanged: (cityList value) {
            setState(() {
              _currentCity = value;
            });

          },
        ),
        RadioListTile<cityList>(
          title: const Text('Surat'),
          value: cityList.Surat,
          groupValue: _currentCity,
          onChanged: (cityList value) {
            setState(() {
              _currentCity = value;
            });

          },
        ),

        RaisedButton(
          onPressed: () {
            print('Hello');
            navigateBack(context);
          },
          textColor: Colors.white,
          splashColor: Colors.green,
          color: Colors.red,
          padding: const EdgeInsets.all(8.0),
          elevation: 2.0,
          child: new Text(
            "Apply",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
      ],

    ),

    )


    ],
    ),
    );
  }
}