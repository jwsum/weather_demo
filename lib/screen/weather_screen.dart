import 'package:flutter/material.dart';
import 'package:weather_forecast/bloc/weather_bloc.dart';
import 'package:weather_forecast/common/constants.dart';
import 'package:weather_forecast/common/widgets.dart';
import 'package:weather_forecast/models/weather_data.dart';

class WeatherHome extends StatefulWidget {
  WeatherHome({Key key}) : super(key: key);

  @override
  _WeatherHomeState createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {

  final _bloc = WeatherHomeBloc();

  @override
  void initState() {
    _bloc.initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: _mainScreen()
    );

  }

  Widget _mainScreen(){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
            ),
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                title: Text("Weather Today", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.blueAccent,
                elevation: 0.0,
              ),
              drawer: _drawer(),
              body: SafeArea(
                child: _background()
              ),
            ),
            StreamBuilder<bool>(
              stream: _bloc.isLoadingStream,
              initialData: false,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                return snapshot.data ? LoadingDialog() : Container();
              },
            ),
          ],
        )
    );
  }

  Widget _background(){
    return StreamBuilder<AppData>(
      stream: _bloc.appDataStream,
      builder: (context, snapshot){
        String icon = snapshot.data.weatherData.icon + ".png";
        String desc = snapshot.data.weatherData.main;
        String temp = snapshot.data.condition.feelsLike.toString();
        String humid = snapshot.data.condition.humidity.toString();
        String min = snapshot.data.condition.tempMin.toStringAsFixed(1);
        String max = snapshot.data.condition.tempMax.toStringAsFixed(1);
        String bgImage = _bloc.getBGImage(snapshot.data.id, icon);
        return Stack(
          children: <Widget>[
            new Center(
              child: Container(
                child: new Image.asset('assets/images/$bgImage.jpg',
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  colorBlendMode: BlendMode.darken,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
              )
            ),
            new Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(right: 20, top: 20),
              child: new Text(snapshot.data.cityName,
                style: cityStyle()
              ),
            ),
            new Container(
              alignment: Alignment.center,
              child: Image.asset('assets/images/$icon')         
            ),
            new Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.45,
                bottom: MediaQuery.of(context).size.height * 0.05,
                top: MediaQuery.of(context).size.height * 0.55
              ),
              padding: EdgeInsets.all(15),
              color: Color.fromRGBO(0, 0, 0, 0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(desc,
                    style: tempStyle(),
                  ),
                  new Text(temp + " C",
                    style: tempStyle(),
                  ),
                  new Text("humidity: " + humid,
                    style: textStyle(),
                  ),
                  new Text("Min: " + min + " C",
                    style: textStyle(),
                  ),
                  new Text("Max: " + max + " C",
                    style: textStyle(),
                  ),
                ],
              )
            )
          ],
        );
      }
    );
  }

  TextStyle cityStyle(){
    return TextStyle(
      color : Colors.white,
      fontSize : 24,
      fontStyle: FontStyle.italic
    );
  }
  
  TextStyle tempStyle(){
    return TextStyle(
      color : Colors.white,
      fontSize : 24,
      fontStyle: FontStyle.normal
    );
  }

  TextStyle textStyle(){
    return TextStyle(
      color : Colors.white,
      fontSize : 14,
      fontStyle: FontStyle.normal
    );
  }

  Widget _drawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 20, left: 10),
        children: <Widget>[
          ListTile(
            title: Text('Kuala Lumpur'),
            onTap: () {
              _bloc.getAppData(Constants.klId);
            },
          ),
          ListTile(
            title: Text('George Town'),
            onTap: () {
              _bloc.getAppData(Constants.georgeTownId);
            },
          ),
          ListTile(
            title: Text('Johor Bahru'),
            onTap: () {
              _bloc.getAppData(Constants.jbId);
            },
          )
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the app'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }
}