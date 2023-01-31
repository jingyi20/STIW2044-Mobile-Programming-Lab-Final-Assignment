import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestayraya/serverconfig.dart';
import 'package:homestayraya/models/user.dart';
import 'package:homestayraya/views/screens/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    super.initState();
    loadEula();
  }

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();

  bool _isChecked = false;
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  String eula = "";
  var screenHeight, screenWidth;
  double cardwidth = 0.0;

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
      appBar: AppBar(title: const Text("Registration Form")),
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
                                controller: _nameEditingController,
                                keyboardType: TextInputType.text,
                                validator: (value) => value!.isEmpty ||
                                        (value.length < 3)
                                    ? "Name must be longer than 3 characters"
                                    : null,
                                decoration: const InputDecoration(
                                    labelText: 'Name',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.person),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0)))),
                            const SizedBox(
                              height: 6,
                            ),
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
                              controller: _phoneEditingController,
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                                  validatePhone(value.toString()),
                              decoration: const InputDecoration(
                                  labelText: 'Phone',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.phone),
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
                              height: 6,
                            ),
                            TextFormField(
                              controller: _pass2EditingController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                validatePassword(value.toString());
                                if (value != _passEditingController.text) {
                                  return "Password do not match";
                                } else {
                                  return null;
                                }
                              },
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                  labelText: 'Re-enter Password',
                                  labelStyle: const TextStyle(),
                                  icon: const Icon(Icons.password_rounded),
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
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    }),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: showEula,
                                    child: const Text(
                                      'Agree with terms',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    minWidth: 115,
                                    height: 50,
                                    elevation: 10,
                                    onPressed: _registerAccount,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    child: const Text(
                                      'Register',
                                      
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
                              ],
                            )
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
                    "Already Register?  ",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: _loginForm,
                    child: const Text(
                      'Login here',
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

  void _registerAccount() {
    String _name = _nameEditingController.text;
    String _email = _emailEditingController.text;
    String _phone = _phoneEditingController.text;
    String _passA = _passEditingController.text;
    String _passB = _pass2EditingController.text;

    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the registration form first",
          toastLength: Toast.LENGTH_SHORT,
          // backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (_passA != _passB) {
      Fluttertoast.showToast(
          msg: "Please check your password",
          toastLength: Toast.LENGTH_SHORT,
          // backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept term",
          toastLength: Toast.LENGTH_SHORT,
          // backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    //if everything good proceed with dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register new account?",
              style: TextStyle(),
            ),
            content: const Text(
              "Are you sure?",
              style: TextStyle(),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _registerUser(_name, _email, _phone, _passA);
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(),
                  ))
            ],
          );
        });
  }

  loadEula() async {
    WidgetsFlutterBinding.ensureInitialized();
    eula = await rootBundle.loadString('assets/eula.txt');
    print(eula);
  }

  showEula() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("EULA"),
          content: SizedBox(
              height: 300,
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: RichText(
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                                text: eula)),
                      ))
                ],
              )),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                ))
          ],
        );
      },
    );
  }

  void _registerUser(String name, String email, String phone, String pass) {
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}/php/register_user.php"),
          body: {
            "name": name,
            "email": email,
            "phone": phone,
            "password": pass,
            "register": "register",
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Registration Success",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.green,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Registration Failed",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.red,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
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

  void _loginForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}

String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*[a-z])(?=.*?[0-9]).{10,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter valid password';
    } else {
      return null;
    }
  }

String? validatePhone(String value) {
  String pattern = r'^(?=.*?[0-9]{10,11}$)';
  RegExp regex = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please enter phone number';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter valid phone number';
  } else {
    return null;
  }
}

