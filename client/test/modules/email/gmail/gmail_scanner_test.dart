// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test Gmail Scanner', () async {
    //var config = Configuration.local([Apps.schema, Collection.schema]);
    //var realm = Realm(config);

    //var col = Collection("", "", "", "", "", ""); // TODO
    //var provider = null;

    // Build our app and trigger a frame.
    //GmailScanner scanner = GmailScanner(col, 0, EmailServices(realm));

    /**
    Stream<dynamic> messages = scanner.start(col, true);
    await Future.delayed(const Duration(seconds: 10));

    expect(
        messages.map((event) => event.id),
        mayEmitMultiple(emitsAnyOf(
            ["186ba13b3b175525", "186ba05afdccb86d", "186b9dbc804b65d3"])));
    **/
  });
}
