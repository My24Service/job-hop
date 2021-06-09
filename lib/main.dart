import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'package:jobhop/utils/auth.dart';
import 'package:jobhop/utils/google.dart';
import 'package:jobhop/utils/state.dart';
import 'package:jobhop/utils/apple.dart';
import 'package:jobhop/utils/facebook.dart';
import 'package:jobhop/utils/widgets.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('nl', 'NL'),
          Locale('en', 'US'),
        ],
        path: 'resources/langs',
        fallbackLocale: Locale('en', 'US'),
        child: ChangeNotifierProvider(
            create: (context) => AppStateModel(),
            child: MaterialApp(
              title: 'Job-Hop',
              home: JobHopHome(),
            )
        )
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
  Facebook _facebook = Facebook();
  Google _google = Google(googleSignIn);
  String? _token;
  String? _backend;
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

    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _google.handleAccountLogin(account);
    });
    googleSignIn.signInSilently();

    _doAsync();
  }

  _doAsync() async {
    await _setUserToken();
    await _setBackend();
  }

  Future<void> _setBackend() async {
    final Auth auth = Auth();
    _backend = await auth.getBackend();

  }

  Future<String?> _setUserToken() async {
    _token = await _auth.getUserToken();
    setState(() {});
  }

  Widget _buildBody() {
    if (_token != null && _backend != null) {
      // load orders or show menu?
      return Column(
        children: [
          Text('Yay you are logged in via $_backend'),
          ElevatedButton(
              child: Text('Logout'),
              onPressed: () async {
                _inAsyncCall = true;
                setState(() {});

                switch(_backend) {
                  case 'apple':
                    await _apple.logOut();
                    break;
                  case 'facebook':
                    await _facebook.logOut();
                    break;
                  case 'google':
                    await _google.logOut();
                }

                await _setUserToken();

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
            onTap: () async {
              _inAsyncCall = true;
              setState(() {});
              final bool result = await _facebook.login();

              if(!result) {
                _inAsyncCall = false;
                setState(() {});
                return displayDialog(context, 'Error logging in', 'There was an error logging you in using Facebook');
              }

              await _setUserToken();
              _inAsyncCall = false;
              setState(() {});

              _backend = 'facebook';
            },
            child: Container(
              child: ClipRRect(
                child: Image(image: AssetImage('assets/buttons/facebook-sign-in.png')),
              ),),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () async {
              _inAsyncCall = true;
              setState(() {});
              final bool result = await _google.login();

              if(!result) {
                _inAsyncCall = false;
                setState(() {});
                return displayDialog(context, 'Error logging in', 'There was an error logging you in using Google');
              }

              await _setUserToken();
              _inAsyncCall = false;
              setState(() {});

              _backend = 'google';
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
                _inAsyncCall = false;
                setState(() {});
                return displayDialog(context, 'Error logging in', 'There was an error logging you in using Apple');
              }

              await _setUserToken();
              _inAsyncCall = false;
              setState(() {});
              _backend = 'apple';
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
