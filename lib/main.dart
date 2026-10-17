import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData(useMaterial3: false, fontFamily: 'Cairo'), home: const LoginWhatsApp());
}

// ================= LAN SERVICE حقيقي 100% =================
class LanService {
  static final instance = LanService._(); LanService._();
  RawDatagramSocket? udp; ServerSocket? server;
  String myIp = "0.0.0.0"; String myName = "انا";
  Map<String, String> devices = {}; // ip -> name
  Map<String, List<Map<String,dynamic>>> chats = {}; // ip -> messages
  Function()? onUpdate;
  int tcpPort = 8888; int udpPort = 8889;

  Future<void> start(String name) async {
    myName = name;
    try {
      var ifs = await NetworkInterface.list();
      for(var i in ifs){ for(var a in i.addresses){ if(a.type==InternetAddressType.IPv4 && !a.isLoopback){ myIp = a.address; } } }
      server = await ServerSocket.bind(InternetAddress.anyIPv4, tcpPort);
      server!.listen((Socket c){
        c.cast<List<int>>().transform(utf8.decoder).listen((data){
          try {
            var j = jsonDecode(data);
            var ip = c.remoteAddress.address;
            devices[ip] = j['sender'];
            chats.putIfAbsent(ip, ()=>[]);
            chats[ip]!.add({'text': j['text'], 'type': j['type'], 'isMe': false, 'time': DateTime.now(), 'sender': j['sender']});
            onUpdate?.call();
          } catch(_){}
        });
      });
      udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, udpPort);
      udp!.broadcastEnabled = true;
      udp!.listen((e){ if(e==RawSocketEvent.read){ var d=udp!.receive(); if(d==null) return; try{ var j=jsonDecode(utf8.decode(d.data)); var ip=d.address.address; if(ip!=myIp){ devices[ip]=j['name']; chats.putIfAbsent(ip, ()=>[]); onUpdate?.call(); } }catch(_){} } });
      Timer.periodic(Duration(seconds: 2), (_){ try{ udp!.send(utf8.encode(jsonEncode({'name': myName, 'ip': myIp})), InternetAddress("255.255.255.255"), udpPort); }catch(_){} });
    } catch(e){ myIp = "خطأ $e"; }
  }

  Future<void> send(String ip, String type, String text) async {
    try {
      var s = await Socket.connect(ip, tcpPort, timeout: Duration(seconds: 2));
      s.write(jsonEncode({'sender': myName, 'text': text, 'type': type}));
      await s.flush(); s.close();
      chats.putIfAbsent(ip, ()=>[]); chats[ip]!.add({'text': text, 'type': type, 'isMe': true, 'time': DateTime.now(), 'sender': myName});
      onUpdate?.call();
    } catch(_){
      chats.putIfAbsent(ip, ()=>[]); chats[ip]!.add({'text': text, 'type': type, 'isMe': true, 'time': DateTime.now(), 'sender': myName});
      onUpdate?.call();
    }
  }
}

// ================= تسجيل دخول واتساب =================
class LoginWhatsApp extends StatefulWidget { const LoginWhatsApp({super.key}); @override State<LoginWhatsApp> createState() => _LoginW(); }
class _LoginW extends State<LoginWhatsApp> {
  final c = TextEditingController(text: "المصمم");
  @override Widget build(BuildContext context){
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(backgroundColor: Color(0xFF111B21), body: Center(child: Container(margin: EdgeInsets.all(24), padding: EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.chat, size: 70, color: Color(0xFF25D366)), SizedBox(height: 12),
      Text("واتساب LAN", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF075E54))),
      Text("ناس حقيقيين على نفس الشبكة - بدون إنترنت", style: TextStyle(fontSize: 12, color: Colors.grey)),
      SizedBox(height: 20), TextField(controller: c, decoration: InputDecoration(labelText: "اسمك - اكتب المصمم للشارة", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
      SizedBox(height: 8), Container(padding: EdgeInsets.all(8), color: Color(0xFFE7FFDB), child: Row(children: [Icon(Icons.verified, color: Color(0xFF25D366)), SizedBox(width: 6), Expanded(child: Text("اكتب 'المصمم' = شارة زرقاء + تحكم", style: TextStyle(fontSize: 11)))])),
      SizedBox(height: 16), SizedBox(width: double.infinity, height: 48, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF25D366)), onPressed: (){ Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> WhatsAppHome(userName: c.text.isEmpty? "مستخدم": c.text))); }, child: Text("ابدأ الدردشة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
    ]))))));
  }
}

// ================= الرئيسية شكل واتساب =================
class WhatsAppHome extends StatefulWidget { final String userName; const WhatsAppHome({super.key, required this.userName}); @override State<WhatsAppHome> createState() => _HomeW(); }
class _HomeW extends State<WhatsAppHome> with SingleTickerProviderStateMixin {
  late TabController tab; var lan = LanService.instance;
  @override void initState(){ super.initState(); tab = TabController(length: 3, vsync: this); lan.start(widget.userName); lan.onUpdate = (){ if(mounted) setState(()