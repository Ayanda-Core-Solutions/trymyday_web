import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_environment.dart';

class PublicProfessionalService {
  PublicProfessionalService({
    http.Client? httpClient,
    String? projectId,
    String? region,
  }) : _httpClient = httpClient ?? http.Client(),
       _projectId = projectId ?? AppEnvironment.publicFunctionsProjectId,
       _region = region ?? AppEnvironment.cloudFunctionsRegion;

  final http.Client _httpClient;
  final String _projectId;
  final String _region;

  Future<Map<String, dynamic>?> fetchByIdOrSlug(String idOrSlug) async {
    final uri = Uri.https(
      '$_region-$_projectId.cloudfunctions.net',
      '/getPublicProfessionals',
      {'id': idOrSlug},
    );
    final response = await _httpClient.get(uri);
    if (response.statusCode != 200) {
      throw StateError('Professional directory is unavailable.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded['professionals'] is! List) {
      throw const FormatException('Invalid professional directory response.');
    }

    final records = decoded['professionals'] as List;
    if (records.isEmpty || records.first is! Map) return null;
    return Map<String, dynamic>.from(records.first as Map);
  }
}
