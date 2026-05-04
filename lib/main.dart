import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/services/app_remote_config.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppRemoteConfig.instance.initialize();
  runApp(const TryMyDayApp());
}
