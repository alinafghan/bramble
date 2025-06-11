import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app/blocs/authentication_bloc/authentication_bloc.dart';

class FakeUser extends Fake implements User {}

void main() {
  final fakeUser = FakeUser();

  group('AuthenticationEvent props tests', () {
    test('AuthenticationUserChanged props', () {
      final event = AuthenticationUserChanged(fakeUser);
      expect(event.props, [fakeUser]);
    });

    test('AuthenticationLogoutRequested props', () {
      final event = AuthenticationLogoutRequested();
      expect(event.props, []);
    });

    test('AuthenticationLoginRequested props', () {
      const event = AuthenticationLoginRequested(
        'email@example.com',
        'password123',
        'Alina',
      );
      expect(event.props, ['email@example.com', 'password123', 'Alina']);
    });

    test('AuthenticationSignUpRequested props', () {
      const event = AuthenticationSignUpRequested(
        'signup@example.com',
        'mypassword',
        'NewUser',
      );
      expect(event.props, ['signup@example.com', 'mypassword', 'NewUser']);
    });

    test('GetUserEvent props', () {
      var event = GetUserEvent();
      expect(event.props, []);
    });

    test('AddProfilePicEvent props', () {
      const event = AddProfilePicEvent(profileUrl: 'https://image.com/pfp.png');
      expect(event.props, ['https://image.com/pfp.png']);
    });
  });
}
