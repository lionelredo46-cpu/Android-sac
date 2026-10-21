import 'bootstrap.dart';
import 'core/config/flavor_config.dart';

/// Démo autonome : aucune connexion au serveur, l'API est simulée sur l'appareil
/// avec sa base de données locale (core/demo/). Comptes de démonstration à la connexion.
void main() => bootstrap(flavor: Flavor.dev, appName: 'UniParent Démo', apiBaseUrl: 'http://uniparent.local', localBackend: true);
