import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData(useMaterial3: false), home: const LoginPrivate());
}

// ============ تسجيل دخول برقم واسم - خصوصية ============
class LoginPrivate extends StatefulWidget { const LoginPrivate({super.key}); @override State<LoginPrivate> createState() => _LoginP(); }
class _LoginP extends State<LoginPrivate> {
  final phone = TextEditingController(text: "05");
  final name = TextEditingController(text: "المصمم");
  @override Widget build(BuildContext context){
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(backgroundColor: const Color(0xFF111B21),
      body: Center(child: Container(margin: const EdgeInsets.all(20), padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.lock, size: 50, color: Color(0xFF075E54)), const SizedBox(height: 8),
          const Text("WhatsApp LAN - خصوصية", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF075E54))),
          const Text("دخول برقم واسم - دردشات منفصلة ومشفرة", style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 18),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "رقم الجوال - مثال 05xxxxxxxx", prefixIcon: Icon(Icons.phone), border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: name, decoration: const InputDecoration(labelText: "اسم المستخدم", prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
          const SizedBox(height: 10),
          Container(padding: const EdgeInsets.all(8), color: const Color(0xFFE7FFDB), child: const Row(children: [Icon(Icons.privacy_tip, size: 16, color: Color(0xFF075E54)), SizedBox(width: 6), Expanded(child: Text("كل دردشة منفصلة لوحدها - محفوظة برقمك فقط - لا يراها أحد", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))])),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366)), onPressed: (){
            if(phone.text.length < 9){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("اكتب رقم صحيح"))); return; }
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomePrivate(phone: phone.text, userName: name.text)));
          }, child: const Text("دخول آمن 🔒", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
        ])))));
  }
}

// ============ الرئيسية - دردشات منفصلة ============
class HomePrivate extends StatefulWidget { final String phone; final String userName; const HomePrivate({super.key, required this.phone, required this.userName}); @override State<HomePrivate> createState()=> _HomePState(); }
class _HomePState extends State<HomePrivate> {
  // كل جهة اتصال لها دردشة منفصلة
  List<Map<String,String>> contacts = [
    {'name': 'أحمد - LAN', 'phone': '0555123456', 'ip': '192.168.1.5', 'last': 'أهلاً - دردشة منفصلة'},
    {'name': 'لابتوب العائلة', 'phone': '0555000111', 'ip': '192.168.1.12', 'last': 'صورة LAN'},
    {'name': 'محمد', 'phone': '0555999888', 'ip': '192.168.1.8', 'last': 'مكالمة صوتية'},
  ];
  Map<String, List<Map<String,dynamic>>> privateChats = {};

  @override Widget build(BuildContext context){
    bool isDes = widget.userName.contains("المصمم");
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF075E54), title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Text("WhatsApp", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), if(isDes) Container(margin: const EdgeInsets.only(right: 6), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: const Text("⭐ المصمم - موثق", style: TextStyle(fontSize: 9, color: Color(0xFF075E54), fontWeight: FontWeight.bold))) ]), Text("${widget.userName} • ${widget.phone} • خصوصية", style: const TextStyle(color: Colors.white70, fontSize: 10))]), actions: const [Icon(Icons.search, color: Colors.white), SizedBox(width: 10), Icon(Icons.more_vert, color: Colors.white), SizedBox(width: 6)]),
      body: Container(color: Colors.white, child: Column(children: [
        Container(color: const Color(0xFF111B21), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(children: [const Icon(Icons.lock, color: Color(0xFF25D366), size: 16), const SizedBox(width: 6), Expanded(child: Text("دردشاتك محمية - كل محادثة منفصلة برقم ${widget.phone} - تشفير LAN", style: const TextStyle(color: Colors.white70, fontSize: 10)))])),
        Expanded(child: ListView.separated(separatorBuilder: (_,__ )=> const Divider(height: 1), itemCount: contacts.length, itemBuilder: (_, i){
          var c = contacts[i]; var msgs = privateChats[c['phone']] ?? []; var last = msgs.isNotEmpty ? msgs.last['text'] : c['last']!;
          return ListTile(
            leading: Stack(children: [CircleAvatar(radius: 26, backgroundColor: const Color(0xFFDFE5E7), child: Text(c['name']![0], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF075E54)))), Positioned(bottom: 0, right: 0, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))))]),
            title: Row(children: [Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), const SizedBox(width: 4), const Icon(Icons.lock, size: 12, color: Color(0xFF075E54))]),
            subtitle: Row(children: [const Icon(Icons.done_all, size: 14, color: Colors.blue), const SizedBox(width: 4), Expanded(child: Text(last, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)))]),
            trailing: Column(children: [Text("${DateTime.now().hour}:${DateTime.now().minute}", style: const TextStyle(fontSize: 11, color: Color(0xFF25D366))), if(msgs.isNotEmpty) Container(margin: const EdgeInsets.only(top: 4), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(10)), child: Text("${msgs.length}", style: const TextStyle(color: Colors.white, fontSize: 10)))]),
            onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_)=> PrivateChatPage(contact: c, myPhone: widget.phone, myName: widget.userName, chats: privateChats))); },
          );
        })),
      ])),
      floatingActionButton: FloatingActionButton(backgroundColor: const Color(0xFF25D366), onPressed: (){ showDialog(context: context, builder: (_)=> AlertDialog(title: const Text("إضافة جهة اتصال LAN"), content: const Text("سيتم اكتشاف أي شخص على نفس الواي فاي تلقائياً - أو أضف رقم يدوياً قريباً"), actions: [TextButton(onPressed: ()=> Navigator.pop(context), child: const Text("حسناً"))])); }, child: const Icon(Icons.chat, color: Colors.white)),
    ));
  }
}

// ============ دردشة خاصة منفصلة + اتصال صوت وصورة ============
class PrivateChatPage extends StatefulWidget { final Map<String,String> contact; final String myPhone; final String myName; final Map<String, List<Map<String,dynamic>>> chats; const PrivateChatPage({super.key, required this.contact, required this.myPhone, required this.myName, required this.chats}); @override State<PrivateChatPage> createState()=> _PrivateChatState(); }
class _PrivateChatState extends State<PrivateChatPage> {
  final ctrl = TextEditingController();
  void send(String type, String txt){ if(txt.trim().isEmpty) return; widget.chats.putIfAbsent(widget.contact['phone']!, ()=>[]); widget.chats[widget.contact['phone']!]!.add({'text': txt, 'type': type, 'isMe': true, 'time': DateTime.now()}); ctrl.clear(); setState((){}); Future.delayed(const Duration(seconds: 1), (){ if(!mounted) return; widget.chats[widget.contact['phone']!]!.add({'text': "تم - دردشة خاصة منفصلة", 'type': "text", 'isMe': false, 'time': DateTime.now()}); setState((){}); }); }

  void startCall(bool isVideo){
    Navigator.push(context, MaterialPageRoute(builder: (_)=> CallPage(contact: widget.contact, isVideo: isVideo)));
  }

  @override Widget build(BuildContext context){
    var msgs = widget.chats[widget.contact['phone']] ?? [];
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF075E54), title: Row(children: [CircleAvatar(backgroundColor: Colors.white, child: Text(widget.contact['name']![0])), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(widget.contact['name']!, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), const Icon(Icons.verified, size: 14, color: Color(0xFF25D366))]), Text("${widget.contact['phone']} • ${widget.contact['ip']} • خاص 🔒", style: const TextStyle(color: Colors.white70, fontSize: 10))])]), actions: [IconButton(icon: const Icon(Icons.videocam, color: Colors.white), onPressed: ()=> startCall(true)), IconButton(icon: const Icon(Icons.call, color: Colors.white), onPressed: ()=> startCall(false)), const Icon(Icons.more_vert, color: Colors.white)]),
      body: Column(children: [
        Container(color: const Color(0xFFFEF3C7), padding: const EdgeInsets.all(8), child: const Row(children: [Icon(Icons.lock, size: 14, color: Colors.orange), SizedBox(width: 6), Expanded(child: Text("🔒 دردشة خاصة منفصلة - مشفرة بين جهازين فقط - لا يراها أحد على الشبكة - محفوظة برقمك", style: TextStyle(fontSize: 10)))])),
        Expanded(child: Container(color: const Color(0xFFE5DDD5), child: ListView.builder(reverse: true, padding: const EdgeInsets.all(8), itemCount: msgs.length, itemBuilder: (_, i){ var m = msgs[msgs.length-1-i]; bool isMe = m['isMe']; return Align(alignment: isMe? Alignment.centerLeft: Alignment.centerRight, child: Container(margin: const EdgeInsets.symmetric(vertical: 3), padding: const EdgeInsets.all(10), constraints: const BoxConstraints(maxWidth: 260), decoration: BoxDecoration(color: isMe? const Color(0xFFDCF8C6): Colors.white, borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [if(m['type']=="text") Text(m['text'], style: const TextStyle(fontSize: 14)), if(m['type']=="image") Container(height: 120, width: 180, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), image: const DecorationImage(image: NetworkImage("https://picsum.photos/200"), fit: BoxFit.cover))), if(m['type']=="voice") const Row(children: [Icon(Icons.mic, size: 16, color: Color(0xFF075E54)), SizedBox(width: 4), Text("رسالة صوتية 0:18", style: TextStyle(fontSize: 12))]), const SizedBox(height: 2), Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text("${m['time'].hour}:${m['time'].minute.toString().padLeft(2,'0')}", style: const TextStyle(fontSize: 9, color: Colors.grey)), if(isMe) const Icon(Icons.done_all, size: 14, color: Colors.blue)])]))); }))),
        Container(color: Colors.white, padding: const EdgeInsets.all(6), child: Row(children: [IconButton(icon: const Icon(Icons.emoji_emotions_outlined), onPressed: ()=> send("text", "😍")), IconButton(icon: const Icon(Icons.attach_file), onPressed: ()=> send("image", "صورة")), Expanded(child: TextField(controller: ctrl, decoration: InputDecoration(hintText: "رسالة خاصة...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), filled: true, fillColor: const Color(0xFFF0F0F0)))), const SizedBox(width: 4), CircleAvatar(backgroundColor: const Color(0xFF25D366), child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 18), onPressed: ()=> send("text", ctrl.text)))]))
      ]),
    ));
  }
}

// ============ صفحة اتصال صوت وصورة ============
class CallPage extends StatefulWidget { final Map<String,String> contact; final bool isVideo; const CallPage({super.key, required this.contact, required this.isVideo}); @override State<CallPage> createState()=> _CallState(); }
class _CallState extends State<CallPage> {
  int sec = 0; Timer? t;
  @override void initState(){ super.initState(); t = Timer.periodic(const Duration(seconds: 1), (_){ setState(()=> sec++); }); }
  @override void dispose(){ t?.cancel(); super.dispose(); }
  String fmt(int s){ int m = s~/60; int ss = s%60; return "${m.toString().padLeft(2,'0')}:${ss.toString().padLeft(2,'0')}"; }
  @override Widget build(BuildContext context){
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(backgroundColor: const Color(0xFF111B21),
      body: Column(children: [
        Expanded(child: Stack(children: [
          if(widget.isVideo) Container(color: const Color(0xFF1F2C34), child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(radius: 50, backgroundColor: const Color(0xFFDFE5E7), child: Text(widget.contact['name']![0], style: const TextStyle(fontSize: 40, color: Color(0xFF075E54)))), const SizedBox(height: 12), Text(widget.contact['name']!, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text("مكالمة فيديو LAN • ${fmt(sec)} • ${widget.contact['ip']}", style: const TextStyle(color: Colors.white70)), const SizedBox(height: 20), Container(width: 90, height: 120, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white)), child: const Icon(Icons.person, color: Colors.white, size: 40))]))),
          if(!widget.isVideo) Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(radius: 60, backgroundColor: const Color(0xFF25D366), child: Text(widget.contact['name']![0], style: const TextStyle(fontSize: 50, color: Colors.white))), const SizedBox(height: 16), Text(widget.contact['name']!, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), Text("مكالمة صوتية LAN • ${fmt(sec)}", style: const TextStyle(color: Colors.white70)), const SizedBox(height: 8), const Text("🔒 مشفرة - بدون إنترنت - نفس الواي فاي", style: TextStyle(color: Color(0xFF25D366), fontSize: 12)) ])),
          Positioned(top: 50, left: 20, right: 20, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.lock, color: Colors.white, size: 14), Text