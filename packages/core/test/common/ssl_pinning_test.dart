import 'package:core/common/ssl_pinning.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('HttpSSLPinning should initialize and return an http.Client', () async {
    expect(HttpSSLPinning.client, isA<http.Client>());
    await HttpSSLPinning.init();
    expect(HttpSSLPinning.client, isA<http.Client>());
  });
}

