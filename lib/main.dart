import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';

import 'package:jobhop/utils/state.dart';
import 'package:jobhop/company/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  getIt.registerSingleton<AppModel>(AppModelImplementation(),
      signalsReady: true);

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('nl', 'NL'),
          Locale('en', 'US'),
        ],
        path: 'resources/langs',
        fallbackLocale: Locale('en', 'US'),
        child: JobHopHome(),
    ),
  );
}
