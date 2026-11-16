import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    // 1. Buat alamat endpoint.
    final Uri url = Uri.parse('$_baseUrl/posts');

    // 2. Kirim request.
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 15));

    // 3. Cek status code.
    if (response.statusCode == 200) {
      // 4. Ubah JSON menjadi objek.
      final List<dynamic> decoded = jsonDecode(response.body) as List<dynamic>;
      return decoded
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Gagal mengambil pengumuman. Kode: ${response.statusCode}');
  }

  Future<List<Map<String, dynamic>>> fetchComments(int postId) async {
    // 1. Buat alamat endpoint.
    final Uri url = Uri.parse('$_baseUrl/posts/$postId/comments');

    // 2. Kirim request.
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 15));

    // 3. Cek status code.
    if (response.statusCode == 200) {
      // 4. Ubah JSON menjadi daftar komentar.
      final List<dynamic> decoded = jsonDecode(response.body) as List<dynamic>;
      return decoded
          .map((item) => item as Map<String, dynamic>)
          .toList();
    }

    throw Exception('Gagal mengambil komentar. Kode: ${response.statusCode}');
  }

  Future<Post> createPost({
    required String title,
    required String body,
  }) async {
    // 1. Buat alamat endpoint.
    final Uri url = Uri.parse('$_baseUrl/posts');

    // 2. Kirim request POST dengan jsonEncode().
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'body': body,
        'userId': 1,
      }),
    ).timeout(const Duration(seconds: 15));

    // 3. Cek status code.
    if (response.statusCode == 201) {
      // 4. Ubah JSON respons menjadi objek Post.
      final Map<String, dynamic> decoded =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Post.fromJson(decoded);
    }

    throw Exception('Gagal mengirim pengumuman. Kode: ${response.statusCode}');
  }
}
