import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homestayraya/models/user.dart';
import 'package:homestayraya/serverconfig.dart';
import 'package:homestayraya/views/screens/mainscreen.dart';
import 'package:homestayraya/views/screens/ownerscreen.dart';
import 'package:homestayraya/views/screens/profilescreen.dart';
import 'EnterExitRoute.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  const MainMenuWidget({super.key, required this.user});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  var pathAsset = "assets/images/profile.png";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/profilebackground.jpg'),
                    opacity: 0.5,
                    fit: BoxFit.fill)),
            accountEmail: Text(
              widget.user.email.toString(),
              style: const TextStyle(color: Colors.black),
            ),
            // keep blank text because email is required
            accountName: Text(widget.user.name.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 18)),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              child: ClipOval(
                child: CachedNetworkImage(
                    imageUrl:
                        "${ServerConfig.SERVER}/assets/profileimages/${widget.user.id}.png",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Image.asset(pathAsset)),
              ),
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    flex: 5,
                    child:
                        Image.asset('assets/images/homeicon.png', scale: 2.0)),
                const Text('    '),
                const Text('Home', style: TextStyle(fontSize: 16)),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: MainScreen(
                        user: widget.user,
                      ),
                      enterPage: MainScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    flex: 5,
                    child: Image.asset('assets/images/homestayicon.png',
                        scale: 20.0)),
                const Text('    '),
                const Text('Owner', style: TextStyle(fontSize: 16)),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: MainScreen(
                        user: widget.user,
                      ),
                      enterPage: OwnerScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    flex: 5,
                    child: Image.asset('assets/images/profileicon.png',
                        scale: 2.0)),
                const Text('    '),
                const Text('Profile', style: TextStyle(fontSize: 16)),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: MainScreen(user: widget.user),
                      enterPage: ProfileScreen(user: widget.user)));
            },
          ),
        ],
      ),
    );
  }
}
