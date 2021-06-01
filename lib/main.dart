import 'package:flutter/material.dart';
import 'package:jobhop/utils/auth.dart';
import 'package:jobhop/utils/state.dart';
import 'package:jobhop/utils/apple.dart';
import 'package:jobhop/utils/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppStateModel(),
      child: MaterialApp(
        title: 'Job-Hop',
        home: JobHopHome(),
      ),
    ),
  );
}

class JobHopHome extends StatefulWidget {
  @override
  State createState() => JobHopHomeState();
}

class JobHopHomeState extends State<JobHopHome> {
  Auth _auth = Auth();
  Apple _apple = Apple();
  String? _token;
  bool _inAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Job-Hop'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: ModalProgressHUD(
            child: _buildBody(),
            inAsyncCall: _inAsyncCall
          )
        ));
  }

  @override
  void initState() {
    super.initState();
    _doAsync();
  }

  _doAsync() async {
    await _setUserToken();
  }

  Future<String?> _setUserToken() async {
    _token = await _auth.getUserToken();
  }

  Widget _buildBody() {
    if (_token != null) {
      // load orders or show menu?
      return Column(
        children: [
          Text('Yay you are logged in'),
          ElevatedButton(
              child: Text('Logout'),
              onPressed: () async {
                _inAsyncCall = true;
                setState(() {});
                await _auth.logout();
                _inAsyncCall = false;
                setState(() {});
              }
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image(image: AssetImage('assets/logo-big.png')),
          Spacer(),
          InkWell(
            onTap: () {

            },
            child: Container(
              child: ClipRRect(
                child: Image(image: AssetImage('assets/buttons/facebook-sign-in.png')),
              ),),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {

            },
            child: Container(
              child: ClipRRect(
                child: Image(image: AssetImage('assets/buttons/btn_google_signin_dark_normal_web@2x.png')),
              ),),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () async {
              _inAsyncCall = true;
              setState(() {});
              final bool result = await _apple.login();

              if(!result) {
                return displayDialog(context, 'Error logging in', 'There was an error logging you in using Apple');
                _inAsyncCall = true;
                setState(() {});
              }

              await _setUserToken();
              _inAsyncCall = false;
              setState(() {});
            },
            child: Container(
              child: ClipRRect(
                child: Image(image: AssetImage('assets/buttons/apple-id-sign-in-with.png')),
              ),),
          ),
          SizedBox(height: 20),
        ],
      );
    }
  }
}
