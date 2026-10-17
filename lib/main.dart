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
      home: Login(),
    );
  }
}

class Login extends StatelessWidget {
  final p = TextEditingController(text: "05");
  final n = TextEditingController(text: "المصمم");
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
              Text("واتساب LAN", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF075E54))),
              Text("رقم + اسم - خصوصية - منفصل", style: TextStyle(fontSize: 11, color: Colors.grey)),
              SizedBox(height: 12),
              TextField(controller: p, decoration: InputDecoration(labelText: "رقم الجوال", border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone))),
              SizedBox(height: 8),
              TextField(controller: n, decoration: InputDecoration(labelText: "اسم المستخدم", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF25D366)),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home(phone: p.text, name: n.text)));
                  },
                  child: Text("دخول آمن 🔒", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final String phone;
  final String name;
  Home({required this.phone, required this.name});
  @override
  State<Home> createState() => _HomeS();
}

class _HomeS extends State<Home> {
  List<Map<String,String>> users = [
    {'name':'أحمد - LAN','phone':'0555123456','msg':'أهلاً - دردشة خاصة منفصلة'},
    {'name':'محمد','phone':'0555987654','msg':'📸 صورة'},
    {'name':'لابتوب العائلة','phone':'0555000111','msg':'🎤 مكالمة صوتية'},
  ];
  @override
  Widget build(BuildContext context) {
    bool isDes = widget.name.contains("المصمم");
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
                if(isDes) Container(margin: EdgeInsets.only(right: 6), padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Text("المصمم ⭐", style: TextStyle(fontSize: 9, color: Color(0xFF075E54), fontWeight: FontWeight.bold))),
              ]),
              Text("${widget.name} - ${widget.phone}", style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, i) {
            var u = users[i];
            return ListTile(
              leading: CircleAvatar(backgroundColor: Color(0xFFDFE5E7), child: Text(u['name']![0])),
              title: Row(children: [Text(u['name']!, style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 4), Icon(Icons.lock, size: 12, color: Color(0xFF075E54))]),
              subtitle: Text(u['msg']!),
              trailing: Text("12:30", style: TextStyle(fontSize: 11, color: Color(0xFF25D366))),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(contact: u, myPhone: widget.phone, myName: widget.name)));
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(backgroundColor: Color(0xFF25D366), onPressed: (){}, child: Icon(Icons.chat, color: Colors.white)),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final Map<String,String> contact;
  final String myPhone;
  final String myName;
  ChatPage({required this.contact, required this.myPhone, required this.myName});
  @override
  State<ChatPage> createState() => _ChatS();
}

class _ChatS extends State<ChatPage> {
  final ctrl = TextEditingController();
  List<Map<String,dynamic>> msgs = [];
  void send(String t, String txt){
    if(txt.trim().isEmpty) return;
    setState(()=> msgs.add({'text': txt, 'type': t, 'isMe': true}));
    ctrl.clear();
  }
  void callPage(bool video){
    Navigator.push(context, MaterialPageRoute(builder: (_) => CallPage(name: widget.contact['name']!, video: video)));
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Color(0xFF075E54), title: Text(widget.contact['name']!, style: TextStyle(color: Colors.white)), actions: [
          IconButton(icon: Icon(Icons.videocam, color: Colors.white), onPressed: ()=> callPage(true)),
          IconButton(icon: Icon(Icons.call, color: Colors.white), onPressed: ()=> callPage(false)),
        ]),
        body: Column(children: [
          Container(color: Color(0xFFFEF3C7), padding: EdgeInsets.all(6), child: Row(children: [Icon(Icons.lock, size: 14), SizedBox(width: 6), Expanded(child: Text("دردشة خاصة منفصلة ${widget.myPhone} -> ${widget.contact['phone']} - مشفرة 🔒", style: TextStyle(fontSize: 10)))])),
          Expanded(child: Container(color: Color(0xFFE5DDD5), child: ListView.builder(reverse: true, padding: EdgeInsets.all(8), itemCount: msgs.length, itemBuilder: (_, i){
            var m = msgs[msgs.length-1-i];
            bool isMe = m['isMe'];
            return Align(alignment: isMe? Alignment.centerLeft: Alignment.centerRight, child: Container(margin: EdgeInsets.symmetric(vertical: 3), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: isMe? Color(0xFFDCF8C6): Colors.white, borderRadius: BorderRadius.circular(8)), child: Text(m['text'])));
          }))),
          Container(color: Colors.white, padding: EdgeInsets.all(6), child