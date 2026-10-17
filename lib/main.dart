import 'dart:io';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner:false, theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF0A192F)), home: Home()));

class Home extends StatefulWidget{ @override State<Home> createState()=>_HomeS(); }
class _HomeS extends State<Home>{
  String myIp="جاري جلب IP...";
  @override void initState(){super.initState(); _getIp();}
  
  Future<void> _getIp() async {
    try{
      var ifs = await NetworkInterface.list(type: InternetAddressType.IPv4);
      for(var f in ifs){
        for(var a in f.addresses){
          if(!a.address.startsWith("127") && a.address.startsWith("192.168")){
            setState(()=> myIp=a.address);
            return;
          }
        }
      }
      setState(()=> myIp=ifs.first.addresses.first.address);
    }catch(e){ setState(()=> myIp="192.168.1.10"); }
  }

  @override Widget build(BuildContext c){
    return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF0A192F), title: Text("LAN Connect", style: TextStyle(color: Color(0xFF1E90FF), fontWeight: FontWeight.bold)), centerTitle:true),
      body: ListView(padding: EdgeInsets.all(16), children:[
        Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF0E2342), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
          Text("جهازك الحقيقي", style: TextStyle(color: Colors.white38, fontSize:10)),
          Text("IP: $myIp", style: TextStyle(color: Color(0xFF1E90FF), fontWeight: FontWeight.bold, fontSize:18)),
          Text("المنفذ: 8888 - شغال بدون إنترنت", style: TextStyle(color: Colors.white70, fontSize:11)),
        ])),
        SizedBox(height:16),
        _btn(c, "إنشاء اتصال (كن سيرفر)", "افتح سيرفر حقيقي على $myIp", Icons.wifi, true, ()=> Navigator.push(c, MaterialPageRoute(builder: (_)=> HostPage(myIp: myIp)))),
        SizedBox(height:10),
        _btn(c, "الانضمام إلى اتصال", "اتصل بجهاز ثاني عبر IP", Icons.search, false, ()=> Navigator.push(c, MaterialPageRoute(builder: (_)=> JoinPage()))),
      ]));
  }
  Widget _btn(BuildContext c, String t, String s, IconData ic, bool p, VoidCallback tap)=> InkWell(onTap:tap, child: Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: p?Color(0xFF1E90FF):Color(0xFF0E2342), borderRadius: BorderRadius.circular(12)), child: Row(children:[Icon(ic, color: Colors.white), SizedBox(width:12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(t, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(s, style: TextStyle(color: Colors.white70, fontSize:10))]))])));
}

// صفحة المضيف - تفتح سيرفر حقيقي
class HostPage extends StatefulWidget{ final String myIp; HostPage({required this.myIp}); @override State<HostPage> createState()=>_HostS(); }
class _HostS extends State<HostPage>{
  ServerSocket? server;
  List<Socket> clients=[];
  List<String> logs=["السيرفر يبدأ على ${''}..."];
  String msg="";

  @override void initState(){super.initState(); _startServer();}

  Future<void> _startServer() async {
    try{
      server = await ServerSocket.bind(InternetAddress.anyIPv4, 8888);
      setState(()=> logs.add("✅ سيرفر LAN حقيقي شغال على ${widget.myIp}:8888"));
      setState(()=> logs.add("انتظر جهاز ثاني يتصل..."));
      server!.listen((client){
        setState((){
          clients.add(client);
          logs.add("📱 جهاز اتصل: ${client.remoteAddress.address}");
        });
        client.listen((data){
          String txt = String.fromCharCodes(data);
          setState(()=> logs.add("📩 من العميل: $txt"));
          // ارسل للكل
          for(var c in clients){ if(c!=client) c.write(txt); }
        }, onDone: (){
          setState(()=> logs.add("❌ جهاز فصل"));
        });
      });
    }catch(e){
      setState(()=> logs.add("❌ خطأ: $e"));
    }
  }

  @override void dispose(){ server?.close(); for(var c in clients) c.close(); super.dispose(); }

  @override Widget build(BuildContext c){
    return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF0A192F), title: Text("أنت السيرفر - ${widget.myIp}:8888")),
      body: Column(children:[
        Container(width:double.infinity, color: Color(0xFF0E2342), padding: EdgeInsets.all(8), child: Text("أعط هذا IP للجهاز الثاني: ${widget.myIp}", style: TextStyle(color: Color(0xFF1E90FF), fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        Expanded(child: ListView.builder(padding: EdgeInsets.all(8), itemCount: logs.length, itemBuilder: (_,i)=> Container(margin: EdgeInsets.only(bottom:4), padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xFF0E2342), borderRadius: BorderRadius.circular(6)), child: Text(logs[i], style: TextStyle(fontSize:12))))),
        Padding(padding: EdgeInsets.all(8), child: Row(children:[Expanded(child: TextField(onChanged: (v)=> msg=v, decoration: InputDecoration(hintText: "ارسل للكل...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), filled:true, fillColor: Color(0xFF0E2342)))), SizedBox(width:6), FloatingActionButton.small(backgroundColor: Color(0xFF1E90FF), onPressed: (){ for(var cl in clients) cl.write(msg); setState(()=> logs.add("أنت: $msg")); }, child: Icon(Icons.send))]))
      ]));
  }
}

// صفحة العميل - يتصل