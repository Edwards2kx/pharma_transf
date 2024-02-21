class Utils {
  static String getInitials(String userName) {
    final initials = RegExp(r'\b\w')
        .allMatches(userName)
        .map((match) => match.group(0))
        .join();
    return initials.toUpperCase();
  }

  static String get2FirtsInitials(String userName) {
    final words = userName.split(' ');
    if (words.isEmpty) return '';
    final initials = words.take(2).map((word) => word[0]).join().toUpperCase();
    return initials;
  }
}
