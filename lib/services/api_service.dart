import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:utsavadmin/services/secure_storage_service.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiService {
  static const String baseUrl = "http://192.168.27.50:5000/api/v1";

  /// 🔥 ADD THIS
  static const String imageBaseUrl = "http://192.168.27.50:5000";

  final box = GetStorage();

  /// 🔐 HEADERS
  Future<Map<String, String>> getHeaders({bool withAuth = false}) async {
    final token = await SecureStorageService.getToken();
print("app_token: $token");
    final headers = {
      "Content-Type": "application/json",
      "x-app-type": "admin"
    };

    if (withAuth && token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  /// 📤 POST (JSON)
  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> body, {
        bool withAuth = false,
      }) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    final response = await http.post(
      url,
      headers: await getHeaders(withAuth: withAuth),
      body: jsonEncode(body),
    );

    return _processResponse(response);
  }

  /// 📥 GET
  Future<Map<String, dynamic>> get(
      String endpoint, {
        bool withAuth = false,
        Map<String, String>? queryParams,
      }) async {
    final uri = Uri.parse("$baseUrl/$endpoint")
        .replace(queryParameters: queryParams);

    final response =
    await http.get(uri, headers: await getHeaders(withAuth: withAuth));

    return _processResponse(response);
  }

  /// 🔄 PUT (JSON)
  Future<Map<String, dynamic>> put(
      String endpoint,
      Map<String, dynamic> body, {
        bool withAuth = false,
      }) async {
    final url = Uri.parse("$baseUrl/$endpoint");

    final response = await http.put(
      url,
      headers: await getHeaders(withAuth: withAuth),
      body: jsonEncode(body),
    );

    print("PUT $endpoint -> status: ${response.statusCode}");
    print("PUT $endpoint -> body: ${response.body}");

    return _processResponse(response);
  }

  /// 🔥 COMMON MULTIPART METHOD (REUSABLE)
  Future<Map<String, dynamic>> _multipartRequest(
      String method,
      String endpoint, {
        required Map<String, String> fields,
        required List<File> files,
        required String fileKey,
      }) async {
    final uri = Uri.parse("$baseUrl/$endpoint");

    var request = http.MultipartRequest(method, uri);

    /// 🔐 HEADERS
    request.headers.addAll(await getHeaders(withAuth: true));

    /// 📦 FIELDS
    request.fields.addAll(fields);

    /// 🖼 FILES
    for (var file in files) {
      final mimeType = lookupMimeType(file.path) ?? "image/jpeg";
      final mimeSplit = mimeType.split('/');

      request.files.add(
        await http.MultipartFile.fromPath(
          fileKey,
          file.path,
          contentType: MediaType(
            mimeSplit[0],
            mimeSplit[1],
          ),
        ),
      );
    }

    /// 🚀 SEND
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    /// 🧪 DEBUG
    print("$method $endpoint -> STATUS: ${response.statusCode}");
    print("$method $endpoint -> BODY: ${response.body}");

    /// ⚠️ SAFE PARSE
    try {
      return _processResponse(response);
    } catch (e) {
      print("❌ RAW ERROR RESPONSE: ${response.body}");
      throw Exception("Invalid server response");
    }
  }

  /// 📤 MULTIPART POST (CREATE)
  Future<Map<String, dynamic>> multipartPost(
      String endpoint, {
        required Map<String, String> fields,
        required List<File> files,
        required String fileKey,
      }) async {
    return _multipartRequest(
      "POST",
      endpoint,
      fields: fields,
      files: files,
      fileKey: fileKey,
    );
  }

  /// 🔄 MULTIPART PUT (UPDATE)
  Future<Map<String, dynamic>> multipartPut(
      String endpoint, {
        required Map<String, String> fields,
        required List<File> files,
        required String fileKey,
      }) async {
    return _multipartRequest(
      "PUT",
      endpoint,
      fields: fields,
      files: files,
      fileKey: fileKey,
    );
  }

  /// 🔍 RESPONSE HANDLER
  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw Exception("Empty response from server");
    }

    final decodedBody = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedBody;
    } else {
      throw Exception(
        decodedBody["message"] ?? "Something went wrong",
      );
    }
  }

  /// 🖼 GET FULL IMAGE URL
  String getImageUrl(String path) {
    if (path.isEmpty) return "";

    return "$imageBaseUrl/${path.replaceAll("\\", "/")}";
  }
}