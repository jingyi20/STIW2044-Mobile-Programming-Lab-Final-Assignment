import 'package:flutter/material.dart';
import 'package:homestayraya/modals/user.dart';
import 'package:homestayraya/views/shared/mainmenu.dart';


class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Home", style: TextStyle(fontSize: 25, fontStyle: FontStyle.normal),),
        ),
        body: const Center(child: Text("Welcome to Homestay Raya")),
        drawer: MainMenuWidget(user: widget.user,),
      ),
    );
  }
}