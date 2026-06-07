class DummyUser {
  final String username;
  final String password;
  final String route;

  const DummyUser({
    required this.username,
    required this.password,
    required this.route,
  });
}

class UserDummyData {
  const UserDummyData._();

  // Daftar akun dummy buat login pake username
  static const List<DummyUser> users = [
    DummyUser(
      username: 'resident',
      password: 'password123',
      route: '/resident',
    ),
    DummyUser(
      username: 'management',
      password: 'password123',
      route: '/management',
    ),
    DummyUser(
      username: 'security',
      password: 'password123',
      route: '/security',
    ),
    DummyUser(
      username: 'tenant',
      password: 'password123',
      route: '/tenant',
    ),
  ];
}