import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/shared/component/widgets/custom_toast.dart';
import '../model/subject_model.dart';
import '../repository/module_repository.dart';

class ModuleController extends ChangeNotifier{
  final _api = ModuleRepository();
  bool isLoading = false;
  var moduleModel = ModuleModel();
  var moduleList = <ModuleModel>[];
  Future<void> fetchModule({required String subId}) async {
    try {
      isLoading = true;
      notifyListeners(); // Notify the UI that loading is in progress.

      final response = await _api.subjectApi(subId: subId);
      if (response != null && response['status'] == 200) {
        final List<dynamic> responseData = response['data'];
        moduleList.clear(); // Clear old data.
        moduleList.addAll(
          responseData.map((json) => ModuleModel.fromJson(json)).toList(),
        );
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