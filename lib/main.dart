import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:ndef/ndef.dart' as ndef;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data = '';

  @override
  Widget build(BuildContext context) {
    NfcManager.instance.startSession(

      onDiscovered: (NfcTag tag) async {
      Ndef? ndef = Ndef.from(tag);
      Map tagData = tag.data;
      Map tagNdef = tagData['ndef'];
      Map cachedMessage = tagNdef['cachedMessage'];
      Map records = cachedMessage['records'][0];
      Uint8List payload = records['payload'];
      String payloadAsString = utf8.decode(payload);
      print(payloadAsString);
      // print('${(
      //     NfcA.from(tag)?.identifier ??
      //         NfcB.from(tag)?.identifier ??
      //         NfcF.from(tag)?.identifier ??
      //         NfcV.from(tag)?.identifier ??
      //         Uint8List(0)
      // ).toHexString()}');
      NdefMessage? message = NdefMessage([
        NdefRecord.createText('wowWOW.com',languageCode: 'en'),
      ]);
      // Do something with an NfcTag instance.
      try {
        ndef!.write(message);
        if(!ndef.isWritable){
        // ndef.write(message);
        print('writable');
        // print(tag.data.toString());
      }else{
          setState(() {
            // print(tag.data.values);
            // print(ndef.additionalData.keys);
            Uint8List mm = ndef.cachedMessage!.records[0].payload;
            print(utf8.decode(mm).substring(3,mm.length));
            // print(ndef.read().then((value) async{
            //   print(await value.records.first);
            //   print(await value.records.last);
            // }));
            data = payloadAsString.substring(3,mm.length);
            // print(tag.data.toString());
          });
        }
        NfcManager.instance.stopSession();
        // if (ndef == null || ndef.toString().isEmpty) {
        //   print('Tag is not compatible with NDEF');
        //   return;
        // }
        return;
      }catch (e){
        print(e);
        return;
      }
      },
    );
    return Scaffold(
      body: Center(child: Text(data)),
    );
  }
}
