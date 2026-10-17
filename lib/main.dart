import 'dart:async';
import 'package:flutter/material.dart';
void main(){runApp(MyApp());}
class MyApp extends StatelessWidget{
  @override Widget build(BuildContext c){return MaterialApp(debugShowCheckedModeBanner: false, home: Login());}
}
class Login extends StatelessWidget{
  final p = TextEditingController(text:"05");
  final n = TextEditingController(text:"المصمم");
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: Color(0xFF111B21),
      body: Center(child: Container(margin: EdgeInsets.all(20), padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lock,size: 50,color: Color(0xFF075E54)),
          Text("WhatsApp LAN",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold,color: Color(0xFF075E54))),
          Text("رقم + اسم - كل دردشة منفصلة - خصوصية",style: TextStyle(fontSize:11,color: Colors.grey)),
          SizedBox(height:12),
          TextField(controller: p,decoration: InputDecoration(labelText:"رقم الجوال",border: OutlineInputBorder(),prefixIcon: Icon(Icons.phone))),
          SizedBox(height:8),
          TextField(controller: n,decoration: InputDecoration(labelText:"اسم المستخدم",border: OutlineInputBorder(),prefixIcon: Icon(Icons.person))),
          SizedBox(height:12),
          SizedBox(width: double.infinity,height: 48,child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF25D366)),onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Home(phone:p.text,name:n.text)));},child: Text("دخول آمن 🔒",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))))
        ]))));
  }
}
class Home extends StatelessWidget{
  final String phone; final String name;
  Home({required this.phone,required this.name});
  @override Widget build(BuildContext context){
    var users = [
      {'name':'أحمد','phone':'0555123456','msg':'أهلاً - دردشة خاصة منفصلة 🔒'},
      {'name':'محمد','phone':'0555987654','msg':'📸 صورة LAN'},
      {'name':'لابتوب العائلة','phone':'0555000111','msg':'🎤 مكالمة صوتية'},
    ];
    bool isDes = name.contains("المصمم");
    return Directionality(textDirection: TextDirection.rtl,child: Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF075E54),title: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Row(children: [Text("WhatsApp",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),if(isDes)Container(margin: EdgeInsets.only(right:6),padding: EdgeInsets.symmetric(horizontal:6,vertical:2),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(8)),child: Text("المصمم ⭐",style: TextStyle(fontSize:9,color: Color(0xFF075E54))))]),Text("$name • $phone",style: TextStyle(color: Colors.white70,fontSize:11)) ])),
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(color: Color(0xFF111B21),padding: EdgeInsets.all(8),child: Row(children: [Icon(Icons.lock,color: Color(0xFF25D366),size:14),SizedBox(width:6),Expanded(child: Text("كل دردشة منفصلة لوحدها برقمك - لا يراها أحد - مشفرة",style: TextStyle(color: Colors.white70,fontSize:10))) ])),
        Expanded(child: ListView.separated(separatorBuilder: (_,__)=>Divider(height:1),itemCount: users.length,itemBuilder: (_,i){var u=users[i];return ListTile(leading: CircleAvatar(backgroundColor: Color(0xFFDFE5E7),child: Text(u['name']![0])),title: Row(children: [Text(u['name']!,style: TextStyle(fontWeight: FontWeight.bold)),SizedBox(width:4),Icon(Icons.lock,size:12,color: Color(0xFF075E54))]),subtitle: Text(u['msg']!),trailing: Text("12:30",style: TextStyle(fontSize:11,color: Color(0xFF25D366))),onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatPage(contact:u,myPhone:phone)));});}))
      ]),
      floatingActionButton: FloatingActionButton(backgroundColor: Color(0xFF25D366),onPressed: (){},child: Icon(Icons.chat,color: Colors.white)),
    ));
  }
}
class ChatPage extends StatefulWidget{final Map<String,String> contact; final String myPhone; ChatPage({required this.contact,required this.myPhone}); @override State<ChatPage> createState()=>_ChatS();}
class _ChatS extends State<ChatPage>{
  final ctrl=TextEditingController(); List<Map<String,String>> msgs=[];
  void send(String t,String txt){if(txt.trim().isEmpty)return;setState(()=>msgs.add({'type':t,'text':txt}));ctrl.clear();}
  @override Widget build(BuildContext context){
    return Directionality(textDirection: TextDirection.rtl,child: Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF075E54),title: Text(widget.contact['name']!,style: TextStyle(color: Colors.white)),actions: [IconButton(icon: Icon(Icons.videocam,color: Colors.white),onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>CallPage(name:widget.contact['name']!,video:true)))),IconButton(icon: Icon(Icons.call,color: Colors.white),onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>CallPage(name:widget.contact['name']!,video:false))))]),
      body: Column(children: [
        Container(color: Color(0xFFFEF3C7),padding: EdgeInsets.all(6),child: Text("🔒 دردشة خاصة منفصلة ${widget.myPhone} -> ${widget.contact['phone']} - مشفرة",style: TextStyle(fontSize:10))),
        Expanded(child: Container(color: Color(0xFFE5DDD5),child: ListView.builder(reverse:true,padding: EdgeInsets.all(8),itemCount: msgs.length,itemBuilder: (_,i){var m=msgs[msgs.length-1-i];bool img=m['type']=='image';return Align(alignment: Alignment.centerLeft,child: Container(margin: EdgeInsets.symmetric(vertical:3),padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Color(0xFFDCF8C6),borderRadius: BorderRadius.circular(8)),child: img?Container(height:80,width:120,color: Colors.black12,child: Icon(Icons.image)):Text(m['text']!)));}))),
        Container(color: Colors.white,padding: EdgeInsets.all(6),child: Row(children: [IconButton(icon: Icon(Icons.photo),onPressed: ()=>send('image','صورة')),Expanded(child: TextField(controller: ctrl,decoration: InputDecoration(hintText:"رسالة خاصة...",border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide.none),filled:true,fillColor: Color(0xFFF0F0F0)))),SizedBox(width:6),CircleAvatar(backgroundColor: Color(0xFF25D366),child: IconButton(icon: Icon(Icons.send,color: Colors.white,size:18),onPressed: ()=>send('text',ctrl.text))) ]))
      ]),
    ));
  }
}
class CallPage extends StatefulWidget{final String name; final bool video; CallPage({required this.name,required this.video}); @override State<CallPage> createState()=>_CallS();}
class _CallS extends State<CallPage>{
  int sec=0; Timer? timer;
  @override void initState(){super.initState();timer=Timer.periodic(Duration(seconds:1),(t){if(mounted)setState(()=>sec++);});}
  @override void dispose(){timer?.cancel();super.dispose();}
  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: Color(0xFF111B21),body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
      CircleAvatar(radius:65,backgroundColor: Color(0xFF25D366),child: Text(widget.name[0],style: TextStyle(fontSize:55,color: Colors.white))),
      SizedBox(height:12),Text(widget.name,style: TextStyle(color: Colors.white,fontSize:22,fontWeight: FontWeight.bold)),
      Text("${widget.video?"مكالمة فيديو":"مكالمة صوتية"} - ${sec~/60}:${(sec%60).toString().padLeft(2,'0')}",style: TextStyle(color: Colors.white70)),
      SizedBox(height:30),Row(mainAxisAlignment: MainAxisAlignment.center,children: [
        CircleAvatar(backgroundColor: Colors.white24,child: Icon(Icons.mic_off,color: Colors.white)),SizedBox(width:20),
        CircleAvatar(backgroundColor: Colors.red,radius:28,child: IconButton(icon: Icon(Icons.call_end,color: Colors.white),onPressed: ()=>Navigator.pop(context))),SizedBox(width:20),
        CircleAvatar(backgroundColor: Colors.white24,child: Icon(Icons.volume_up,color: Colors.white)),
      ])
    ]))));
  }
}