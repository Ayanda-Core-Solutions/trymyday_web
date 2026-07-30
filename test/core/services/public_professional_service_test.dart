import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:trymyday_web/core/services/public_professional_service.dart';

void main() {
  test('fetches one sanitized professional by id or slug', () async {
    late Uri requestedUri;
    final service = PublicProfessionalService(
      projectId: 'trymyday-nonprod',
      region: 'us-central1',
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          '{"professionals":[{"id":"pro-1","displayName":"Sam"}]}',
          200,
        );
      }),
    );

    final result = await service.fetchByIdOrSlug('sam-profile');

    expect(
      requestedUri.toString(),
      'https://us-central1-trymyday-nonprod.cloudfunctions.net/'
      'getPublicProfessionals?id=sam-profile',
    );
    expect(result, {'id': 'pro-1', 'displayName': 'Sam'});
  });

  test('returns null when no public professional matches', () async {
    final service = PublicProfessionalService(
      httpClient: MockClient(
        (_) async => http.Response('{"professionals":[]}', 200),
      ),
    );

    expect(await service.fetchByIdOrSlug('missing'), isNull);
  });

  test('rejects an unavailable directory response', () async {
    final service = PublicProfessionalService(
      httpClient: MockClient(
        (_) async => http.Response('{"error":"unavailable"}', 503),
      ),
    );

    expect(
      () => service.fetchByIdOrSlug('sam-profile'),
      throwsA(isA<StateError>()),
    );
  });
}
