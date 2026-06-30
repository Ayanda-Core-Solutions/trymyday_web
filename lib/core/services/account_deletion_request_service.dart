import 'package:cloud_functions/cloud_functions.dart';

import '../config/app_environment.dart';

class AccountDeletionRequestResult {
  const AccountDeletionRequestResult({
    required this.requestId,
    required this.status,
    required this.alreadyExists,
  });

  final String requestId;
  final String status;
  final bool alreadyExists;

  factory AccountDeletionRequestResult.fromMap(Map<Object?, Object?> map) {
    return AccountDeletionRequestResult(
      requestId: (map['requestId'] ?? '').toString(),
      status: (map['status'] ?? 'requested').toString(),
      alreadyExists: map['alreadyExists'] == true,
    );
  }
}

class AccountDeletionRequestService {
  AccountDeletionRequestService({FirebaseFunctions? functions})
    : _functions = functions;

  final FirebaseFunctions? _functions;

  Future<AccountDeletionRequestResult> submit({
    required String fullName,
    required String email,
    required String reason,
  }) async {
    final functions =
        _functions ??
        FirebaseFunctions.instanceFor(
          region: AppEnvironment.cloudFunctionsRegion,
        );
    final callable = functions.httpsCallable('requestWebAccountDeletion');
    final result = await callable.call<Map<Object?, Object?>>({
      'fullName': fullName.trim(),
      'email': email.trim(),
      'reason': reason.trim(),
      'retentionNoticeAcknowledged': true,
    });

    return AccountDeletionRequestResult.fromMap(result.data);
  }
}
