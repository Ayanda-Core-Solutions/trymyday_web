import 'dart:js_interop';

@JS('window.open')
external JSAny? _windowOpen(JSString url, JSString target);

Future<void> openExternalUrl(Uri uri) async {
  _windowOpen(uri.toString().toJS, '_blank'.toJS);
}
