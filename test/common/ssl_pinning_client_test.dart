import 'package:ditonton/common/ssl_pinning_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('SslPinningClient should return an http.Client instance', () async {
    await SslPinningClient.init();

    final client = SslPinningClient.client;
    expect(client, isA<http.Client>());
  });

  test('createLEClient should return an IOClient', () async {
    final client = await SslPinningClient.createLEClient();
    expect(client, isA<http.Client>());
  });
}