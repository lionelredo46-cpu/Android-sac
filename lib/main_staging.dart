import 'bootstrap.dart';
import 'core/config/flavor_config.dart';

/// API de recette hébergée sur Railway (données de démonstration, paiements Sandbox).
const stagingApiBaseUrl = 'https://afram.up.railway.app';

void main() => bootstrap(flavor: Flavor.staging, appName: 'UniParent Recette', apiBaseUrl: stagingApiBaseUrl);
