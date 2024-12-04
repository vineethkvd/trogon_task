import 'package:http/http.dart' as http;

abstract class BaseApiServices {
  Future<dynamic> getApi(String url);

  Future<dynamic> postApi(dynamic data, String url);

  Future<dynamic> postMultipartApi(
      String url, Map<String, String> fields, List<http.MultipartFile> files);
}