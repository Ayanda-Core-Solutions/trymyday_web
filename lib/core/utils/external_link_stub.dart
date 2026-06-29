import 'package:url_launcher/url_launcher.dart';

Future<bool> openExternalUrl(Uri uri, {String target = '_blank'}) async {
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
