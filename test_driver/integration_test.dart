import 'package:integration_test/integration_test_driver.dart';

/// Pilote des tests d'intégration en mode profile (AOT, plus léger qu'un build debug) :
/// flutter drive --driver=test_driver/integration_test.dart --target=integration_test/timetable_flow_test.dart --profile --flavor demo
Future<void> main() => integrationDriver();
