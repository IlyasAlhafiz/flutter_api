import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_api/models/buku_model.dart';

class BukuService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/posts';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get all posts
  static Future<BukuModel> listBuku() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return BukuModel.fromJson(json);
    } else {
      throw Exception('Failed to load Buku');
    }
  }

  // Get single post by ID
  static Future<DataBuku> showBuku(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DataBuku.fromJson(data['data']);
    } else {
      throw Exception('Failed to load post');
    }
  }

  // Create new post
  static Future<bool> createBuku(
    String kodeBuku;
    String judul;
    String penulis;
    String penerbit;
    int tahunTerbit;
    int stok;
    int kategoriId;
    Uint8List imageBytes,
    String imageName,
  ) async {
    final token = await getToken();
    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri);

    request.fields['kodebuku'] = kodeBuku;
    request.fields['judul'] = judul;
    request.fields['penulis'] = penulis;
    request.fields['penulis'] = penerbit;
    request.fields['status'] = status.toString();

    if (imageBytes != null && imageName != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'foto',
          imageBytes,
          filename: imageName,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();
    return response.statusCode == 201;
  }

  // Update existing post
  static Future<bool> updateBuku(
    int id,
    String title,
    String content,
    int status,
    Uint8List? imageBytes,
    String? imageName,
  ) async {
    final token = await getToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/$id?_method=PUT'),
    );

    request.fields['title'] = title;
    request.fields['content'] = content;
    request.fields['status'] = status.toString();

    if (imageBytes != null && imageName != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'foto',
          imageBytes,
          filename: imageName,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();
    return response.statusCode == 200;
  }

  // Delete post
  static Future<bool> deleteBuku(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}
