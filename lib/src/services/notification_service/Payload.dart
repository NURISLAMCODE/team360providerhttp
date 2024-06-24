class Payload {

  String? image;
  String? type;
  String? clickAction;

  Payload({this.image, this.type, this.clickAction});

  Payload.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    type = json['type'];
    clickAction = json['click_action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['type'] = type;
    data['click_action'] = clickAction;
    return data;
  }
}
