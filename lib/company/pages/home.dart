import 'package:flutter/material.dart';
import 'package:jobhop/company/pages/login.dart';
import 'package:jobhop/company/widgets/profile.dart';
import 'package:jobhop/utils/generic.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:upgrader/upgrader.dart';

import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/company/api/api.dart';
import 'package:jobhop/mobile/pages/assigned_list.dart';
import 'package:jobhop/utils/state.dart';
import 'package:jobhop/utils/auth.dart';
import 'package:jobhop/core/widgets/widgets.dart';

GetIt getIt = GetIt.instance;

class JobHopHome extends StatefulWidget {
  @override
  State createState() => JobHopHomeState();
}

class JobHopHomeState extends State<JobHopHome> {
  @override
  void initState() {
    super.initState();
    _doAsync();
  }

  _doAsync() async {
    await _initState();
  }

  Future<void> _initState() async {
    context.locale = await getLocale();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Job-Hop',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color.fromRGBO(38, 34, 97, 1)
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Job-Hop'),
          ),
          body: UpgradeAlert(
            child: Home()
          )
        )
    );
  }
}


class Home extends StatefulWidget {
  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _token;
  bool _inAsyncCall = false;
  bool _isFirstTimeProfile = true;
  String? _firstName;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _doAsync();
  }

  _doAsync() async {
    await _initState();
    await Future.delayed(Duration(milliseconds: 100));
    _isLoaded = true;

    // post device token
    await companyApi.postDeviceToken();

    setState(() {});
  }

  Future<void> _initState() async {
    final StudentUser? user = await auth.initState(context);

    if (user != null && user.id != null) {
      _token = user.token;
      _firstName = getIt<AppModel>().user!.firstName ?? 'guest';
    }

    _isFirstTimeProfile = await isFirstTimeProfile();
    print('_isFirstTimeProfile: $_isFirstTimeProfile');

    setState(() {});
  }

  Future<String?> _setUserToken() async {
    _token = await auth.getUserFieldString('token');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        child: Align(
          alignment: Alignment.center,
          child: !_isLoaded ? _blankScreen() : _buildBody(),
        ),
        inAsyncCall: _inAsyncCall
      )
    );
  }

  Widget _blankScreen() {
    return Image(image: AssetImage('assets/logo-small.png'));
  }

  Widget _buildBody() {
    if (_token != null) {
      // first time let the user enter their full profile
      if(_isFirstTimeProfile) {
        return ProfileFormWidget();
      }

      // show welcome and continue button
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          createHeader('home.welcome'.tr(
                  namedArgs: { 'firstName': _firstName ?? 'guest' })
          ),
          SizedBox(height: 50),
          ElevatedButton(
              child: Text('generic.action_continue'.tr()),
              onPressed: () {
                final page = AssignedOrderListPage();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => page)
                );
              }
          )
        ],
      );
    }

    return _showLogoLogin();
  }

  Widget _showLogoLogin() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: Color.fromRGBO(38, 34, 97, 1),
          child: Row(
            children: [
              Image(image: AssetImage('assets/logo-big.png'), width: 350),
            ],
          ),
        ),

        Spacer(),
        SizedBox(height: 100),
        InkWell(
          onTap: () async {
            setState(() {});
            setIsNotDemo();

            final page = LoginPage();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page)
            );
          },
          child: Container(
            child: ClipRRect(
              child: Image(image: AssetImage('assets/buttons/jobhop-sign-in.png')),
            ),),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
