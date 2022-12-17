import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestayraya/modals/user.dart';
import 'package:homestayraya/views/screens/mainscreen.dart';
import 'package:homestayraya/views/screens/registrationscreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();

  bool _isChecked = false;
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  var screenHeight, screenWidth;
  double cardwidth = 0.0;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      cardwidth = screenWidth;
    } else {
      cardwidth = 400.00;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: cardwidth,
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailEditingController,
                              keyboardType: TextInputType.text,
                              validator: (value) => value!.isEmpty ||
                                      !value.contains("@") ||
                                      !value.contains(".")
                                  ? "Please enter valid email"
                                  : null,
                              decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.email),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0))),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            TextFormField(
                              controller: _passEditingController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) =>
                                  validatePassword(value.toString()),
                              obscureText:
                                  !_passwordVisible, //This will obscure text dynamically
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(),
                                  icon: const Icon(Icons.password),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0)),
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      })),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isChecked = value!;
                                        saveremovepref(value);
                                      });
                                    }),
                                const Text(
                                  "Remember Me",
                                  style: TextStyle(fontSize: 18),
                                ),
                                MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    minWidth: 115,
                                    height: 50,
                                    elevation: 10,
                                    onPressed: _loginAccount,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Dont have an account?  ",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: _registerForm,
                    child: const Text(
                      'Register Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _goHome,
                child: const Text(
                  'Go back home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter valid password';
    } else {
      return null;
    }
  }

  void _loginAccount() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in the login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    String _email = _emailEditingController.text;
    String _pass = _passEditingController.text;
    try {
      http.post(Uri.parse("http://192.168.1.8/homestayraya/php/login_user.php"),
          body: {
            "email": _email,
            "password": _pass,
          }).then((response) {
        print(response.body);
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200 && jsonResponse['status'] == "success") {
          User user = User.fromJson(jsonResponse['data']);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (content) => MainScreen(
                  user: user,
                ),
              ));
              Fluttertoast.showToast(
              msg: "Login Success",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.green,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
        } else {
          Fluttertoast.showToast(
              msg: "Login Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
        print(response.body);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _goHome() {
    User user = User(
        id: "0",
        email: "unregistered",
        name: "unregistered",
        address: "na",
        phone: "0123456789",
        regdate: "0");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => MainScreen(
                  user: user,
                )));
  }

  void _registerForm() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void saveremovepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      if (!_formKey.currentState!.validate()) {
        Fluttertoast.showToast(
            msg: "Please fill in the login credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      Fluttertoast.showToast(
          msg: "Preference Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Remove",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        _isChecked = true;
      });
    }
  }
}
