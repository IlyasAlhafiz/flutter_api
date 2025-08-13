import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_api/models/kategori_model.dart';

class KategoriService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/kategoris';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get all posts
  static Future<KategoriModel> listPosts() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return KategoriModel.fromJson(json);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Get single post by ID
  static Future<DataKategori> showPost(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DataKategori.fromJson(data['data']);
    } else {
      throw Exception('Failed to load post');
    }
  }

  // Create new post
  static Future<bool> createPost(
    String nama,
  ) async {
    final token = await getToken();
    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri);

    request.fields['nama'] = nama;

    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();
    return response.statusCode == 201;
  }

  // Update existing post
  static Future<bool> updatePost(
    int id,
    String nama,
  ) async {
    final token = await getToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/$id?_method=PUT'),
    );

    request.fields['nama'] = nama;

    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();
    return response.statusCode == 200;
  }

  // Delete post
  static Future<bool> deletePost(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}
