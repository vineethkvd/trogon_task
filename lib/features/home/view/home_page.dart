import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trogon_task/features/modules/view/module_page.dart';
import '../../../core/utils/config/styles/colors.dart';
import '../controller/home_controller.dart';
import '../model/subject_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeController>(context, listen: false).fetchSubject();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);

    return Container(
      color: AppColor.appBarColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColor.appBarColor,
            centerTitle: true,
            title: Text(
              "Subject",
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
                  child: buildSubjectGrid(homeController.subjectList)),
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

  Widget buildSubjectGrid(List<SubjectModel> subjectList) {
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
                builder: (context) => ModulePage(
                  subjectId: subject.id.toString(),
                  title: subject.title.toString(),
                  img: subject.image.toString(),
                ),
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
                        imageUrl: subject.image ?? '',
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
