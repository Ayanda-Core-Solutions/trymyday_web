import 'dart:js_interop';

@JS('window.open')
external JSAny? _windowOpen(JSString url, JSString target);

Future<bool> openExternalUrl(Uri uri) async {
  return _windowOpen(uri.toString().toJS, '_blank'.toJS) != null;
}
