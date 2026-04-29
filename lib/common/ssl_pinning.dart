import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

const tmdbCertificateAsset = 'assets/certificates/themoviedb_org.pem';

typedef CertificateAssetLoader = Future<ByteData> Function(String assetPath);

Future<SecurityContext> createPinnedSecurityContext({
  String certificateAssetPath = tmdbCertificateAsset,
  CertificateAssetLoader? loadCertificate,
}) async {
  final loader = loadCertificate ?? rootBundle.load;
  final certificate = await loader(certificateAssetPath);
  final certificateBytes = certificate.buffer.asUint8List(
    certificate.offsetInBytes,
    certificate.lengthInBytes,
  );

  return SecurityContext(withTrustedRoots: false)
    ..setTrustedCertificatesBytes(certificateBytes);
}

Future<http.Client> createPinnedHttpClient({
  String certificateAssetPath = tmdbCertificateAsset,
  CertificateAssetLoader? loadCertificate,
}) async {
  final securityContext = await createPinnedSecurityContext(
    certificateAssetPath: certificateAssetPath,
    loadCertificate: loadCertificate,
  );
  final httpClient = HttpClient(context: securityContext);
  return IOClient(httpClient);
}
