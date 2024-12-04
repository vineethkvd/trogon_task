import '../../../core/helpers/network/api_endpoints.dart';
import '../../../core/helpers/network/network_api_services.dart';

class HomeRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> subjectApi() async {
    final String url = ApiEndPoints.baseURL + ApiEndPoints.subject;
    dynamic response = await _apiService.getApi(url);
    return response;
  }
}
