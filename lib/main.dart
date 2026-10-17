import 'dart:async';
import 'package:flutter/material.dart';
void main(){runApp(MaterialApp(debugShowCheckedModeBanner:false,home:Login()));}
class Login extends StatelessWidget{
final p=TextEditingController(text:"05");
final n=TextEditingController(text:"المصمم");
@override Widget build(BuildContext c){
return Scaffold(backgroundColor:Color(0xFF111B21),body:Center(child:Container(margin:EdgeInsets.all(20),padding:EdgeInsets.all(20),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(12)),child:Column(mainAxisSize:MainAxisSize.min,children:[
Icon(Icons.lock,size:50,color:Color(0xFF075E54)),
Text("WhatsApp LAN",style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
Text("دخول برقم واسم - خصوصية",style:TextStyle(fontSize:11,color:Colors.grey)),
SizedBox(height:12),
TextField(controller:p,decoration:InputDecoration(labelText:"رقم الجوال",border:OutlineInputBorder(),prefixIcon:Icon(Icons.phone))),
SizedBox(height:8),
TextField(controller:n,decoration:InputDecoration(labelText:"اسم المستخدم",border:OutlineInputBorder(),prefixIcon:Icon(Icons.person))),
SizedBox(height:12),
SizedBox(width:double.infinity,height:48,child:ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Color(0xFF25D366)),onPressed:(){Navigator.pushReplacement(c,MaterialPageRoute(builder:(_)=>Home(phone:p.text,name:n.text)));},child:Text("دخول آمن",style:TextStyle(color:Colors.white))))
]))));}}
class Home extends StatelessWidget{
final String phone;final String name;
Home({required this.phone,required this.name});
@override Widget build(BuildContext c){
var users=[{'name':'أحمد','phone':'0555123456','msg':'دردشة خاصة 🔒'},{'name':'محمد','phone':'0555987000','msg':'📸 صورة'},{'name':'لابتوب','phone':'0555000111','msg':'🎤 مكالمة'}];
bool isDes=name.contains("المصمم");
return Directionality(textDirection:TextDirection.rtl,child:Scaffold(
appBar:AppBar(backgroundColor:Color(0xFF075E54),title:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Text("WhatsApp",style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),if(isDes)Container(margin:EdgeInsets.only(right:6),padding:EdgeInsets.symmetric(horizontal:6,vertical:2),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(8)),child:Text("المصمم ⭐",style:TextStyle(fontSize:9,color:Color(0xFF075E54))))]),Text("$name • $phone",style:TextStyle(color:Colors.white70,fontSize:11))])),
body:ListView.builder(itemCount:users.length,itemBuilder:(_,i){var u=users[i];return ListTile(leading:CircleAvatar(child:Text(u['name']![0])),title:Text(u['name']!),subtitle:Text(u['msg']!),trailing:Text("12:30",style:TextStyle(fontSize:11,color:Color(0xFF25D366))),onTap:(){Navigator.push(c,MaterialPageRoute(builder:(_)=>Chat(contact:u,myPhone:phone)));});}),
floatingActionButton:FloatingActionButton(backgroundColor:Color(0xFF25D366),onPressed:(){},child:Icon(Icons.chat,color:Colors.white)),
));}}
class Chat extends StatefulWidget{final Map<String,String> contact;final String myPhone;Chat({required this.contact,required this.myPhone});@override State<Chat> createState()=>_ChatS();}
class _ChatS extends State<Chat>{
final ctrl=TextEditingController();List<String> msgs=[];
@override Widget build(BuildContext c){
return Scaffold(
appBar:AppBar(backgroundColor:Color(0xFF075E54),title:Text(widget.contact['name']!,style:TextStyle(color:Colors.white)),actions:[IconButton(icon:Icon(Icons.videocam,color:Colors.white),onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>CallPage(name:widget.contact['name']!,video:true)))),IconButton(icon:Icon(Icons.call,color:Colors.white),onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>CallPage(name:widget.contact['name']!,video:false))))]),
body:Column(children:[
Container(color:Color(0xFFFEF3C7),padding:EdgeInsets.all(6),child:Text("🔒 ${widget.myPhone} -> ${widget.contact['phone']} - دردشة منفصلة مشفرة",style:TextStyle(fontSize:10))),
Expanded(child:Container(color:Color(0xFFE5DDD5),child:ListView.builder(reverse:true,padding:EdgeInsets.all(8),itemCount:msgs.length,itemBuilder:(_,i){return Align(alignment:Alignment.centerLeft,child:Container(margin:EdgeInsets.all(4),padding:EdgeInsets.all(10),decoration:BoxDecoration(color:Color(0xFFDCF8C6),borderRadius:BorderRadius.circular(8)),child:Text(msgs[msgs.length-1-i])));}))),
Container(color:Colors.white,padding:EdgeInsets.all(6),child:Row(children:[Expanded(child:TextField(controller:ctrl,decoration:InputDecoration(hintText:"رسالة...",border:OutlineInputBorder(borderRadius:BorderRadius.circular(20))))),SizedBox(width:6),FloatingActionButton.small(backgroundColor:Color(0xFF25D366),onPressed:(){if(ctrl.text.trim().isEmpty)return;setState(()=>msgs.add(ctrl.text));ctrl.clear();},child:Icon(Icons.send,color:Colors.white))]))])
);}
}
class CallPage extends StatefulWidget{final String name;final bool video;CallPage({required this.name,required this.video});@override State<CallPage> createState()=>_CallS();}
class _CallS extends State<CallPage>{int s=0;Timer? t;@override void initState(){super.initState();t=Timer.periodic(Duration(seconds:1),(x){if(mounted)setState(()=>s++);});}@override void dispose(){t?.cancel();super.dispose();}@override Widget build(BuildContext c){return Scaffold(backgroundColor:Color(0xFF111B21),body:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[CircleAvatar(radius:60,backgroundColor:Color(0xFF25D366),child:Text(widget.name[0],style:TextStyle(fontSize:50,color:Colors.white))),SizedBox(height:12),Text(widget.name,style:TextStyle(color:Colors.white,fontSize:22)),Text("${s~/60}:${(s%60).toString().padLeft(2,'0')}",style:TextStyle(color:Colors.white70)),SizedBox(height:30),CircleAvatar(backgroundColor:Colors.red,radius:30,child:IconButton(icon:Icon(Icons.call_end,color:Colors.white),onPressed:()=>Navigator.pop(c)))])));}}