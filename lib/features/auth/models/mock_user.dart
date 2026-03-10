class MockUser {
  final String id;
  final String username;
  final String email;
  final String displayName;

  MockUser({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
  });
}

// Mock database of users
final List<MockUser> mockUsers = [
  MockUser(
    id: '1',
    username: 'admin',
    email: 'admin@example.com',
    displayName: 'Admin User',
  ),
  MockUser(
    id: '2',
    username: 'charlie',
    email: 'charlie@example.com',
    displayName: 'Charlie Puth',
  ),
  MockUser(
    id: '3',
    username: 'john',
    email: 'john@example.com',
    displayName: 'John Doe',
  ),
  MockUser(
    id: '4',
    username: 'jane',
    email: 'jane@example.com',
    displayName: 'Jane Smith',
  ),
  MockUser(
    id: '5',
    username: 'approver',
    email: 'approver@example.com',
    displayName: 'Approver Team',
  ),
];
