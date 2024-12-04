import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    if (kDebugMode) {
      print(url);
    }

    dynamic responseJson;
    try {
      final response =
      await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String url) async {
    if (kDebugMode) {
      print(url);
      print(data);
    }

    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future<dynamic> postMultipartApi(
      String url, Map<String, String> fields, List<http.MultipartFile> files) async {
    if (kDebugMode) {
      print(url);
    }

    dynamic responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      fields.forEach((key, value) {
        request.fields[key] = value;
      });
      request.files.addAll(files);

      var response = await request.send().timeout(const Duration(seconds: 10));

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      responseJson = jsonDecode(responseString);

      if (response.statusCode == 200) {
        return responseJson;
      } else {
        throw FetchDataException(
            'Error occured while communicating with server ${response.statusCode}');
      }
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return {'status': 200, 'data': responseJson};
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        return {'status': 400, 'data': responseJson};

      default:
        throw FetchDataException(
            'Error accoured while communicating with server ${response.statusCode}');
    }
  }
}