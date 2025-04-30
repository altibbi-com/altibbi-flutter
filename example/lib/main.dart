
import 'package:altibbi/altibbi_service.dart';
import 'package:altibbi_example/phr.dart';
import 'package:flutter/material.dart';

import 'askSina.dart';
import 'consultation.dart';

void main() {
  AltibbiService.init(
    token: "",
    baseUrl: "",
    language: 'ar', // ar or en
    sinaModelEndPoint: '');
  runApp(const MaterialApp(home: MainWidget(),debugShowCheckedModeBanner: false));
}


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {

  void consultation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Consultation()),
    );
  }

  void openPhr() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PhrPage()),
    );
  }

  void openAsksina() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Asksina()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0099D1),
        title: const Text('Altibbi SDK'),
      ),
      backgroundColor: const Color(0xFFF3F3F4),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
        child: Column(
          children: [
            Flexible(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0099D1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: consultation,
                  child: const Text(
                    "open consultation page",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0099D1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: openPhr,
                  child: const Text(
                    "open phrs page",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0099D1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: openAsksina,
                  child: const Text(
                    "Sina page",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

