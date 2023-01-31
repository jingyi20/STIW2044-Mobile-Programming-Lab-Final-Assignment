import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestayraya/models/homestay.dart';
import 'package:homestayraya/models/user.dart';
import 'package:homestayraya/serverconfig.dart';
import 'package:http/http.dart' as http;

class HomestayDetailsScreen extends StatefulWidget {
  final Homestay homestay;
  final User user;
  const HomestayDetailsScreen({
    Key? key,
    required this.homestay,
    required this.user,
  }) : super(key: key);

  @override
  State<HomestayDetailsScreen> createState() => _HomestayDetailsScreenState();
}

class _HomestayDetailsScreenState extends State<HomestayDetailsScreen> {
  int _index = 0;
  File? _image;
  List<File> _imageList = [];
  var pathAsset = "assets/images/camera.png";
  final TextEditingController _homestaynameEditingController =
      TextEditingController();
  final TextEditingController _homestayaddressEditingController =
      TextEditingController();
  final TextEditingController _homestaydescEditingController =
      TextEditingController();
  final TextEditingController _homestaypriceEditingController =
      TextEditingController();
  final TextEditingController _homestayownerEditingController =
      TextEditingController();
  final TextEditingController _homestaycontactEditingController =
      TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? image;
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();
    _homestaynameEditingController.text =
        widget.homestay.homestayName.toString();
    _homestayaddressEditingController.text =
        widget.homestay.homestayAddress.toString();
    _homestaydescEditingController.text =
        widget.homestay.homestayDesc.toString();
    _homestaypriceEditingController.text =
        widget.homestay.homestayPrice.toString();
    _homestayownerEditingController.text =
        widget.homestay.homestayOwner.toString();
    _homestaycontactEditingController.text =
        widget.homestay.homestayContact.toString();
    _prstateEditingController.text = widget.homestay.homestayState.toString();
    _prlocalEditingController.text = widget.homestay.homestayLocal.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
        appBar: AppBar(title: const Text("Details/Edit")),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            Card(
              elevation: 8,
              child: SizedBox(
                  height: screenHeight / 3,
                  width: resWidth,
                  child: PageView.builder(
                    itemCount: 3,
                    controller: PageController(viewportFraction: 0.99),
                    onPageChanged: (int index) =>
                        setState(() => _index = index),
                    itemBuilder: (BuildContext context, int index) {
                      if ((index == 0)) {
                        return CachedNetworkImage(
                            width: resWidth,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${ServerConfig.SERVER}/assets/homestayimages/${widget.homestay.homestayId}_1.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error));
                      } else if (index == 1) {
                        return CachedNetworkImage(
                            width: resWidth,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${ServerConfig.SERVER}/assets/homestayimages/${widget.homestay.homestayId}_2.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error));
                      } else {
                        return CachedNetworkImage(
                            width: resWidth,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${ServerConfig.SERVER}/assets/homestayimages/${widget.homestay.homestayId}_3.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error));
                      }
                    },
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Edit Your Homestay",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _homestaynameEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "Homestay name must be longer than 3"
                            : null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Homestay name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.house),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _homestayaddressEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "Homestay address must be longer than 3"
                            : null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Homestay address',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.location_on),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _homestaydescEditingController,
                          validator: (val) => val!.isEmpty || (val.length < 10)
                              ? "Homestay description must be longer than 10"
                              : null,
                          maxLines: 4,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Homestay Description',
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(),
                              icon: Icon(
                                Icons.description,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _homestaypriceEditingController,
                          validator: (val) => val!.isEmpty
                              ? "Homestay price must contain value"
                              : null,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Homestay Price',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.money),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Flexible(
                              flex: 5,
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  validator: (val) =>
                                      val!.isEmpty || (val.length < 3)
                                          ? "Current State"
                                          : null,
                                  enabled: false,
                                  controller: _prstateEditingController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      labelText: 'Current States',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.flag),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      )))),
                          Flexible(
                              flex: 5,
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  enabled: false,
                                  validator: (val) =>
                                      val!.isEmpty || (val.length < 3)
                                          ? "Current Locality"
                                          : null,
                                  controller: _prlocalEditingController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      labelText: 'Current Locality',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.map),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ))))
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Must be more than 5 characters"
                                  : null,
                              controller: _homestayownerEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Owner Name',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.person),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _homestaycontactEditingController,
                                validator: (val) => val!.isEmpty
                                    ? "Contact No. should be more than 10"
                                    : null,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Contact No.',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.phone),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    )))),
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 45,
                        width: 135,
                        child: ElevatedButton(
                          onPressed: () => {
                            _updatehomestayDialog(),
                          },
                          child: const Text(
                            'Update Homestay',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16),
                                textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  )),
            )
          ]),
        ));
  }

  void _updatehomestayDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Update this homestay/service?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _updatehomestay();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updatehomestay() {
    String hsname = _homestaynameEditingController.text;
    String hsaddress = _homestayaddressEditingController.text;
    String hsdesc = _homestaydescEditingController.text;
    String hsprice = _homestaypriceEditingController.text;
    String hsowner = _homestayownerEditingController.text;
    String hscontact = _homestaycontactEditingController.text;

    http.post(Uri.parse("${ServerConfig.SERVER}/php/update_homestay.php"),
        body: {
          "hsid": widget.homestay.homestayId,
          "userid": widget.user.id,
          "hsname": hsname,
          "hsaddress": hsaddress,
          "hsdesc": hsdesc,
          "hsprice": hsprice,
          "hsowner": hsowner,
          "hscontact": hscontact,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }
}
