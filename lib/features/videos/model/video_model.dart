class VideoModel {
  int? id;
  String? title;
  String? description;
  String? videoType;
  String? videoUrl;

  VideoModel(
      {this.id, this.title, this.description, this.videoType, this.videoUrl});

  VideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    videoType = json['video_type'];
    videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['video_type'] = this.videoType;
    data['video_url'] = this.videoUrl;
    return data;
  }
}
