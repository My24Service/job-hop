import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'package:jobhop/utils/state.dart';
import 'package:jobhop/company/pages/home.dart';


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
            child: JobHopHome(),
        )
    ),
  );
}
