class GoogleAccountModel {
  String? displayName;
  String email;
  String? photoUrl;
  GoogleAccountModel({
    this.displayName,
    required this.email,
    this.photoUrl,
  });

  @override
  String toString() => 'GoogleAccount(displayName: $displayName, email: $email, photoUrl: $photoUrl)';

}
