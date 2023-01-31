import 'dart:async';
import 'dart:convert';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestayraya/serverconfig.dart';
import 'package:homestayraya/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: Stack(alignment: Alignment.center, children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.fill))),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/homestaylogo.png',
                        scale: 5),
              BorderedText(
                strokeWidth: 6.0,
                strokeColor: Colors.lightBlueAccent,
                child: Text(
                  "Homestay Raya",
                  style: GoogleFonts.kaushanScript(
                      textStyle: Theme.of(context).textTheme.headlineLarge,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900),
                ),
              ),
              const SizedBox(height: 40,),
              CircularProgressIndicator(
                color: Colors.blue.shade900,
              ),
              const SizedBox(height: 40,),
              BorderedText(
                strokeWidth: 1.0,
                strokeColor: Colors.blueGrey.shade600,
                child: Text("Version 0.1",
                    style: GoogleFonts.kaushanScript(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      fontSize: 30,
                      color: Colors.blue.shade900,
                    )),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = (prefs.getString('email')) ?? '';
    String _password = (prefs.getString('password')) ?? '';
    if (_email.isNotEmpty && _password.isNotEmpty) {
      http.post(Uri.parse("${ServerConfig.SERVER}/php/login_user.php"),
          body: {
            "email": _email,
            "password": _password,
          }).then((response) {
        print(response.body);
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200 && jsonResponse['status'] == "success") {
          User user = User.fromJson(jsonResponse['data']);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: user))));
        } else {
          User user = User(
              id: "0",
              email: "unregistered",
              name: "unregistered",
              address: "na",
              phone: "0123456789",
              regdate: "0");
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: user))));
        }
      });
    } else {
      User user = User(
          id: "0",
          email: "unregistered",
          name: "unregistered",
          address: "na",
          phone: "0123456789",
          regdate: "0");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
