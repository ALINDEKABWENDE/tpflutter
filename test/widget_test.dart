import 'package:flutter_test/flutter_test.dart';
import 'package:tpalindecv/main.dart';
import 'package:tpalindecv/services/api_service.dart';

void main() {
  testWidgets("L'écran de connexion s'affiche", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Laisse les animations d'apparition se terminer (le fond anime en continu).
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Portfolio'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);

    final createLink = find.text('Pas de compte ? Créer un compte');
    await tester.ensureVisible(createLink);
    await tester.pump();
    await tester.tap(createLink);
    await tester.pump();

    expect(find.text('Créer mon compte'), findsOneWidget);
    expect(find.text('Déjà un compte ? Se connecter'), findsOneWidget);
  });

  test('Membre keeps the image URL returned by the API', () {
    final membre = Membre.fromJson({
      'id': 1,
      'nom': 'Test',
      'postnom': 'K',
      'prenom': 'Jean',
      'lieu_naissance': 'Goma',
      'date_naissance': '2000-01-01',
      'parente': 'Frère',
      'image': 'uploads/famille/photo.png',
      'image_url':
          'http://localhost/api-test-main/public/uploads/famille/photo.png',
    });

    expect(
      membre.imageUrl,
      'http://localhost/api-test-main/public/uploads/famille/photo.png',
    );
  });
}
