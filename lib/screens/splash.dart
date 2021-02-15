import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monologues/app_utils.dart';
import 'package:monologues/utils/colors.dart';
import 'package:monologues/utils/images.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';


GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
  'profile',
  'email',
]);

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  GoogleSignInAccount currentUser;
  SharedPreferences preferences;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) => preferences=value);
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async{
      if (account != null) {
        currentUser = account;
        print('current user information $currentUser');
        print('email ${currentUser.email}');
        print('display name ${currentUser.displayName}');
        print('display image ${currentUser.photoUrl}');
        preferences.setBool(AppUtils.kPrefIsLogin, true);
        preferences.setString(AppUtils.kPrefUserImage, currentUser.photoUrl);
        preferences.setString(AppUtils.kPrefUserName, currentUser.displayName);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
            Home(kImage: currentUser.photoUrl, kName: currentUser.displayName)));
      }
    });
    googleSignIn.signInSilently();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              ImageList.kHomeBg,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignInButton(
                Buttons.Google,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(
                    5.0,
                  ),
                  side: BorderSide(
                    color: ColorList.kBgColor,
                  ),
                ),
                onPressed: () =>_handleSignIn()
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SignInButton(
            //     Buttons.Apple,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadiusDirectional.circular(
            //         5.0,
            //       ),
            //       side: BorderSide(
            //         color: ColorList.kBgColor,
            //       ),
            //     ),
            //     onPressed: () => Navigator.pushNamed(
            //       context,
            //       '/home',
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

}
