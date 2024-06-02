class AppUser {
  final String uid;
  final String email;
  final String name;
  final String phoneNumber;
  final bool emailVerified;
  final String createdAt;

  // Public Constructor
  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.emailVerified,
    required this.createdAt,
  });

  // To convert a Firestore JSON Map to our AppUser
  factory AppUser.fromFireStore(Map<String, dynamic> fireStoreUser) => AppUser(
        uid: fireStoreUser['uid'],
        email: fireStoreUser['email'],
        name: fireStoreUser['name'],
        phoneNumber: fireStoreUser['phoneNumber'],
        emailVerified: fireStoreUser['emailVerified'],
        createdAt: fireStoreUser['createdAt'],
      );


  // Converting our AppUser to a JsonMap to upload to Firestore
  Map<String, dynamic> toMap() {
    return ({
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'emailVerified': emailVerified,
      'createdAt': createdAt,
    });
  }
}
