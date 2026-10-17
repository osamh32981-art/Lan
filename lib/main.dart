import 'package:flutter/material.dart';
void main(){runApp(MaterialApp(debugShowCheckedModeBanner:false,theme:ThemeData.dark().copyWith(scaffoldBackgroundColor:Color(0xFF0A192F)),home:Splash()));}
class Splash extends StatefulWidget{ @override State<Splash> createState()=>_S();}
class _S extends State<Splash>{ @override void initState(){super.initState(); Future.delayed(Duration(seconds:2),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>MainPage())));} @override Widget build(BuildContext c){return Scaffold(backgroundColor:Color(0xFF07132E),body:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Container(width:120,height:120,decoration:BoxDecoration(color:Color(0xFF0E2342),borderRadius:BorderRadius.circular(28),border:Border.all(color:Color(0xFF1E90FF))),child:Icon(Icons.wifi,size:60,color:Color(0xFF1E90FF))),SizedBox(height:12),RichText(text:TextSpan(children:[TextSpan(text:"LAN ",style:TextStyle(color:Color(0xFF1E90FF),fontSize:26,fontWeight:FontWeight.bold)),TextSpan(text:"Connect",style:TextStyle(color:Colors.white,fontSize:26))])),Text("اتصال صوت وصورة عبر شبكة LAN",style:TextStyle(color:Colors.white70,fontSize:11)),SizedBox(height:8),Container(padding:EdgeInsets.symmetric(horizontal:10,vertical:4),decoration:BoxDecoration(color:Color(0xFF0E2342),borderRadius:BorderRadius.circular(20)),child:Text("بدون إنترنت",style:TextStyle(fontSize:11,color:Colors.white70)))])));}}

class MainPage extends StatelessWidget{
  @override Widget build(BuildContext c){
    return Scaffold(appBar:AppBar(backgroundColor:Color(0xFF0A192F),title:Text("LAN Connect",style:TextStyle(color:Color(0xFF1E90FF),fontWeight:FontWeight.bold)),centerTitle:true),
      body:ListView(padding:EdgeInsets.all(16),children:[
        Center(child:Container(width:100,height:100,decoration:BoxDecoration(color:Color(0xFF0E2342),shape:BoxShape.circle,border:Border.all(color:Color(0xFF1E90FF),width:2)),child:Icon(Icons.wifi,size:40,color:Color(0xFF1E90FF)))),
        SizedBox(height:16),
        _btn(c,"إنشاء اتصال","إنشاء اتصال وانتظار الانضمام",true,()=>Navigator.push(c, MaterialPageRoute(builder:(_)=>StatusPage(ip:"192.168.1.10")))),
        SizedBox(height:10),
        _btn(c,"الانضمام إلى اتصال","الاتصال بجهاز آخر",false,()=>Navigator.push(c, MaterialPageRoute(builder:(_)=>SearchPage()))),
        SizedBox(height:10),
        _btn(c,"الإعدادات","تخصيص التطبيق",false,()=>Navigator.push(c, MaterialPageRoute(builder:(_)=>SettingsPage()))),
        SizedBox(height:16),
        Container(padding:EdgeInsets.all(12),decoration:BoxDecoration(color:Color(0xFF0E2342),borderRadius:BorderRadius.circular(12)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text("جهازك: Android_12",style:TextStyle(color:Colors.white70,fontSize:11)),Text("IP: 192.168.1.10",style:TextStyle(color:Color(0xFF1E90FF),fontWeight:FontWeight.bold)),Text("LAN_Network",style:TextStyle(color:Colors.white38,fontSize:11))])),
      ]));
  }
  Widget _btn(BuildContext c,String t,String sub,bool primary,VoidCallback tap){return InkWell(onTap:tap,child:Container(padding:EdgeInsets.all(14),decoration:BoxDecoration(color:primary?Color(0xFF1E90FF):Color(0xFF0E2342),borderRadius:BorderRadius.circular(12)),child:Row(children:[Icon(primary?Icons.wifi:Icons.search,color:Colors.white),SizedBox(width:10),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(t,style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),Text(sub,style:TextStyle(color:Colors.white70,fontSize:10))])])));}
}

class StatusPage extends StatelessWidget{
  final String ip; StatusPage({required this.ip});
  @override Widget build(BuildContext c){return Scaffold(appBar:AppBar(backgroundColor:Color(0xFF0A192F),title:Text("حالة الاتصال",style:TextStyle(fontSize:14))),body:ListView(padding:EdgeInsets.all(12),children:[Container(padding:EdgeInsets.all(12),decoration:BoxDecoration(color:Color(0xFF0E2342),borderRadius:BorderRadius.circular(12)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text("جهازك: $ip",style:TextStyle(color:Colors.white70)),Text("IP: $ip",style:TextStyle(color:Color(0xFF1E90FF)))])),SizedBox(height:12),_dev(c,"Android_11","192.168.1.11"),_dev(c,"Android_9","192.168.1.12"),SizedBox(height:16),ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Color(0xFF1E90FF)),onPressed:()=>Navigator.push(c, MaterialPageRoute(builder:(_)=>SearchPage())),child:Text("البحث عن أجهزة"))]));}
  Widget _dev(BuildContext c,String n,String ip){return Container(margin:EdgeInsets.only(top:8),padding:EdgeInsets.all(10),decoration:BoxDecoration(color:Color(0xFF0E2342),borderRadius:BorderRadius.circular(10)),child:Row(children:[Icon(Icons.phone_android,color:Colors.white70),SizedBox(width:10),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(n,style:TextStyle(fontWeight:FontWeight.bold)),Text(ip,style:TextStyle(fontSize:11,color:Colors.white38))]),Spacer(),Icon(Icons.circle,color:Colors.green,size:10)]));}
}

class SearchPage extends StatelessWidget{
  @override Widget build(BuildContext c){
    var devs=[{'name':'Android_11','ip':'192.168.1.11'},{'name':'Phone_8','ip':'192.168.1.15'},{'name':'Tablet_1','ip':'192.168.1.20'}];
    return Scaffold(appBar:AppBar(backgroundColor:Color(0xFF0A192F),title:Text("الأجهزة المتاحة",style:TextStyle(fontSize:14))),body:Column(children:[Expanded(child:ListView.builder(itemCount:devs.length,itemBuilder:(_,i){var d=devs[i];return Container(margin:EdgeInsets.symmetric(horizontal:12,vertical:6),padding:EdgeInsets.all(10),decoration:BoxDecoration(color:Color(0xFF0E2342),borderRadius:BorderRadius.circular(10)),child:Row(children:[Icon(Icons.phone_android,color:Colors.white70),SizedBox(width:10),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(d['name']!,style:TextStyle(fontWeight:FontWeight.bold)),Text(d['ip']!,style:TextStyle(fontSize:11,color:Colors.white38))]),Spacer(),ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Color(0xFF1E90FF)),onPressed:()=>Navigator.push(c, MaterialPageRoute(builder:(_)=>CallPage(name:d['name']!,ip:d['ip']!))),child:Text("اتصال",style:TextStyle(fontSize:11)))]));})),Padding(padding:EdgeInsets.all(12),child:SizedBox(width:double.infinity,child:ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Color(0xFF1E90FF)),onPressed:()=>Navigator.push(c, MaterialPageRoute(builder:(_)=>IpPage())),child:Text("إدخال IP يدوياً"))))]));
  }
}

class IpPage extends StatelessWidget{
  final ctrl=TextEditingController(text:"192.168.1.15");
  @override Widget build(BuildContext c){return Scaffold(appBar:AppBar(backgroundColor:Color(0xFF0A192F),title:Text("الاتصال بجهاز",style:TextStyle(fontSize:14))),body:Padding(padding:EdgeInsets.all(16),child:Column(children:[SizedBox(height:20),Icon(Icons.phone_android,size:60,color:Colors.white70),Text("أدخل عنوان IP للجهاز الآخر",style:TextStyle(color:Colors.white70)),SizedBox(height:20),TextField(controller:ctrl,decoration:InputDecoration(border:OutlineInputBorder(borderRadius:BorderRadius.circular(10)),filled:true,fillColor:Color(0xFF0E2342))),SizedBox(height:16),SizedBox(width:double.infinity,height:44,child:ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Color(0xFF1E90FF)),onPressed:()=>Navigator.push(c, MaterialPageRoute(builder:(_)=>CallPage(name:"Device",ip:ctrl.text))),child:Text("اتصال")))]))); }
}

class CallPage extends StatelessWidget{
  final String name; final String ip;
  CallPage({required this.name,required this.ip});
  @override Widget build(BuildContext c){return Scaffold(backgroundColor:Color(0xFF07132E),body:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[CircleAvatar(radius:50,backgroundColor:Color(0xFF0E2342),child:Text(name[0],style:TextStyle(fontSize:40,color:Colors.white))),SizedBox(height:12),Text(name,style:TextStyle(color:Colors.white,fontSize:18,fontWeight:FontWeight.bold)),Text("$ip • 00:02:35",style:TextStyle(color:Colors.white70)),SizedBox(height:30),Row(mainAxisAlignment:MainAxisAlignment.center,children:[CircleAvatar(backgroundColor:Colors.white12,child:Icon(Icons.mic_off,color:Colors.white)),SizedBox(width:20),CircleAvatar(backgroundColor:Colors.red,radius:28,child:IconButton(icon:Icon(Icons.call_end,color:Colors.white),onPressed:()=>Navigator.pop(c))),SizedBox(width:20),CircleAvatar(backgroundColor:Colors.white12,child:Icon(Icons.volume_up,color:Colors.white))]),SizedBox(height:20),ElevatedButton(style