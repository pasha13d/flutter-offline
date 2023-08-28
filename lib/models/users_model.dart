class Users {
  int? oid;
  String? name;
  String? address;

  Users({
    this.oid,
    this.name,
    this.address,
  });

  Users.fromJson(Map<String?, dynamic> json) {
    oid = json['oid'];
    name = json['name'];
    address = json['address'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['oid'] = this.oid;
    data['name'] = this.name;
    data['address'] = this.address;

    return data;
  }

  Users copyWith({String? name, String? address}) {
    return Users(
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }
}