import '../../../core/helpers/network/api_endpoints.dart';
import '../../../core/helpers/network/network_api_services.dart';

class ModuleRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> moduleApi({required String moduleId}) async {
    final String url = ApiEndPoints.moduleId + moduleId;
    dynamic response = await _apiService.getApi(url);
    return response;
  }
}