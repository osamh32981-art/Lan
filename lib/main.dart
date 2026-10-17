import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: const LoginPage());
}

class LoginPage extends StatefulWidget { const LoginPage({super.key}); @override State<LoginPage> createState() => _LoginState(); }
class _LoginState extends State<LoginPage> {
  final nameCtrl = TextEditingController(text: "المصمم");
  @override Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(backgroundColor: const Color(0xFF111B21),
      body: Center(child: Container(margin: const EdgeInsets.all(20), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.chat, size: 60, color: Color(0xFF25D366)),
          const Text("واتساب LAN - نهائي", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF075E54))),
          const Text("ناس حقيقيين - نفس الواي فاي - بدون نت", style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 16),
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "اسمك - اكتب المصمم للشارة الزرقاء", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, height: 48, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366)), onPressed: (){ Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage(userName: nameCtrl.text))); }, child: const Text("دخول", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
        ])))));
  }
}

class HomePage extends StatefulWidget { final String userName; const HomePage({super.key, required this.userName}); @override State<HomePage> createState() => _HomeState(); }
class _HomeState extends State<HomePage> {
  String myIp = "جاري جلب IP...";
  List<Map<String,String>> devices = [];
  Map<String, List<Map<String,dynamic>>> chats = {};
  ServerSocket? server;
  RawDatagramSocket? udp;

  @override void initState(){ super.initState(); startLan(); }

  Future<void> startLan() async {
    try {
      var list = await NetworkInterface.list();
      for(var i in list){ for(var a in i.addresses){ if(a.type==InternetAddressType.IPv4 && !a.isLoopback){ setState(()=> myIp = a.address); } } }
      server = await ServerSocket.bind(InternetAddress.anyIPv4, 8888);
      server!.listen((Socket client){
        client.listen((Uint8List data){
          try {
            var s = utf8.decode(data);
            var j = jsonDecode(s);
            var ip = client.remoteAddress.address;
            if(!devices.any((d)=> d['ip']==ip)){ devices.add({'ip': ip, 'name': j['name']}); }
            chats.putIfAbsent(ip, ()=>[]);
            chats[ip]!.add({'text': j['text'], 'isMe': false, 'time': DateTime.now()});
            if(mounted) setState((){});
          } catch(_){}
        });
      });
      udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8889);
      udp!.broadcastEnabled = true;
      udp!.listen((e){ if(e==RawSocketEvent.read){ var d=udp!.receive(); if(d==null) return; try{ var j=jsonDecode(utf8.decode(d.data)); var ip=d.address.address; if(ip!=myIp && !devices.any((x)=> x['ip']==ip)){ setState(()=> devices.add({'ip': ip, 'name': j['name']})); } }catch(_){} } });
      Timer.periodic(const Duration(seconds: 2), (_){ try{ udp!.send(utf8.encode(jsonEncode({'name': widget.userName})), InternetAddress("255.255.255.255"), 8889); }catch(_){} });
    } catch(e){ setState(()=> myIp = "IP: يحتاج جهاز حقيقي"); devices = [{'ip': '192.168.1.5',