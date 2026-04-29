import 'dart:io';

import 'package:ditonton/common/ssl_pinning.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('creates pinned security context from bundled certificate asset',
      () async {
    final context = await createPinnedSecurityContext();

    expect(context, isA<SecurityContext>());
  });

  test('creates http client backed by pinned security context', () async {
    final client = await createPinnedHttpClient();

    expect(client, isA<http.Client>());
    client.close();
  });

  test('uses requested certificate asset path when custom loader is supplied',
      () async {
    String? requestedPath;
    final certificate = await rootBundle.load(tmdbCertificateAsset);

    final context = await createPinnedSecurityContext(
      certificateAssetPath: 'assets/certificates/custom.pem',
      loadCertificate: (assetPath) async {
        requestedPath = assetPath;
        return certificate;
      },
    );

    expect(requestedPath, 'assets/certificates/custom.pem');
    expect(context, isA<SecurityContext>());
  });
}
