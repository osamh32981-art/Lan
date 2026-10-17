import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  var phone = TextEditingController(text: "05");
  var name = TextEditingController(text: "المصمم");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111B21),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 50, color: Color(0xFF075E54)),
              SizedBox(height: 10),
              Text("WhatsApp LAN", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("دخول برقم واسم", style: TextStyle(fontSize: 11, color: Colors.grey)),
              SizedBox(height: 12),
              TextField(controller: phone, decoration: InputDecoration(labelText: "رقم الجوال", border: OutlineInputBorder())),
              SizedBox(height: 8),
              TextField(controller: name, decoration: InputDecoration(labelText: "اسم المستخدم", border: OutlineInputBorder())),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF25D366)),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => HomeScreen(phone: phone.text, name: name.text)));
                  },
                  child: Text("دخول", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String phone;
  final String name;
  HomeScreen({required this.phone, required this.name});

  @override
  Widget build(BuildContext context) {
    var list = [
      {"name": "احمد", "phone": "0555123456", "msg": "دردشة خاصة"},
      {"name": "محمد", "phone": "0555987000", "msg": "صورة LAN"},
      {"name": "العائلة", "phone": "0555000111", "msg": "مكالمة صوتية"},
    ];

    bool isDes = name.contains("المصمم");

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF075E54),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text("WhatsApp", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                if (isDes) Container(margin: EdgeInsets.only(right: 6), padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Text("المصمم", style: TextStyle(fontSize: 10, color: Color(0xFF075E54)))),
              ]),
              Text(phone + " - " + name, style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (c, i) {
            var u = list[i];
            return ListTile(
              leading: CircleAvatar(child: Text(u["name"]![0])),
              title: Text(u["name"]!),
              subtitle: Text(u["msg"]!),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(contact: u)));
              },
            );
          },
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Map<String,String> contact;
  ChatScreen({required this.contact});
  @override
  State<ChatScreen> createState() => _ChatState();
}

class _ChatState extends State<ChatScreen> {
  var ctrl = TextEditingController();
  List<String> msgs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF075E54),
        title: Text(widget.contact["name"]!, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(icon: Icon(Icons.videocam, color: Colors.white), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(name: widget.contact["name"]!, video: true))); }),
          IconButton(icon: Icon(Icons.call, color: Colors.white),