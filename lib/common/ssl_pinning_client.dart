import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinningClient {
  static http.Client? _clientInstance;

  static http.Client get client => _clientInstance!;

  static Future<http.Client> createLEClient() async {
    final sslCert = await rootBundle.load('assets/certificates/themoviedb.crt');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

    HttpClient httpClient = HttpClient(context: securityContext);
    httpClient.connectionTimeout = const Duration(seconds: 10);

    // Tolak semua sertifikat yang tidak cocok dengan SecurityContext di atas
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => false;

    return IOClient(httpClient);
  }

  static Future<void> init() async {
    _clientInstance = await createLEClient();
  }
}