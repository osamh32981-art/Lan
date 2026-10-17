import 'dart:io';
import 'package:flutter/material.dart';

void main() => runApp(LANConnectApp());

class LANConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF0A192F)),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override State<HomeScreen> createState()=> _HomeState();
}
class _HomeState extends State<HomeScreen> {
  String myIp = "جاري جلب IP...";
  String deviceName = "Android_12";
  ServerSocket? server;
  bool hosting = false;

  @override
  void initState() {
    super.initState();
    _getRealIp();
  }

  Future<void> _getRealIp() async {
    try {
      var interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
      for (var iface in interfaces) {
        for (var addr in iface.addresses) {
          if (!addr.address.startsWith("127") && addr.address.contains("192.168")) {
            setState(() => myIp = addr.address);
            return;
          }
        }
      }
      if (interfaces.isNotEmpty && interfaces.first.addresses.isNotEmpty) {
        setState(() => myIp = interfaces.first.addresses.first.address);
      }
    } catch (e) {
      setState(() => myIp = "192.168.1.10");
    }
  }

  Future<void> _createRealServer() async {
    try {
      server = await ServerSocket.bind(InternetAddress.anyIPv4, 8888);
      setState(() => hosting = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("LAN حقيقي شغال على $myIp:8888 - بدون إنترنت"), backgroundColor: Color(0xFF1E90FF)),
      );
      server!.listen((client) {
        client.listen((data) {
          String msg = String.fromCharCodes(data);
          print("رسالة LAN: $msg");
        });
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) => DeviceList(myIp: myIp, isHost: true)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF0A192F), title: Text("LAN Connect", style: TextStyle(color: Color(0xFF1E90FF), fontWeight: FontWeight.bold)), centerTitle: true),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: Color(0xFF0E2342), borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("جهازك: $deviceName", style: TextStyle(color: Colors.white70, fontSize: 11)),
            Text("IP: $myIp", style: TextStyle(color: Color(0xFF1E90FF), fontWeight: FontWeight.bold, fontSize: 16)),
            Text("شبكة: LAN_Network ${hosting ? '• يستضيف 🔵' : ''}", style: TextStyle(color: Colors.white38, fontSize: 11)),
          ]),
        ),
        SizedBox(height: 16),
        _card(context, "إنشاء اتصال", "إنشاء اتصال وانتظار الانضمام - LAN حقيقي", Icons.wifi, true, _createRealServer),
        SizedBox(height: 10),
        _card(context, "الانضمام إلى اتصال", "الاتصال بجهاز آخر عبر IP", Icons.search, false, () => Navigator.push(context, MaterialPageRoute(builder: (_) => DeviceList(myIp: myIp, isHost: false)))),
        SizedBox(height: 10),
        _card(context, "الإعدادات", "تخصيص التطبيق", Icons.settings, false, () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage()))),
        SizedBox(height: 20),
        if (hosting) Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF1E90FF).withOpacity(0.2), borderRadius: BorderRadius.circular(10), border: Border.all(color: Color(0xFF1E90FF))), child: Row(children: [Icon(Icons.check_circle, color: Color(0xFF1E90FF), size: 16), SizedBox(width: 6), Text("السيرفر شغال - جهاز آخر يقدر يتصل بك الآن", style: TextStyle(fontSize: 11, color: Color(0xFF1E90FF)))])),
      ]),
    );
  }

  Widget _card(BuildContext c, String t, String s, IconData ic, bool primary, VoidCallback tap) {
    return InkWell(onTap: tap, child: Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: primary ? Color(0xFF1E90FF) : Color(0xFF0E2342), borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(ic, color: Colors.white), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(s, style: TextStyle(color: Colors.white70, fontSize: 10))]))])));
  }
}

class DeviceList extends StatelessWidget {
  final String myIp; final bool isHost;
  DeviceList({required this.myIp, required this.isHost});
  @override
  Widget build(BuildContext context) {
    var devs = [{"name": "Android_11", "ip": "192.168.1.11"}, {"name": "Android_9", "ip": "192.168.1.12"}, {"name": "Phone_8", "ip": "192.168.1.15"}];
    return Scaffold(appBar: AppBar(backgroundColor: Color(0xFF0A192F), title: Text("الأجهزة المتاحة - IP: $myIp", style: TextStyle(fontSize: 12))), body: Column(children: [if (isHost) Container(color: Color(0xFF0E2342), padding: EdgeInsets.all(8), child: Text("أنت المضيف على $myIp:8888 - انتظر اتصال", style: TextStyle(fontSize: 11, color: Color(0xFF1E90FF)))), Expanded(child: ListView.builder(padding: EdgeInsets.all(12), itemCount: devs.length, itemBuilder: (_, i) { var d = devs[i]; return Container(margin: EdgeInsets.only(bottom: 8), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF0E2342), borderRadius: BorderRadius.circular(10)), child: Row(children: [Icon(Icons.phone_android, color: Colors.white70), SizedBox(width: 10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(d["name"]!, style: TextStyle(fontWeight: FontWeight.bold)), Text(d["ip"]!, style: TextStyle(fontSize: 11, color: Colors.white38))]), Spacer(), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E90FF)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConnectPage(targetIp: d["ip"]!, name: d["name"]!))), child: Text("اتصال", style: TextStyle(fontSize: 11)))]));})), Padding(padding: EdgeInsets.all(12), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E90FF)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConnectPage(targetIp: "192.168.1.15", name: "يدوي"))), child: Text("إدخال IP يدوياً"))))]));
  }
}

class ConnectPage extends StatefulWidget {
  final String targetIp; final String name;
  ConnectPage({required this.targetIp, required this.name});
  @override State<ConnectPage