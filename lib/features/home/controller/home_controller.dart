import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/shared/component/widgets/custom_toast.dart';
import '../model/subject_model.dart';
import '../repository/home_repository.dart';

class HomeController extends ChangeNotifier{
  final _api = HomeRepository();
  bool isLoading = false;
  var subjectModel = SubjectModel();
  var subjectList = <SubjectModel>[];
  Future<void> fetchSubject() async {
    try {
      isLoading = true;
      notifyListeners(); // Notify the UI that loading is in progress.

      final response = await _api.subjectApi();
      if (response != null && response['status'] == 200) {
        final List<dynamic> responseData = response['data'];
        subjectList.clear(); // Clear old data.
        subjectList.addAll(
          responseData.map((json) => SubjectModel.fromJson(json)).toList(),
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