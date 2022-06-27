import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  runApp(MaterialApp(
    home: homegc(),
  ));
}

class homegc extends StatefulWidget {
  const homegc({Key? key}) : super(key: key);

  @override
  State<homegc> createState() => _homegcState();
}

class _homegcState extends State<homegc> {
  bool isVisible = false;
  bool buttonVis = true;
  bool infovisible = false;
  String cpu = "";
  String gpu = "";
  int ram = 0;
  int space = 0;

  Uri url = Uri.parse("http://127.0.0.1:5000/");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                "images/scanp.jpeg",
                height: 50,
                width: 50,
              ),
              SizedBox(
                width: 600,
              ),
              Text(
                'SCAN & PLAY',
                style: TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Colors.grey[300],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Image(
                image: AssetImage('images/desklogo.jpeg'),
                height: 400,
                width: 400,
              ),
            ),
            Visibility(
                visible: isVisible,
                child: Center(
                  child: Column(
                    children: [
                      LoadingAnimationWidget.newtonCradle(
                        color: Colors.black,
                        size: 150,
                      ),
                      Text("Collecting Data... ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                            color: Colors.black,
                          )),
                    ],
                  ),
                )),
            Visibility(
              visible: buttonVis,
              child: ElevatedButton(
                  onPressed: () async {
                    final response = await http.get(url);
                    final decoded =
                        json.decode(response.body) as Map<String, dynamic>;
                    setState(() {
                      isVisible = !isVisible;
                      buttonVis = !buttonVis;
                      Future.delayed(Duration(seconds: 3), () {
                        setState(() {
                          //infovisible = true;
                          isVisible = false;
                          buttonVis = false;
                        });
                      });
                      Future.delayed(Duration(seconds: 4), () {
                        setState(() {
                          infovisible = true;
                        });
                      });
                      cpu = decoded['cpum'];
                      gpu = decoded['gpum'];
                      ram = decoded['ramm'];
                      space = decoded['hddm'];
                    });
                  },
                  child: Text("Scan")),
            ),
            Divider(
              color: Colors.black,
            ),
            Visibility(
              visible: infovisible,
              child: Expanded(
                child: Column(
                  children: [
                    Text("CPU: " + cpu,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                        )),
                    Text("GPU: " + gpu,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                        )),
                    Text("RAM SIZE: " + ram.toInt().toString() + " Gb",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                        )),
                    Text("AVAILABLE SPACE: " + space.toInt().toString() + " Gb",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Acquired Computer Configuration",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    /*Expanded(
                      child: FlatButton(
                          color: Colors.yellow,
                          onPressed: () async {
                            final response = await http.get(url);
                            final decoded = json.decode(response.body)
                                as Map<String, dynamic>;
                            setState(() {
                              cpu = decoded['cpum'];
                              gpu = decoded['gpum'];
                              ram = decoded['ramm'];
                              space = decoded['hddm'];
                            });
                          },
                          child: Text(
                            "Press It",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )),
                    )*/
                    TextButton(onPressed: () => exit(0), child: Text("Exit",
                        style: TextStyle(
                          backgroundColor: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                        ))),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
