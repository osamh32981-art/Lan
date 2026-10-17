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

class LoginScreen extends StatelessWidget {
  final phoneCtrl = TextEditingController(text: "05");
  final nameCtrl = TextEditingController(text: "المصمم");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111B21),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(22),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 55, color: Color(0xFF075E54)),
              SizedBox(height: 8),
              Text("WhatsApp LAN", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFF075E54))),
              Text("دخول برقم واسم - دردشات منفصلة خاصة", style: TextStyle(fontSize: 11, color: Colors.grey)),
              SizedBox(height: 16),
              TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: "رقم الجوال", prefixIcon: Icon(Icons.phone), border: OutlineInputBorder())),
              SizedBox(height: 10),
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "اسم المستخدم", prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF25D366)),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(phone: phoneCtrl.text, name: nameCtrl.text)));
                  },
                  child: Text("دخول آمن", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String phone;
  final String name;
  HomeScreen({required this.phone, required this.name});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String,String>> contacts = [
    {'name': 'أحمد', 'phone': '0555123456', 'last': 'دردشة خاصة منفصلة 🔒'},
    {'name': 'محمد', 'phone': '0555987000', 'last': '📸 صورة LAN'},
    {'name': 'لابتوب العائلة', 'phone': '0555000111', 'last': '🎤 مكالمة صوتية'},
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
                if(isDes) Container(margin: EdgeInsets.only(right: 6), padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: Text("المصمم ⭐ موثق", style: TextStyle(fontSize: 9, color: Color(0xFF075E54), fontWeight: FontWeight.bold))),
              ]),
              Text("${widget.name} • ${widget.phone} • خصوصية", style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(color: Color(0xFF111B21), padding: EdgeInsets.all(8), child: Row(children: [Icon(Icons.lock, color: Color(0xFF25D366), size: 14), SizedBox(width: 6), Text("كل دردشة منفصلة لوحدها - محمية برقمك - لا يراها أحد", style: TextStyle(color: Colors.white70, fontSize: 10))])),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_,__) => Divider(height: 1),
                itemCount: contacts.length,
                itemBuilder: (_, i) {
                  var c = contacts[i];
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: Color(0xFFDFE5E7), child: Text(c['name']![0])),
                    title: Row(children: [Text(c['name']!, style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 4), Icon(Icons.lock, size: 12, color: Color(0xFF075E54))]),
                    subtitle: Text(c['last']!),
                    trailing: Text("12:30", style: TextStyle(fontSize: 11, color: Color(0xFF25D366))),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(contact: c, myPhone: widget.phone)));
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(backgroundColor: Color(0xFF25D366), onPressed: (){}, child: Icon(Icons.chat, color: Colors.white)),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Map<String,String> contact;
  final String myPhone;
  ChatScreen({required this.contact, required this.myPhone});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ctrl = TextEditingController();
  List<Map<String,String>> msgs = [];
  void send(String t, String txt){
    if(txt.trim().isEmpty) return;
    setState(()=> msgs.add({'type': t, 'text': txt}));
    ctrl.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF075E54),
          title: Text(widget.contact['name']!, style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(icon: Icon(Icons.videocam, color: Colors.white), onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(name: widget.contact['name']!, video: true)))),
            IconButton(icon: Icon(Icons.call, color: Colors.white), onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(name: widget.contact['name']!, video: false)))),
          ],
        ),
        body: Column(
          children: [
            Container(color: Color(0xFFFEF3C7), padding: EdgeInsets.all(6), child: Text("🔒 دردشة خاصة منفصلة ${widget.myPhone} -> ${widget.contact['phone']} - مشفرة", style: TextStyle(fontSize: 10))),
            Expanded(child: Container(color: Color(0xFFE5DDD5), child: ListView.builder(reverse: true, padding: EdgeInsets.all(8), itemCount: msgs.length, itemBuilder: (_, i){
              var m = msgs[msgs.length-1-i];
              return Align(alignment: Alignment.centerLeft, child: Container(margin: EdgeInsets.symmetric(vertical: 3), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFFDCF8C6), borderRadius: BorderRadius.circular(8)), child: m['type']=='text'? Text(m['text']!): m['type']=='image'? Container(height: 80, width: 120, color: Colors.black12, child: Icon(Icons.image)): Row(children: [Icon(Icons.mic, size: 16), Text(" صوت 0:18")])));
            }))),
            Container(color: Colors.white, padding: EdgeInsets.all(6), child: Row(children: [
              IconButton(icon: Icon(Icons.photo), onPressed: ()=> send('image','صورة')),
              Expanded(child: TextField(controller: ctrl, decoration: InputDecoration(hintText: "رسالة خاصة...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), filled: true, fillColor: Color(0xFFF0F0F0)))),
              SizedBox(width: 6),
              CircleAvatar(backgroundColor: Color(0xFF25D366), child: IconButton(icon: Icon(Icons.send, color: Colors.white, size: 18), onPressed: ()=> send('text', ctrl.text)))
            ]))
          ],
        ),
      ),
    );
  }
}

class CallScreen extends StatefulWidget {
  final String name;
  final bool video;
  CallScreen({required this.name, required this.video});
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int sec = 0;
  Timer? timer;
  @override
  void initState(){
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (t){ if(mounted) setState(()=> sec++); });
  }
  @override
  void dispose(){ timer?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111B21),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CircleAvatar(radius: 65, backgroundColor: Color(0xFF25D366), child: Text(widget.name[0], style: TextStyle(fontSize: 55, color: Colors.white))),
        SizedBox(height: 12),
        Text(widget.name, style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
        Text("${widget.video? "مكالمة فيديو":"مكالمة صوتية"} • ${sec~/60}:${(sec%60).toString().padLeft(2,'0')}", style: TextStyle(color: Colors.white70)),
        SizedBox(height: 40),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.mic_off, color: Colors.white)),
          SizedBox(width: 20),
          CircleAvatar(backgroundColor: Colors.red, radius: 30, child: IconButton(icon: Icon(Icons.call_end, color: Colors.white), onPressed: ()=> Navigator.pop(context))),
          SizedBox(width: 20),
          CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.volume_up, color: Colors.white)),
        ])
      ]))),
    );
  }
}