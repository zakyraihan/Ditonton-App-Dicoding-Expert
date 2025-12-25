import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinningClient {
  static http.Client? _clientInstance;

  static http.Client get client => _clientInstance ?? http.Client();

  static Future<http.Client> createLEClient() async {

    const String fingerprint = "2f752ac5bc776c0160504de60fa2ef1380ffd6d6d97956fc9240cdaae0a53339";

    HttpClient httpClient = HttpClient();

    httpClient.connectionTimeout = const Duration(seconds: 10);

    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      if (host == "api.themoviedb.org") {
        final serverFingerprint = sha256.convert(cert.der).toString();
        return serverFingerprint == fingerprint;
      }
      return false;
    };

    return IOClient(httpClient);
  }

  static Future<void> init() async {
    _clientInstance = await createLEClient();
  }
}