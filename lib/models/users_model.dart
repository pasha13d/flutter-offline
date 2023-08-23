class Users {
  String? name;
  String? address;

  Users({
    this.name,
    this.address,
  });

  Users.fromJson(Map<String?, dynamic> json) {
    name = json['name'];
    address = json['address'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;

    return data;
  }
}