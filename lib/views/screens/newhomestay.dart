import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestayraya/config.dart';
import 'package:homestayraya/modals/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class NewHomestayScreen extends StatefulWidget {
  final User user;
  final Position position;
  final List<Placemark> placemarks;
  const NewHomestayScreen(
      {super.key,
      required this.position,
      required this.user,
      required this.placemarks});

  @override
  State<NewHomestayScreen> createState() => _NewHomestayScreenState();
}

class _NewHomestayScreenState extends State<NewHomestayScreen> {
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
  var _lat, _lng;
  var placemarks;

  @override
  void initState() {
    _lat = widget.position.latitude.toString();
    _lng = widget.position.longitude.toString();
    _prstateEditingController.text =
        widget.placemarks[0].administrativeArea.toString();
    _prlocalEditingController.text = widget.placemarks[0].locality.toString();
  }
  
  int _index = 0;
  File? _image;
  List<File> _imageList = [];
  var pathAsset = "assets/images/camera.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Homestay'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                height: 250,
                child: PageView.builder(
                    itemCount: 3,
                    controller: PageController(viewportFraction: 0.7),
                    onPageChanged: (int index) =>
                        setState(() => _index = index),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return image1();
                      } else if (index == 1) {
                        return image2();
                      } else {
                        return image3();
                      }
                    }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Add New Homestay",
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
                        // onFieldSubmitted: (v) {
                        //   FocusScope.of(context).requestFocus(focus);
                        // },
                        keyboardType: TextInputType.text,
                        // cursor
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
                        // onFieldSubmitted: (v) {
                        //   FocusScope.of(context).requestFocus(focus);
                        // },
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
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () => {
                            _insertNewHomestayDialog(),
                          },
                          child: const Text(
                            'Add Homestay',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  _insertNewHomestayDialog() {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please take picture of your homestay",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
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
            "Insert this homestay?",
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
                insertHomestay();
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

  void _selectImageDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //return object of type Dialog
          return AlertDialog(
            title: const Text(
              "Select picture from",
              style: TextStyle(),
            ),
            content: SizedBox(
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        iconSize: 50,
                        onPressed: _selectfromCamera,
                        icon: const Icon(Icons.camera),
                      ),
                      const Text('Camera'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          iconSize: 50,
                          onPressed: _selectfromGallery,
                          icon: const Icon(Icons.image)),
                      const Text('Gallery'),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _selectfromCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    } else {
      print('No image selected.');
    }
  }

  _selectfromGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _imageList.add(_image!);
      setState(() {});
    }
  }

  void insertHomestay() {
    String hsname = _homestaynameEditingController.text;
    String hsdesc = _homestaydescEditingController.text;
    String hsprice = _homestaypriceEditingController.text;
    String hsaddress = _homestayaddressEditingController.text;
    String hsowner = _homestayownerEditingController.text;
    String hscontact = _homestaycontactEditingController.text;
    String state = _prstateEditingController.text;
    String local = _prlocalEditingController.text;
    String base64Image1 = base64Encode(_imageList[0].readAsBytesSync());
    String base64Image2 = base64Encode(_imageList[1].readAsBytesSync());
    String base64Image3 = base64Encode(_imageList[2].readAsBytesSync());

    http.post(Uri.parse("${Config.SERVER}/php/insert_homestay.php"), body: {
      "userid": widget.user.id,
      "hsname": hsname,
      "hsdesc": hsdesc,
      "hsprice": hsprice,
      "hsaddress": hsaddress,
      "hsowner": hsowner,
      "hscontact": hscontact,
      "state": state,
      "local": local,
      "lat": _lat,
      "lon": _lng,
      "image1": base64Image1,
      "image2": base64Image2,
      "image3": base64Image3
    }).then((response) {
      print(response.body);
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
  Widget image1() {
    return Transform.scale(
      scale: 1.0,
      child: Card(
          elevation: 8,
          child: GestureDetector(
            onTap: _selectImageDialog,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: _imageList.isNotEmpty
                    ? FileImage(_imageList[0]) as ImageProvider
                    : AssetImage(pathAsset),
                fit: BoxFit.cover,
              )),
            ),
          )),
    );
  }

  Widget image2() {
    return Transform.scale(
      scale: 1.0,
      child: Card(
          elevation: 8,
          child: GestureDetector(
            onTap: _selectImageDialog,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: _imageList.length > 1
                    ? FileImage(_imageList[1]) as ImageProvider
                    : AssetImage(pathAsset),
                fit: BoxFit.cover,
              )),
            ),
          )),
    );
  }

  Widget image3() {
    return Transform.scale(
      scale: 1.0,
      child: Card(
          elevation: 8,
          child: GestureDetector(
            onTap: _selectImageDialog,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: _imageList.length > 2
                    ? FileImage(_imageList[2]) as ImageProvider
                    : AssetImage(pathAsset),
                fit: BoxFit.cover,
              )),
            ),
          )),
    );
  }
}
