import '../../../core/helpers/network/api_endpoints.dart';
import '../../../core/helpers/network/network_api_services.dart';

class ModuleRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> subjectApi({required String subId}) async {
    final String url = ApiEndPoints.subId + subId;
    dynamic response = await _apiService.getApi(url);
    return response;
  }
}
