class User {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String image;
  final String gender;
  final String phone;
  final String address;
  final String accessToken;
  final String refreshToken;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.image,
    required this.gender,
    required this.phone,
    required this.address,
    required this.accessToken,
    required this.refreshToken,
  });

  String get fullName {
    return '$firstName $lastName';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final addressData = json['address'];

    return User(
      id: (json['id'] as num?)?.toInt() ?? 0,

      firstName: json['firstName']?.toString() ?? '',

      lastName: json['lastName']?.toString() ?? '',

      username: json['username']?.toString() ?? '',

      email: json['email']?.toString() ?? '',

      image: json['image']?.toString() ?? '',

      gender: json['gender']?.toString() ?? '',

      phone: json['phone']?.toString() ?? '',

      address: addressData is Map
          ? addressData['address']?.toString() ?? ''
          : '',

      accessToken: json['accessToken']?.toString() ??
          json['token']?.toString() ??
          '',

      refreshToken: json['refreshToken']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'image': image,
      'gender': gender,
      'phone': phone,
      'address': {
        'address': address,
      },
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}