import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lienna_bag/Provider/themeMode.dart';
import 'package:lienna_bag/page/edit_profile.dart';
import 'package:lienna_bag/page/home_screen.dart';
import 'package:lienna_bag/page/search_page.dart';
import 'package:lienna_bag/page/settings.dart' as app_settings;
import 'package:lienna_bag/page/favorite_page.dart';
import 'package:provider/provider.dart';

import 'about_page.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModeData = Provider.of<ThemeModeData>(context);

    var lebar = MediaQuery.of(context).size.width;
    var tinggi = MediaQuery.of(context).size.height;

    var userCollection = FirebaseFirestore.instance.collection('user');
    var userID = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: userCollection.doc(userID).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: CircularProgressIndicator(),
          ));
        } else if (snapshot.hasData) {
          Object? usernameData =
              snapshot.data!.data().toString().contains('username')
                  ? snapshot.data!.get('username')
                  : '...';

          Object? emailData = snapshot.data!.data().toString().contains('email')
              ? snapshot.data!.get('email')
              : '...';

          Object? profileData =
              snapshot.data!.data().toString().contains('profile')
                  ? snapshot.data!.get('profile')
                  : '';

          return Scaffold(
            appBar: AppBar(
                backgroundColor:
                    Provider.of<ThemeModeData>(context).containerColor,
                // backgroundColor: Color.fromRGBO(76, 83, 114, 1),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'USER PROFILE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return hom_scrn();
                      },
                    ),
                  );
                }
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SearchPage();
                      },
                    ),
                  );
                }
                if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Profile();
                      },
                    ),
                  );
                }
              },
              // backgroundColor:
              //     Provider.of<ThemeModeData>(context).containerColor,
              items: [
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(
                    CupertinoIcons.home,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Search",
                  icon: Icon(
                    CupertinoIcons.search,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Profile",
                  icon: Icon(
                    CupertinoIcons.profile_circled,
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                Container(
                  width: lebar,
                  height: tinggi,
                  // color: Provider.of<ThemeModeData>(context).containerColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: lebar,
                        height: 350,
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("Assets/profile_default.png"),
                                fit: BoxFit.cover)),
                        child: Container(
                          width: lebar,
                          height: tinggi,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [Color(0x7F373538), Color(0xFF363538)],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              profileData.toString() == ''
                                  ? Container(
                                      width: 100,
                                      height: 100,
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "Assets/profile_default.png"),
                                          fit: BoxFit.fill,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  profileData.toString()),
                                              fit: BoxFit.cover)),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                usernameData.toString(),
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                emailData.toString(),
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile()),
                                );
                              },
                              icon: Icon(
                                Icons.manage_accounts_rounded,
                                size: 30,
                                color: Color(0xFF4C5372),
                              ),
                              label: Text(
                                "Edit Profile",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => FavoritePage()),
                                // );
                              },
                              icon: Icon(
                                Icons.favorite_border_rounded,
                                size: 30,
                                color: Color(0xFF4C5372),
                              ),
                              label: Text(
                                "My Favorite",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          app_settings.Settings()),
                                );
                              },
                              icon: Icon(
                                Icons.settings,
                                size: 30,
                                color: Color(0xFF4C5372),
                              ),
                              label: Text(
                                "Settings",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => About_Page()),
                                );
                              },
                              icon: Icon(
                                Icons.info_outline_rounded,
                                size: 30,
                                color: Color(0xFF4C5372),
                              ),
                              label: Text(
                                "About Us",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}
