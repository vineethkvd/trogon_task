import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/shared/component/widgets/custom_toast.dart';
import '../model/video_model.dart';
import '../repository/module_repository.dart';

class VideoController extends ChangeNotifier {
  final _api = ModuleRepository();
  bool isLoading = false;
  String vidUrl = '';
  String curTitle = '';
  String curDes = '';
  var moduleModel = VideoModel();
  var moduleList = <VideoModel>[];
  Future<void> fetchModules({required String moduleId}) async {
    try {
      isLoading = true;
      notifyListeners(); // Notify the UI that loading is in progress.

      final response = await _api.moduleApi(moduleId: moduleId);
      if (response != null && response['status'] == 200) {
        final List<dynamic> responseData = response['data'];
        moduleList.clear(); // Clear old data.
        moduleList.addAll(
          responseData.map((json) => VideoModel.fromJson(json)).toList(),
        );
        if (moduleList.isNotEmpty) {
          vidUrl = moduleList.first.videoUrl.toString();
          curTitle = moduleList.first.title.toString();
          curDes = moduleList.first.description.toString();
        }
      } else {
        CustomToast.showCustomToast(message: "Unexpected error occurred");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }
    } finally {
      isLoading = false;
      notifyListeners(); // Notify the UI to rebuild with updated data.
    }
  }
}
