import 'package:mrtlib/mrtlib.dart';

main() {
  final map = new MRTMap();
  final routes = map.findRoutes('大安', '忠孝復興');
  print('Possible routes between 大安 and 忠孝復興 are including...');
  for (var route in routes) {
    print(route);
  }
}
