import 'package:flutter/material.dart';

void main() => runApp(LANConnectApp());

class LANConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF0A192F),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF07132E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Color(0xFF0E2342),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Color(0xFF1E90FF)),
              ),
              child: Icon(Icons.wifi, size: 55, color: Color(0xFF1E90FF)),
            ),
            SizedBox(height: 14),
            Text("LAN Connect",
                style: TextStyle(
                    color: Color(0xFF1E90FF),
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            Text("اتصال صوت وصورة عبر شبكة LAN",
                style: TextStyle(color: Colors.white70, fontSize: 11)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: Color(0xFF0E2342),
                  borderRadius: BorderRadius.circular(20)),
              child: Text("بدون إنترنت",
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            )
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A192F),
        title: Text("LAN Connect",
            style: TextStyle(
                color: Color(0xFF1E90FF), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Color(0xFF0E2342),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("جهازك: Android_12",
                    style: TextStyle(color: Colors.white70, fontSize: 11)),
                Text("IP: 192.168.1.10",
                    style: TextStyle(
                        color: Color(0xFF1E90FF), fontWeight: FontWeight.bold)),
                Text("شبكة: LAN_Network",
                    style: TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          SizedBox(height: 16),
          _card(context, "إنشاء اتصال", "إنشاء اتصال وانتظار الانضمام",
              Icons.wifi, true),
          SizedBox(height: 10),
          _card(context, "الانضمام إلى اتصال", "الاتصال بجهاز آخر",
              Icons.search, false),
          SizedBox(height: 10),
          _card(context, "الإعدادات", "تخصيص التطبيق", Icons.settings, false),
        ],
      ),
    );
  }

  Widget _card(BuildContext c, String t, String s, IconData ic, bool primary) {
    return InkWell(
      onTap: () {
        if (t.contains("إنشاء")) {
          Navigator.push(
              c, MaterialPageRoute(builder: (_) => DeviceList(ip: "192.168.1.10")));
        } else if (t.contains("الانضمام")) {
          Navigator.push(
              c, MaterialPageRoute(builder: (_) => DeviceList(ip: "192.168.1.11")));
        } else {
          Navigator.push(
              c, MaterialPageRoute(builder: (_) => SettingsPage()));
        }
      },
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: primary ? Color(0xFF1E90FF) : Color(0xFF0E2342),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(ic, color: Colors.white),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text(s,
                    style: TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DeviceList extends StatelessWidget {
  final String ip;
  DeviceList({required this.ip});
  @override
  Widget build(BuildContext context) {
    var devs = [
      {"name": "Android_11", "ip": "192.168.1.11"},
      {"name": "Android_9", "ip": "192.168.1.12"},
      {"name": "Phone_8", "ip": "192.168.1.15"},
    ];
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF0A192F),
          title: Text("الأجهزة المتاحة", style: TextStyle(fontSize: 14))),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: devs.length,
        itemBuilder: (_, i) {
          var d = devs[i];
          return Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Color(0xFF0E2342),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Icon(Icons.phone_android, color: Colors.white70),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d["name"]!,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(d["ip"]!,
                        style:
                            TextStyle(fontSize: 11, color: Colors.white38)),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E90FF)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CallScreen(
                                name: d["name"]!, ip: d["ip"]!)));
                  },
                  child: Text("اتصال", style: TextStyle(fontSize: 11)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class CallScreen extends StatelessWidget {
  final String name;
  final String ip;
  CallScreen({required this.name, required this.ip});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF07132E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFF0E2342),
                child: Text(name[0],
                    style: TextStyle(fontSize: 40, color: Colors.white))),
            SizedBox(height: 12),
            Text(name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text("$ip • 00:02:35",
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    backgroundColor: Colors.white12,
                    child: Icon(Icons.mic_off, color: Colors.white)),
                SizedBox(width: 20),
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 28,
                  child: IconButton(
                      icon: Icon(Icons.call_end, color: Colors.white),
                      onPressed: () => Navigator.pop(context)),
                ),
                SizedBox(width: 20),
                CircleAvatar(
                    backgroundColor: Colors.white12,
                    child: Icon(Icons.volume_up, color: Colors.white)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF0A192F), title: Text("الإعدادات")),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          ListTile(title: Text("جودة الفيديو (720p)"), leading: Icon(Icons.videocam)),
          ListTile(
              title: Text("الوضع الداكن"),
              trailing: Switch(
                  value: true,
                  onChanged: (_) {},
                  activeColor: Color(0xFF1E90FF))),
          ListTile(
              title: Text("حول التطبيق"),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AboutPage()))),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF0A192F), title: Text("حول")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi, size: 50, color: Color(0xFF1E90FF)),
            Text("LAN Connect 1.0.0",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("بدون إنترنت - يعمل عبر شبكة LAN",
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}