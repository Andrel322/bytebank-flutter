import 'package:bytebanksqlite/http/interceptors/LoggingInterceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:http_interceptor/http_interceptor.dart';

final Client client =
    HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);
final String baseUrl = 'http://192.168.0.34:8080/transactions';
