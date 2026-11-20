import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants.dart';
import '../../../core/exceptions.dart';
import '../../../core/utils.dart';
import 'models.dart';

/// Remote Data Source responsabil exclusiv de comunicarea HTTP cu API-ul REST.
abstract class StoreRemoteDataSource {
  Future<HomePageModel> fetchFeed();
  Future<ProductDetailModel> fetchProductDetails({String? productId});
}

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  final http.Client client;

  StoreRemoteDataSourceImpl({required this.client});

  @override
  Future<HomePageModel> fetchFeed() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.feedPath}');
    final decoded = await _getJson(uri);

    if (decoded is JsonMap) {
      return HomePageModel.fromJson(decoded);
    }
    throw ServerException('Format JSON neașteptat pentru /feed.');
  }

  @override
  Future<ProductDetailModel> fetchProductDetails({String? productId}) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.feedDetailsPath}',
    ).replace(
      queryParameters:
          (productId != null && productId.isNotEmpty) ? {'id': productId} : null,
    );
    final decoded = await _getJson(uri);

    if (decoded is JsonMap) {
      return ProductDetailModel.fromJson(decoded);
    }
    if (decoded is List && decoded.isNotEmpty) {
      final items = asMapList(decoded);
      if (items.isNotEmpty) {
        final matched = items.firstWhere(
          (item) => item['id']?.toString() == productId,
          orElse: () => items.first,
        );
        return ProductDetailModel.fromJson(matched);
      }
    }
    throw ServerException('Format JSON neașteptat pentru /feed/details.');
  }

  Future<dynamic> _getJson(Uri uri) async {
    try {
      final response = await client.get(
        uri,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(ApiConstants.timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final utf8Body = utf8.decode(response.bodyBytes);
        return json.decode(utf8Body);
      } else {
        throw ServerException(
          'Serverul a răspuns cu o eroare.',
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      throw ServerException(
        'Cererea a expirat (timeout). Serverul poate fi în curs de pornire.',
      );
    } on FormatException {
      throw ServerException('Răspunsul serverului nu este un JSON valid.');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Eroare de rețea: $e');
    }
  }
}
