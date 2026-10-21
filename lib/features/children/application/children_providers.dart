import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/providers.dart';
import '../../../core/storage/cache_store.dart';
import '../../auth/application/session_controller.dart';
import '../domain/child.dart';

/// Enfants rattachés (parent) ou propre dossier (étudiant).
final childrenProvider = FutureProvider<Cached<List<Child>>>((ref) async {
  final user = ref.watch(sessionProvider).value;
  if (user == null) return Cached(const [], fromCache: false, updatedAt: DateTime.now());
  return ref.read(cacheStoreProvider).fetch(
        'children',
        () => ref.read(apiClientProvider).get<List<dynamic>>(ApiEndpoints.myChildren),
        (json) => (json! as List).map((e) => Child.fromJson(e as Map<String, dynamic>)).toList(),
      );
});

/// Enfant sélectionné (persisté) — le sélecteur en haut de l'accueil le modifie.
class ActiveChildIdController extends Notifier<String?> {
  @override
  String? build() => ref.watch(sharedPrefsProvider).activeChildId;

  Future<void> select(String id) async {
    state = id;
    await ref.read(sharedPrefsProvider).setActiveChildId(id);
  }
}

final activeChildIdProvider = NotifierProvider<ActiveChildIdController, String?>(ActiveChildIdController.new);

final activeChildProvider = Provider<Child?>((ref) {
  final children = ref.watch(childrenProvider).value?.data ?? const <Child>[];
  if (children.isEmpty) return null;
  final id = ref.watch(activeChildIdProvider);
  return children.firstWhere((c) => c.id == id, orElse: () => children.first);
});
