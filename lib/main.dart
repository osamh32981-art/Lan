import 'package:flutter/material.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(backgroundColor: Color(0xFF075E54), title: Text("WhatsApp LAN", style: TextStyle(color: Colors.white))),
        body: Center(child: Text("البناء نجح! الآن نضيف الخصوصية")),
      ),
    );
  }
}