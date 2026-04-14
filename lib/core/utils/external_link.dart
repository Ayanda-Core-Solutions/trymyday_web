import 'external_link_stub.dart'
    if (dart.library.js_interop) 'external_link_web.dart'
    as impl;

Future<void> openExternalUrl(Uri uri) => impl.openExternalUrl(uri);
