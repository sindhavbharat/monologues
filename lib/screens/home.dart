import 'package:flutter/material.dart';
import 'package:monologues/app_utils.dart';
import 'package:monologues/screens/chat.dart';
import 'package:monologues/utils/images.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  String kImage;
  String kName;


  Home({this.kImage, this.kName});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) => preferences=value);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          preferences.setBool(AppUtils.kPrefIsStartChat, true);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chat(kName:widget.kName,kImage:widget.kImage),),);
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                ImageList.kHomeBg1,
              ),
            ),
          ),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     ListTile(
          //       leading: CircleAvatar(
          //         backgroundImage: NetworkImage(widget.kImage,),
          //       ),
          //       title: Text(widget.kName,style: Theme.of(context).textTheme.bodyText1,
          //       ),
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }
}
