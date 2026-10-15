import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profilee/main.dart';

void main() {
  testWidgets('home shows profile and hobbies', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Yuan Manarang'), findsOneWidget);
    expect(find.text('My Hobbies'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('like button increases the count', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Like'));
    await tester.pump();

    expect(find.text('1 Likes'), findsOneWidget);
  });

  testWidgets('profile picture opens the edit form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Edit profile picture'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Change picture'), findsOneWidget);
  });

  testWidgets('details page uses a Hero image', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.widgetWithText(TextButton, 'View details'));
    await tester.pumpAndSettle();

    expect(find.text('Profile Details'), findsOneWidget);
    expect(find.byType(Hero), findsOneWidget);
  });

  testWidgets('edit form validates and updates profile', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Edit profile'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('nameField')), '');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Enter a valid email containing @'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
    expect(find.text('Enter a valid age'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('nameField')), 'New Name');
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'new@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('hobbiesField')),
      'Coding\nCooking',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'secret');
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'secret',
    );
    await tester.enterText(find.byKey(const Key('ageField')), '20');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('New Name'), findsOneWidget);
    expect(find.text('new@example.com'), findsOneWidget);
    expect(find.text('Profile saved'), findsOneWidget);
    expect(find.text('Coding'), findsOneWidget);
    await tester.ensureVisible(find.text('Cooking'));
    expect(find.text('Cooking'), findsOneWidget);
  });
}
