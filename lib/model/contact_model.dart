class ContactData{
  final String? name;
  final String? role;
  final String? factory;
  final String? phoneNumber;

  ContactData({
    this.name,
    this.role,
    this.factory,
    this.phoneNumber
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      name: json['name'],
      role: json['role'],
      factory: json['factory'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'factory': factory,
      'phoneNumber': phoneNumber
    };
  }
}