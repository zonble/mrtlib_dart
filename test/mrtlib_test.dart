import 'package:mrtlib/mrtlib.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    MRTMap map;

    setUp(() {
      map = new MRTMap();
    });

    test('First Test', () {
      final routes = map.findRoutes('大安', '忠孝復興');
      expect(routes.length > 0, isTrue);
      for (var route in routes) {
        expect(route.links.length > 0, isTrue);
        expect(route.from.name == '大安', isTrue);
        expect(route.links.last.to.name == '忠孝復興', isTrue);
      }
    });

    test('Invalid Input', () {
      try {
        map.findRoutes('東京', '京都');
        fail('There should be an error.');
      } catch (err) {
        expect(err != null, isTrue);
      }
    });

    test('Invalid Input', () {
      try {
        map.findRoutes(null, null);
        fail('There should be an error.');
      } catch (err) {
        expect(err != null, isTrue);
      }
    });

    test('Invalid Input', () {
      try {
        map.findRoutes('大安', '大安');
        fail('There should be an error.');
      } catch (err) {
        expect(err != null, isTrue);
      }
    });

    test('Invalid Input', () {
      try {
        map.findRoutes('大安', '');
        fail('There should be an error.');
      } catch (err) {
        expect(err != null, isTrue);
      }
    });

    test('Invalid Input', () {
      try {
        map.findRoutes('', '大安');
        fail('There should be an error.');
      } catch (err) {
        expect(err != null, isTrue);
      }
    });

    test('Invalid Input', () {
      try {
        map.findRoutes('', '');
        fail('There should be an error.');
      } catch (err) {
        expect(err != null, isTrue);
      }
    });
  });
}
