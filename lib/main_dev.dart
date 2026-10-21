import 'bootstrap.dart';
import 'core/config/flavor_config.dart';

/// Développement : API locale (10.0.2.2 = machine hôte depuis l'émulateur Android).
/// Téléphone physique : --dart-define=API_BASE_URL=http://<IP-du-PC>:3000
void main() => bootstrap(flavor: Flavor.dev, appName: 'UniParent Dev', apiBaseUrl: 'http://10.0.2.2:3000');
