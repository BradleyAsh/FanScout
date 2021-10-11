class AUser {
  final String id;
  final String fullname;
  final String email;
  final String userRole;
  final String team;
  final String photoUrl;

  AUser(
      {this.id,
      this.fullname,
      this.email,
      this.userRole,
      this.team,
      this.photoUrl});

  AUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullname = data['fullname'],
        email = data['email'],
        userRole = data['userRole'],
        team = data['team'],
        photoUrl = data['photoUrl'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'userRole': userRole,
      'team': team,
      'photoUrl': photoUrl,
    };
  }
}
