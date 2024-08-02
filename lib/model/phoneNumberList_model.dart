class PhoneNumberList {
  final String phoneList;

  PhoneNumberList({required this.phoneList});

  factory PhoneNumberList.fromJson(Map<String, dynamic> json) {
    return PhoneNumberList(
      phoneList: json['phoneList'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneList': phoneList,
    };
  }
}
