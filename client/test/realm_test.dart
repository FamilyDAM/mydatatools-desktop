import 'package:client/family_dam_app.dart';

import 'package:client/pages/home.dart';
import 'package:client/models/app_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:realm/realm.dart';

void main() {
  test("create db", () async {
    var config = Configuration.local([Apps.schema]);
    var realm = Realm(config);

    expect(realm, isNotNull);
  });

  testWidgets('FamilyDamApp should build and display properly', (WidgetTester tester) async {
    await tester.pumpWidget(const FamilyDamApp());

    expect(find.text('Family D.A.M.'), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);
  });
}
