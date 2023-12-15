import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hajir/core/localization/l10n/strings.dart';
import 'package:http/http.dart' as http;

import 'errors/exceptions.dart';

abstract class HttpClient {
  Future<T> get<T>({
    required String url,
    required T Function(String) convertResponseToModel,
    Map<String, String>? headers,
  });

  Future<T> post<T>({
    required String url,
    required T Function(String) convertResponseToModel,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
}

class HttpClientImpl implements HttpClient {
  final http.Client _client;
  HttpClientImpl(this._client);

  @override
  Future<T> get<T>({
    required String url,
    required T Function(String) convertResponseToModel,
    Map<String, String>? headers,
  }) async {
    http.Response response;
    try {
      response = await _client
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));
      if (kDebugMode) {
        print(response.request?.url);
        print(response.body);
      }
    } catch (ex) {
      throw ServerException(message: ex.toString());
    }
    return _request(
      response: response,
      convertResponseToModel: convertResponseToModel,
    );
  }

  @override
  Future<T> post<T>({
    required String url,
    required T Function(String) convertResponseToModel,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse(url),
            headers: headers,
            body: body,
            encoding: encoding,
          )
          .timeout(
            const Duration(seconds: 30),
          );
      if (kDebugMode) {
        print(response.request?.url);
        print(response.body);
      }
    } on ServerException catch (ex) {
      throw ServerException(message: ex.toString());
    } on TimeoutException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    return _request(
      response: response,
      convertResponseToModel: convertResponseToModel,
    );
  }

  Future<T> _request<T>({
    required http.Response response,
    required T Function(String) convertResponseToModel,
  }) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return convertResponseToModel(response.body);
      } on ServerException catch (ex) {
        throw ServerException(message: ex.toString());
      } on TimeoutException {
        rethrow;
      } catch (ex) {
        throw ServerException(message: ex.toString());
      }
    } else {
      try {
        final responseBody =
            json.decode(response.body) as Map<String, dynamic>?;
        throw ServerException(
            message:
                (responseBody?["error"] as String?) ?? "Something went wrong");
      } on FormatException catch (e) {
        throw ServerException(message: e.toString());
      } catch (e) {
        rethrow;
      }
    }
  }
}
