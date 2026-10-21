import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/providers.dart';
import '../../../core/storage/cache_store.dart';
import '../domain/dashboard.dart';

final dashboardProvider = FutureProvider.autoDispose.family<Cached<Dashboard>, String>((ref, childId) {
  return ref.read(cacheStoreProvider).fetch(
        'dashboard:$childId',
        () => ref.read(apiClientProvider).get<Map<String, dynamic>>(ApiEndpoints.dashboard(childId)),
        (json) => Dashboard.fromJson(json! as Map<String, dynamic>),
      );
});
