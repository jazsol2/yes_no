class User {
  final int id;
  final String email;
  final String? name;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    this.name,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'isActive': isActive,
    };
  }

  User copyWith({
    int? id,
    String? email,
    String? name,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }
}
