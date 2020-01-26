import 'package:boilermake/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AidFirst',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'AidFirst'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                'Welcome to AidFirst',
                style: GoogleFonts.bebasNeue(
                  fontSize: 45,
                ),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.all(4.0),
              child: Container(
                  height: 200,
                  width: 375,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/gethelp.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Get Help!",
                        style: GoogleFonts.bangers(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 60,
                        ),
                      ),
                    ),
                  )),
              onPressed: () async {
                final firstcamera = await getCamera();
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => TakePictureScreen(
                        camera: firstcamera,
                      ),
                    ));
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.all(4.0),
              child: Container(
                height: 150,
                width: 375,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/performfirstaid.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: Text(
                    "Perform \nFirst Aid",
                    style: GoogleFonts.bangers(
                        color: Colors.white,
                        height: 1.0,
                        fontSize: 60,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => FirstAidList(),
                    ));
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.all(4.0),
              child: Container(
                height: 150,
                width: 375,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/call911.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: Text(
                    "Call 911",
                    style: GoogleFonts.bangers(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              onPressed: () {
                launch("tel://911");
              },
            ),

            /*   Text(
              '$_counter',
              style: Theme.of(context).textTheme.display2,
            ), */
          ],
        ),
      ),
    );
  }
}
