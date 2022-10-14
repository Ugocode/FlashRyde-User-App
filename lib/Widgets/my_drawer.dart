import 'package:flutter/material.dart';
import 'package:fusers_app/Global/global.dart';
import 'package:fusers_app/Screens/spalsh%20_screen.dart';

class MyDrawer extends StatefulWidget {
  final String? name;
  final String? email;

  const MyDrawer({Key? key, this.email, this.name}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: ListView(children: [
          //Drawer header:
          Container(
            height: 140,
            color: Colors.blueGrey,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.pink),
              child: Row(children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.white),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name.toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.email.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),

          // Drawer body cntrollers
          const SizedBox(
            height: 12,
          ),
          const ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payments'),
          ),
          const ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
          ),
          const ListTile(
            leading: Icon(Icons.tag),
            title: Text('Promotions'),
          ),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
          ),
          ListTile(
            onTap: (() {
              // Navigator.pushNamedAndRemoveUntil(
              //     context, AboutUs.idScreen, (route) => false);
            }),
            leading: const Icon(Icons.info),
            title: const Text('About'),
          ),
          ListTile(
            onTap: (() {
              fireAuth.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MySplashScreen()));
            }),
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
          ),
        ]),
      ),
    );
  }
}
