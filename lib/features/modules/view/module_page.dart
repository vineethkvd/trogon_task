import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trogon_task/features/modules/model/subject_model.dart';
import 'package:trogon_task/features/videos/view/video_page.dart';
import '../../../core/utils/config/styles/colors.dart';
import '../controller/module_controller.dart';

class ModulePage extends StatefulWidget {
  String subjectId, title, img;
  ModulePage(
      {super.key,
      required this.subjectId,
      required this.title,
      required this.img});

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ModuleController>(context, listen: false)
          .fetchModule(subId: widget.subjectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<ModuleController>(context);

    return Container(
      color: AppColor.appBarColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            elevation: 0,
            backgroundColor: AppColor.appBarColor,
            centerTitle: true,
            title: Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "poppinsSemiBold",
              ),
            ),
          ),
          body: homeController.isLoading
              ? Container(color: Colors.white, child: buildShimmerEffect())
              : Container(
                  color: Colors.white,
                  child: buildSubjectGrid(homeController.moduleList)),
        ),
      ),
    );
  }

  Widget buildShimmerEffect() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
      },
    );
  }

  Widget buildSubjectGrid(List<ModuleModel> subjectList) {
    if (subjectList.isEmpty) {
      return const Center(
        child: Text(
          "No subjects found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: subjectList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, index) {
        final subject = subjectList[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    VideoPage(moduleId: subject.id.toString()),
              ));
            },
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10.0)),
                      child: CachedNetworkImage(
                        imageUrl: widget.img ?? '',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      subject.title ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
