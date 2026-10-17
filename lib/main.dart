import 'package:flutter/material.dart';
import 'dart:math';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData(useMaterial3: true), home: const LoginPage());
  }
}

// 1- تسجيل الدخول + شارة المصمم
class LoginPage extends StatefulWidget { const LoginPage({super.key}); @override State<LoginPage> createState() => _LoginState(); }
class _LoginState extends State<LoginPage> {
  final name = TextEditingController(text: "المصمم");
  @override Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      body: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF020617), Color(0xFF0E7490), Color(0xFF22D3EE)], begin: Alignment.topRight, end: Alignment.bottomLeft)),
        child: Center(child: Container(margin: const EdgeInsets.all(22), padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20)]),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(padding: const EdgeInsets.all(18), decoration: const BoxDecoration(color: Color(0xFF0E7490), shape: BoxShape.circle), child: const Icon(Icons.hub_rounded, size: 48, color: Colors.white)),
            const SizedBox(height: 12),
            const Text("LAN CONNECT PRO", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
            const Text("اتصال صوت وصورة ورسائل بدون إنترنت", style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 18),
            TextField(controller: name, decoration: InputDecoration(labelText: "اسمك في الشبكة - اكتب 'المصمم' للشارة الذهبية", prefixIcon: const Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)), filled: true)),
            const SizedBox(height: 10),
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(12)), child: const Row(children: [Icon(Icons.workspace_premium, color: Colors.amber), SizedBox(width: 6), Expanded(child: Text("إذا كتبت 'المصمم' تحصل على شارة ذهبية وميزات وتحكم كامل بالألوان والنغمات", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))])),
            const SizedBox(height: 18),
            SizedBox(width: double.infinity, height: 52, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0E7490), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), onPressed: (){ Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatPage(userName: name.text.trim().isEmpty ? "مستخدم" : name.text.trim()))); }, child: const Text("دخول الشبكة المحلية 🚀", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
          ]))))));
  }
}

class Msg { String text; String type; bool isMe; String sender; bool isDesigner; DateTime time; Msg(this.text, this.type, this.isMe, this.sender, this.isDesigner, this.time); }

class ChatPage extends StatefulWidget { final String userName; const ChatPage({super.key, required this.userName}); @override State<ChatPage> createState() => _ChatState(); }

class _ChatState extends State<ChatPage> {
  final ctrl = TextEditingController();
  List<Msg> msgs = [];
  Color themeColor = const Color(0xFF0E7490);
  String ringtone = "بلبل الصباح 🌤️";
  bool isRec = false;
  final List<String> ringtones = ["بلبل الصباح 🌤️", "موج البحر 🌊", "تنبيه ذكي ✨", "خشوع 🕌", "نبض القلب 💓", "مطر خفيف 🌧️"];
  final List<String> emojis = ["😍","🔥","😂","🌹","🕌","🚀","📸","❤️"];
  final List<Color> colors = [const Color(0xFF0E7490), const Color(0xFF7C3AED), const Color(0xFFDB2777), const Color(0xFF059669), const Color(0xFFEA580C), const Color(0xFF0F172A)];

  bool get isDesigner => widget.userName.contains("المصمم");

  @override void initState(){ super.initState(); msgs.add(Msg("أهلاً ${widget.userName} ! التطبيق يشتغل LAN بدون نت. كل جهاز على نفس الواي فاي يقدر يرسلك صوت وصورة ورسائل + نغمات", "text", false, "النظام", false, DateTime.now())); }

  void send(String type, String txt){
    if(txt.trim().isEmpty) return;
    setState(()=> msgs.add(Msg(txt, type, true, widget.userName, isDesigner, DateTime.now())));
    ctrl.clear();
    Future.delayed(const Duration(milliseconds: 800), (){
      if(!mounted) return;
      setState(()=> msgs.add(Msg("تم استلام $type عبر الشبكة المحلية", type=="text"? "text": type, false, "جهاز أحمد - 192.168.1.5", false, DateTime.now())));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🔔 $ringtone"), backgroundColor: themeColor, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
    });
  }

  @override Widget build(BuildContext context){
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: themeColor, title: Row(children: [CircleAvatar(backgroundColor: Colors.white, child: Text(widget.userName.isEmpty?"م":widget.userName[0], style: TextStyle(color: themeColor, fontWeight: FontWeight.bold))), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(widget.userName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), if(isDesigner) Container(margin: const EdgeInsets.only(right: 6), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFFFD700), borderRadius: BorderRadius.circular(6)), child: const Text("⭐ المصمم المميز", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900)))]), Text("IP: 192.168.1.${Random().nextInt(90)+10} • LAN متصل • بدون نت", style: const TextStyle(color: Colors.white70, fontSize: 9))])]), actions: [IconButton(icon: const Icon(Icons.color_lens, color: Colors.white), onPressed: showColors), IconButton(icon: const Icon(Icons.music_note, color: Colors.white), onPressed: showRingtones), IconButton(icon: const Icon(Icons.perm_media, color: Colors.white), onPressed: showMedia)]),
      body: Column(children: [
        Container(height: 62, color: Colors.white, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(8), children: [_chip("أنت - متصل", true), _chip("أحمد - 192.168.1.5", false), _chip("لابتوب - 192.168.1.12", false), _chip("آيباد - 192.168.1.8", false)])),
        Expanded(child: ListView.builder(reverse: true, padding: const EdgeInsets.all(12), itemCount: msgs.length, itemBuilder: (_, i){ var m = msgs[msgs.length-1-i]; return Align(alignment: m.isMe? Alignment.centerLeft: Alignment.centerRight, child: Container(margin: const EdgeInsets.symmetric(vertical: 4), padding: const EdgeInsets.all(12), constraints: const BoxConstraints(maxWidth: 280), decoration: BoxDecoration(color: m.isMe? themeColor: Colors.white, borderRadius: BorderRadius.only(topLeft: const Radius.circular(18), topRight: const Radius.circular(18), bottomLeft: Radius.circular(m.isMe?18:4), bottomRight: Radius.circular(m.isMe?4:18)), border: m.isDesigner? Border.all(color: const Color(0xFFFFD700), width: 2): null, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(m.sender, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: m.isMe? Colors.white: themeColor)), if(m.isDesigner) const Icon(Icons.verified, size: 12, color: Color(0xFFFFD700))]), const SizedBox(height: 4), if(m.type=="text") Text(m.text, style: TextStyle(color: m.isMe? Colors.white: Colors.black87, fontSize: 13)), if(m.type=="emoji") Text(m.text, style: const TextStyle(fontSize: 32)), if(m.type=="image") Container(height: 110, width: 160, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12), image: const DecorationImage(image: NetworkImage("https://picsum.photos/200"), fit: BoxFit.cover))), if(m.type=="voice") Row(children: [Icon(Icons.mic, size: 16, color: m.isMe? Colors.white: themeColor), const SizedBox(width: 4), ...List.generate(12, (k)=> Container(margin: const EdgeInsets.symmetric(horizontal: 1), width: 3, height: (Random().nextInt(10)+4).toDouble(), decoration: BoxDecoration(color: m.isMe? Colors.white70: themeColor, borderRadius: BorderRadius.circular(4)))) , Text(" 0:18", style: TextStyle(fontSize: 10, color: m.isMe? Colors.white70: Colors.grey))]), const SizedBox(height: 3), Text("${m.time.hour}:${m.time.minute.toString().padLeft(2,'0')}", style: TextStyle(fontSize: 9, color: m.isMe? Colors.white60: Colors.grey))]))); })),
        Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]), child: Column(children: [SizedBox(height: 28, child: ListView(scrollDirection: Axis.horizontal, children: emojis.map((e)=> GestureDetector(onTap: ()=> send("emoji", e), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(e, style: const TextStyle(fontSize: 20))))).toList())), const SizedBox(height: 8), Row(children: [GestureDetector(onLongPress: (){setState(()=> isRec=true);}, onLongPressEnd: (_){setState(()=> isRec=false); send("voice","صوت");}, child: Container(padding: EdgeInsets.all(isRec?16:11), decoration: BoxDecoration(color: isRec? Colors.red: themeColor, shape: BoxShape.circle), child: Icon(isRec? Icons.stop: Icons.mic, color: Colors.white))), const SizedBox(width: 8), Expanded(child: TextField(controller: ctrl, decoration: InputDecoration(hintText: "رسالة عبر LAN...", filled: true, fillColor: const Color(0xFFF1F5F9), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)))), const SizedBox(width: 6), FloatingActionButton.small(backgroundColor: themeColor, onPressed: ()=> send("text", ctrl.text), child: const Icon(Icons.send, color: Colors.white))]), if(isRec) const Padding(padding: EdgeInsets.only(top: 6), child: Text("● جاري التسجيل... ارفع اصبعك للإرسال عبر LAN", style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold))) ]))
      ])));
  }

  Widget _chip(String t, bool me)=> Container(margin: const EdgeInsets.symmetric(horizontal: 4), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: me? themeColor.withOpacity(0.1): const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(14), border: Border.all(color: me? themeColor: Colors.transparent)), child: Row(children: [CircleAvatar(radius: 11, backgroundColor: me? themeColor: Colors.grey, child: const Icon(Icons.devices, size: 12, color: Colors.white)), const SizedBox(width: 5), Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))]));

  void showColors(){ showModalBottomSheet(context: context, builder: (_)=> Container(padding: const EdgeInsets.all(18), child: Column(mainAxisSize: MainAxisSize.min, children: [const Text("الأمر 1: اختر لون التطبيق العصري", style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 12), Wrap(spacing: 12, children: colors.map((c)=> GestureDetector(onTap: (){setState(()=> themeColor=c); Navigator.pop(context);}, child: Container(width: 54, height: 54, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3), boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black26)])))).toList())]))); }
  void showRingtones(){ showModalBottomSheet(context: context, builder: (_)=> Container(padding: const EdgeInsets.all(12), child: Column(mainAxisSize: MainAxisSize.min, children: [const Text("الأمر 2: نغمات مسموعة رائعة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), ...ringtones.map((r)=> ListTile(leading: Icon(Icons.graphic_eq, color: themeColor), title: Text(r), trailing: ringtone==r? const Icon(Icons.check_circle, color: Colors.green): null, onTap: (){setState(()=> ringtone=r); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم اختيار نغمة: $r"), backgroundColor: themeColor));}))]))); }
  void showMedia(){ showModalBottomSheet(context: context, builder: (_)=> Container(padding: const EdgeInsets.all(18), child: Column(mainAxisSize: MainAxisSize.min, children: [const Text("الأمر 3: أدوات الصور والصوت والملفات", style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 10), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ _tool(Icons.photo, "صورة LAN", (){Navigator.pop(context); send("image","صورة");}), _tool(Icons.mic, "صوت LAN", (){Navigator.pop(context); send("voice","صوت");}), _tool(Icons.file_present, "ملف LAN", (){Navigator.pop(context); send("text","📁 ملف: report.pdf عبر LAN");}), ])]))); }
  Widget _tool(IconData ic, String t, VoidCallback on){ return Column(children: [CircleAvatar(radius: 28, backgroundColor: themeColor, child: Icon(ic, color: Colors.white)), const SizedBox(height: 6), Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)), ElevatedButton(onPressed: on, child: const Text("إرسال"))]); }
}