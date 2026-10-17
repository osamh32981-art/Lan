import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

void main() => runApp(LANApp());

class LANApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF0A192F)),
      home: SplashScreen(),
    );
  }
}

// 1. شاشة البداية - مثل الصورة
class SplashScreen extends StatefulWidget {
  @override State<SplashScreen> createState()=>_SplashS();
}
class _SplashS extends State<SplashScreen>{
  @override void initState(){super.initState(); Future.delayed(Duration(seconds: 2), ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MainScreen())));}
  @override Widget build(BuildContext c){
    return Scaffold(backgroundColor: Color(0xFF07132E),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width:120,height:120,decoration:BoxDecoration(color:Color(0xFF0E2342),borderRadius:BorderRadius.circular(28),border: Border.all(color: Color(0xFF1E90FF),width:1)),child: Icon(Icons.wifi, size:60, color: Color(0xFF1E90FF))),
        SizedBox(height:16),
        RichText(text: TextSpan(children: [TextSpan(text:"LAN ",style:TextStyle(color:Color(0xFF1E90FF),fontSize:26,fontWeight:FontWeight.bold)), TextSpan(text:"Connect",style:TextStyle(color:Colors.white,fontSize:26,fontWeight:FontWeight.bold))])),
        SizedBox(height:6),
        Text("اتصال صوت وصورة عبر شبكة LAN",style:TextStyle(color:Colors.white70,fontSize:12)),
        SizedBox(height:6),
        Container(padding:EdgeInsets.symmetric(horizontal:12,vertical:4),decoration:BoxDecoration(color:Color(0xFF0E2342),borderRadius:BorderRadius.circular(20)),child: Row(mainAxisSize: MainAxisSize.min,children: [Icon(Icons.wifi_off,size:14,color:Color(0xFF1E90FF)),SizedBox(width:6),Text("بدون إنترنت",style:TextStyle(color:Colors.white70,fontSize:11))])),
      ])),
    );
  }
}

// 2. الشاشة الرئيسية - نفس الصورة
class MainScreen extends StatefulWidget{
  @override State<MainScreen> createState()=>_MainS();
}
class _MainS extends State<MainScreen>{
  String myIp = "جاري جلب IP...";
  ServerSocket? server;
  List<Socket> clients=[];
  bool hosting=false;

  @override void initState(){super.initState(); _getIp();}

  Future<void> _getIp() async {
    try{
      var interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
      for(var i in interfaces){
        for(var addr in i.addresses){
          if(!addr.address.startsWith("127") && addr.address.contains("192.168")){