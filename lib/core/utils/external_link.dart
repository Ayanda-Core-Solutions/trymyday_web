import 'external_link_stub.dart'
    if (dart.library.js_interop) 'external_link_web.dart'
    as impl;

Future<bool> openExternalUrl(Uri uri, {String target = '_blank'}) =>
    impl.openExternalUrl(uri, target: target);
