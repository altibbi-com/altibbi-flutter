class Media {
  String? id;
  String? type;
  String? name;
  String? path;
  String? extension;
  String? url;
  int? size;

  Media({this.id, this.type, this.name, this.path, this.extension, this.size,this.url});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    type = json['type'] as String?;
    name = json['name'] as String?;
    path = json['path'] as String?;
    extension = json['extension'] as String?;
    url = json['url'] as String?;
    size = json['size'] as int?;
  }

}
