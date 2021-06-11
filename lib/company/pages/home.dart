import 'package:flutter/material.dart';
import 'package:jobhop/company/pages/profile.dart';
import 'package:jobhop/utils/generic.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/mobile/pages/assigned_list.dart';
import 'package:jobhop/utils/state.dart';
import 'package:jobhop/utils/auth.dart';
import 'package:jobhop/utils/google.dart';
import 'package:jobhop/utils/apple.dart';
import 'package:jobhop/utils/facebook.dart';
import 'package:jobhop/utils/widgets.dart';


GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);


class JobHopHome extends StatefulWidget {
  @override
  State createState() => JobHopHomeState();
}

class JobHopHomeState extends State<JobHopHome> {
  Apple _apple = Apple();
  Facebook _facebook = Facebook();
  Google _google = Google(googleSignIn);
  String? _token;
  bool _inAsyncCall = false;
  bool _showProfile = true;

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
    await _initState();
  }

  Future<void> _initState() async {
    final StudentUser? user = await auth.initState(context);

    if(user != null && user.id != null) {
      _token = user.token;
    }

    context.locale = await getLocale();
    setState(() {});
  }

  Future<String?> _setUserToken() async {
    _token = await auth.getUserField('token');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Job-Hop',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Job-Hop'),
          ),
          body: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: ModalProgressHUD(
                  child: _buildBody(),
                  inAsyncCall: _inAsyncCall
              )
          ))
    );
  }

  Widget _buildBody() {
    if (_token != null) {
      // first time let the user entter their full profile
      if(_showProfile) {
        return ProfileFormWidget();
      }

      return Column(
        children: [
          Consumer<AppStateModel>(
            builder: (context, state, child) {
              return Text('home.welcome'.tr(
                  namedArgs: { 'firstName': state.user!.firstName! }));
            },
          ),
          ElevatedButton(
              child: Text('home.continue'.tr()),
              onPressed: () {
                final page = AssignedOrderListPage();

                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => page)
                );
              }
          )
        ],
      );
    }

    const facebookKey = Key('facebookButton');

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Image(image: AssetImage('assets/logo-big.png')),
        Spacer(),
        InkWell(
          key: facebookKey,
          onTap: () async {
            _inAsyncCall = true;
            setState(() {});
            final bool result = await _facebook.login();

            if(!result) {
              _inAsyncCall = false;
              setState(() {});
              return displayDialog(
                  context,
                  'home.login_error_title'.tr(),
                  'home.error_facebook'.tr()
              );
            }

            await _setUserToken();
            _inAsyncCall = false;
            setState(() {});
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
              return displayDialog(context,
                  'home.login_error_title'.tr(),
                  'home.error_google'.tr()
              );
            }

            await _setUserToken();
            _inAsyncCall = false;
            setState(() {});
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
              return displayDialog(
                  context,
                  'home.login_error_title'.tr(),
                  'home.error_apple'.tr()
              );
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
