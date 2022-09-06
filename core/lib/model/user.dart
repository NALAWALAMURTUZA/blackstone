class User {
  const User._(
    this.name,
    this.email,
    this.phone, {
    this.id,
  });

  factory User.fromJson(Map json) {
    final id =
        json['_id']?.replaceAll('ObjectId(\"', '')?.replaceAll('\")', '');
    final name = json['name'];
    final email = json['email'];
    final phone = json['phone'];
    return User._(name, email, phone, id: id);
  }

  factory User.empty() {
    return const User._(
      "",
      "",
      "",
    );
  }

  final String id;
  final String name;
  final String email;
  final String phone;

  Map<String, dynamic> toJason() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "phone": phone,
    };
  }

  Map<String, dynamic> toUpdateJason() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
    };
  }

  User copyWith({
    String id,
    String name,
    String email,
    String phone,
  }) {
    return User._(
      name ?? this.name,
      email ?? this.email,
      phone ?? this.phone,
      id: id ?? this.id,
    );
  }
}
