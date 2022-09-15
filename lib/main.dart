// import 'package:flutter/material.dart';
//
// import 'HomePage.dart';
//
// void main() => runApp(new MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Localization Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }



import 'dart:async';

import 'package:exampleone/constant/Constant.dart';
import 'package:exampleone/model/RadioModel.dart';
import 'package:exampleone/screen/SplashScreen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localization/localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) async {
    print('setLocale()');
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();

    state.setState(() {
      state.locale = newLocale;
    });
  }

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    print('initState()');

    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this.locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.localeLoaded == false) {
      return CircularProgressIndicator();
    } else {
      return MaterialApp(
          title: 'Localization Demo',
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(primarySwatch: Colors.blue),
          home: new SplashScreen(),
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''), // English
            const Locale('hi', ''), // Hindi
            const Locale('ar', ''), // Arabic
          ],
          locale: locale,
          routes: <String, WidgetBuilder>{
            HOME_SCREEN: (BuildContext context) => new HomeScreen(),
          });
    }
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString('languageCode') == null) {
      return null;
    }

    print('_fetchLocale():' +
        (prefs.getString('languageCode') +
            ':' +
            prefs.getString('countryCode')));

    return Locale(
        prefs.getString('languageCode'), prefs.getString('countryCode'));
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<RadioModel> _langList = new List<RadioModel>();

  int _index=0;

  @override
  void initState() {
    super.initState();

    _initLanguage();

  }

  bool isDevicePlatformAndroid() {
    return Theme.of(context).platform == TargetPlatform.android;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF6F8FA),
        appBar: AppBar(
          elevation: isDevicePlatformAndroid() ? 0.2 : 0.0,
          backgroundColor: const Color(0xFFF6F8FA),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).appNameShort, style: TextStyle(color: Colors.black,
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert,color: Colors.black,),
                onSelected: (value) {
                  // if value 1 show dialog
                  if (value == 1)
                  {
                    _updateLocale('en', '');
                  }
                  else if (value == 2)
                  {
                    _updateLocale('hi', '');
                  }
                  else if (value == 3)
                  {
                    _updateLocale('ar', '');
                  }
                },
                itemBuilder: (BuildContext bc) {
                  return const [
                    PopupMenuItem(
                      child: Text("English"),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Text("Hindi"),
                      value: 2,
                    ),
                    PopupMenuItem(
                      child: Text("Arabic"),
                      value: 3,
                    ),
                  ];
                },

              ),
            ],
          ),
        ),
        body: new Container(
            child: new Column(
          children: <Widget>[
            _buildMainWidget(),
            _buildLanguageWidget(),
          ],
        ))
    );
  }

  Widget _buildMainWidget() {
    return new Flexible(
      child: Container(
        color: Colors.grey.shade100,
        child: ListView(
          children: <Widget>[
            _buildHeaderWidget(),
            _buildTitleWidget(),
            _buildDescWidget(),
          ],
        ),
      ),
      flex: 9,
    );
  }

  Widget _buildHeaderWidget() {
    return new Center(
      child: Container(
        margin: EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0),
        height: 160.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.all(
            new Radius.circular(8.0),
          ),
          image: new DecorationImage(
            fit: BoxFit.contain,
            image: new AssetImage(
              '',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWidget() {
    return new Container(
      margin: EdgeInsets.only(top: 16.0, left: 12.0, right: 12.0),
      child: Text(
        AppLocalizations.of(context).title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDescWidget() {
    return new Center(
      child: Container(
        margin: EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
        child: Text(
          AppLocalizations.of(context).desc,
          style: TextStyle(color: Colors.black87, inherit: true, fontSize: 13.0, wordSpacing: 8.0),),
      ),
    );
  }

  Widget _buildLanguageWidget() {
    return new Flexible(
      child: Container(
        padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
        margin: EdgeInsets.only(left: 4.0, right: 4.0),
        color: Colors.grey[100],
        child: ListView.builder(
          itemCount: _langList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return new InkWell(
              splashColor: Colors.blueAccent,
              onTap: () {
                setState(() {
                  _langList.forEach((element) => element.isSelected = false);
                  _langList[index].isSelected = true;
                  _index = index;
                  _handleRadioValueChanged();
                });
              },
              child: new RadioItem(_langList[index]),
            );
          },
        ),
      ),
    );
  }

  List<RadioModel> _getLangList() {
    if(_index==0) {
      _langList.add(new RadioModel(true, 'English'));
      _langList.add(new RadioModel(false, 'हिंदी'));
      _langList.add(new RadioModel(false, 'Arabic'));
    } else if(_index==1) {
      _langList.add(new RadioModel(false, 'English'));
      _langList.add(new RadioModel(true, 'हिंदी'));
      _langList.add(new RadioModel(true, 'Arabic'));
    }

    return _langList;
  }

  Future<String> _getLanguageCode() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('languageCode') == null) {
      return null;
    }
    print('_fetchLocale():' + prefs.getString('languageCode'));
    return prefs.getString('languageCode');
  }

  void _initLanguage() async {
    Future<String> status = _getLanguageCode();
    status.then((result) {
      if (result != null && result.compareTo('en') == 0) {
        setState(() {
          _index = 0;
        });
      }
      if (result != null && result.compareTo('hi') == 0) {
        setState(() {
          _index = 1;
        });
      } else {
        setState(() {
          _index = 0;
        });
      }
      print("INDEX: $_index");

      _setupLangList();
    });
  }

  void _setupLangList() {
    setState(() {
      _langList.add(new RadioModel(_index==0?true:false, 'English'));
      _langList.add(new RadioModel(_index==0?false:true, 'हिंदी'));
      _langList.add(new RadioModel(_index==0?false:true, 'Arabic'));
    });
  }

  void _updateLocale(String lang, String country) async {
    print(lang + ':' + country);

    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', lang);
    prefs.setString('countryCode', country);

    MyApp.setLocale(context, Locale(lang, country));
  }

  void _handleRadioValueChanged() {
        print("SELCET_VALUE: " + _index.toString());
        setState(() {
          switch (_index) {
            case 0:
              print("English");
              _updateLocale('en', '');
              break;
            case 1:

              print("Hindi");
              _updateLocale('hi', '');
              break;
            case 2:
              print("Arabic");
              _updateLocale('ar', '');
              break;
          }
    });
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Card(

    );
  }
}
