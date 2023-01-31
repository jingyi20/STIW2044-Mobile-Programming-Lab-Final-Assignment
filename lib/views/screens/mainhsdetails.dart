import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homestayraya/models/homestay.dart';
import 'package:homestayraya/models/user.dart';
import 'package:homestayraya/serverconfig.dart';
import 'package:url_launcher/url_launcher.dart';

class MainHomestayDetails extends StatefulWidget {
  final Homestay homestay;
  final User user;
  final User owner;
  const MainHomestayDetails(
      {super.key,
      required this.homestay,
      required this.user,
      required this.owner});

  @override
  State<MainHomestayDetails> createState() => _MainHomestayDetailsState();
}

class _MainHomestayDetailsState extends State<MainHomestayDetails> {
  late double screenHeight, screenWidth, resWidth;
  int _index = 0;
  File? _image;
  List<File> _imageList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: AppBar(
              title: const Text("Details"),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          Card(
            elevation: 8,
            child: SizedBox(
                height: 300,
                width: resWidth,
                child: PageView.builder(
                  itemCount: 3,
                  controller: PageController(viewportFraction: 0.99),
                  onPageChanged: (int index) => setState(() => _index = index),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 200,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          widget.homestay.homestayName.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 16.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20.0)),
                            // ignore: prefer_const_constructors
                            child: Text(
                              "8.4/85 reviews",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {},
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(32.0),
                        color: Colors.white,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            Icon(
                                              Icons.star_border,
                                              color: Colors.yellow,
                                            ),
                                          ],
                                        ),
                                        Text.rich(
                                          TextSpan(children: [
                                            const WidgetSpan(
                                                child: Icon(
                                              Icons.location_on,
                                              size: 18.0,
                                              color: Colors.grey,
                                            )),
                                            TextSpan(
                                                text:
                                                    " ${widget.homestay.homestayAddress}")
                                          ]),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "RM ${widget.homestay.homestayPrice}",
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      const Text(
                                        "/per night",
                                        style: TextStyle(
                                            fontSize: 14.0, color: Colors.grey),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 30.0),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 32.0,
                                    ),
                                  ),
                                  child: const Text(
                                    "Book Now",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Text(
                                "Description".toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0),
                              ),
                              const SizedBox(height: 10.0),
                              Text(widget.homestay.homestayDesc.toString(),
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16.0)),
                              const SizedBox(height: 30.0),
                              SizedBox(
                                width: screenWidth - 16,
                                child: Table(
                                    border: TableBorder.all(
                                        color: Colors.black,
                                        style: BorderStyle.none,
                                        width: 1),
                                    columnWidths: const {
                                      0: FixedColumnWidth(100),
                                      1: FixedColumnWidth(200),
                                    },
                                    children: [
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Locality'.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w600))
                                            ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${widget.homestay.homestayLocal}",
                                                  style: const TextStyle(
                                                      fontSize: 16.0))
                                            ]),
                                      ]),
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('State'.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w600))
                                            ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${widget.homestay.homestayState}",
                                                  style: const TextStyle(
                                                      fontSize: 16.0))
                                            ]),
                                      ]),
                                      TableRow(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Owner'.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w600))
                                            ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${widget.homestay.homestayOwner}",
                                                  style: const TextStyle(
                                                      fontSize: 16.0))
                                            ]),
                                      ])
                                    ]),
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "DETAIL",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Card(
                elevation: 0,
                color: Colors.white70,
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          iconSize: 32,
                          onPressed: _makePhoneCall,
                          icon: const Icon(Icons.call)),
                      IconButton(
                          iconSize: 32,
                          onPressed: _makeSmS,
                          icon: const Icon(Icons.message)),
                      IconButton(
                          iconSize: 32,
                          onPressed: openwhatsapp,
                          icon: const Icon(Icons.whatsapp)),
                      IconButton(
                          iconSize: 32,
                          onPressed: _onRoute,
                          icon: const Icon(Icons.map)),
                      IconButton(
                          iconSize: 32,
                          onPressed: _onShowMap,
                          icon: const Icon(Icons.maps_home_work))
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.owner.phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeSmS() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: widget.homestay.homestayContact,
    );
    await launchUrl(launchUri);
  }

  Future<void> _onRoute() async {
    final Uri launchUri = Uri(
        scheme: 'https',
        // ignore: prefer_interpolation_to_compose_strings
        path: "www.google.com/maps/@" +
            widget.homestay.homestayLat.toString() +
            "," +
            widget.homestay.homestayLng.toString() +
            "20z");
    await launchUrl(launchUri);
  }

  openwhatsapp() async {
    var whatsapp = widget.owner.phone;
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=hello";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp not installed")));
      }
    }
  }

  int generateIds() {
    var rng = Random();
    int randomInt;
    randomInt = rng.nextInt(100);
    return randomInt;
  }

  void _onShowMap() {
    double lat = double.parse(widget.homestay.homestayLat.toString());
    double lng = double.parse(widget.homestay.homestayLng.toString());
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    int markerIdVal = generateIds();
    MarkerId markerId = MarkerId(markerIdVal.toString());
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        lat,
        lng,
      ),
    );
    markers[markerId] = marker;

    CameraPosition campos = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.4746,
    );
    Completer<GoogleMapController> ncontroller =
        Completer<GoogleMapController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Location",
            style: TextStyle(),
          ),
          content: Container(
            height: screenHeight,
            width: screenWidth,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: campos,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                ncontroller.complete(controller);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
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
}
