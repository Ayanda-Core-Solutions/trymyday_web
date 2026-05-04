import 'package:cloud_functions/cloud_functions.dart';

import '../config/app_environment.dart';

class ContactEmailService {
  ContactEmailService({FirebaseFunctions? functions})
    : _functions =
          functions ??
          FirebaseFunctions.instanceFor(
            region: AppEnvironment.cloudFunctionsRegion,
          );

  final FirebaseFunctions _functions;

  Future<void> send({
    required String name,
    required String email,
    required String message,
    String? mobile,
  }) async {
    final callable = _functions.httpsCallable('sendContactEmail');

    await callable.call<void>({
      'name': name,
      'email': email,
      'mobile': mobile,
      'message': message,
    });
  }
}
