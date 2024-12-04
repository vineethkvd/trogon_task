class SubjectModel {
  int? id;
  String? title;
  String? description;
  String? image;

  SubjectModel({this.id, this.title, this.description, this.image});

  SubjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    return data;
  }
}
