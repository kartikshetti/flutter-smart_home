import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChangeCityRoute extends StatelessWidget {
  var _cityFieldController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    double Height = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),

      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child:new Image.asset('assets/icons/city_background.jpg',
            width: Width,height: Height,fit: BoxFit.fill,),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter city'
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                  textColor: Colors.white70,
                    color: Colors.redAccent,
                    onPressed: (){
                    Navigator.pop(context,
                    {
                      'enter':_cityFieldController.text
                    });

                    },
                    child: new Text('GetWeather',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.0
                    ),)
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}