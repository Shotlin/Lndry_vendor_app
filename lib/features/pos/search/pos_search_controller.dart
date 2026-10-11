import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/repositories/api_pos_repositories.dart';
import '../../../core/services/storage_service.dart';
import '../../../models/pos/pos_search_model.dart';
import '../../../providers/app_mode_provider.dart';
import '../../../repositories/abstract/pos_repositories.dart';

class SearchState {
  const SearchState({this.query = '', this.results, this.loading = false, this.error, this.recent = const []});

  /// What is in the box now (trimmed).
  final String query;

  /// The answer for [query]; `null` while there is nothing to show.
  final PosSearchResults? results;
  final bool loading;
  final Object? error;
  final List<String> recent;

  bool get tooShort => query.length < kMinSearchLength;
}

const int kMinSearchLength = 2;
const int kMaxRecentSearches = 8;

String recentSearchesKey(String? vendorId) => 'pos_recent_searches_v1_${vendorId ?? 'shop'}';

/// One search box. Typing waits [debounce] before asking the server; an answer for words the person has already
/// changed is thrown away, so a slow reply can never overwrite a newer one.
class SearchController extends StateNotifier<SearchState> {
  SearchController(this._repo, this._storage, this._key, {this.debounce = const Duration(milliseconds: 350)}) : super(const SearchState()) {
    state = SearchState(recent: _storage?.getStringList(_key) ?? const []);
  }

  final PosSearchRepository _repo;
  final StorageService? _storage;
  final String _key;
  final Duration debounce;
  Timer? _timer;
  int _ticket = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void onChanged(String raw) {
    final q = raw.trim();
    _timer?.cancel();
    _ticket++;
    if (q.length < kMinSearchLength) {
      state = SearchState(query: q, recent: state.recent);
      return;
    }
    state = SearchState(query: q, loading: true, results: state.results, recent: state.recent);
    final mine = _ticket;
    _timer = Timer(debounce, () => _run(q, mine));
  }

  /// Searches right now (keyboard "search" key, or tapping a recent search).
  Future<void> submit(String raw) async {
    final q = raw.trim();
    _timer?.cancel();
    final mine = ++_ticket;
    if (q.length < kMinSearchLength) {
      state = SearchState(query: q, recent: state.recent);
      return;
    }
    state = SearchState(query: q, loading: true, results: state.results, recent: state.recent);
    await _run(q, mine);
  }

  Future<void> _run(String q, int ticket) async {
    try {
      final r = await _repo.search(q);
      if (!mounted || ticket != _ticket) return;
      state = SearchState(query: q, results: r, recent: state.recent);
    } catch (e) {
      if (!mounted || ticket != _ticket) return;
      state = SearchState(query: q, error: e, recent: state.recent);
    }
  }

  /// Remembers a search the person acted on (opened a result).
  void remember(String q) {
    final t = q.trim();
    if (t.length < kMinSearchLength) return;
    final next = [t, ...state.recent.where((r) => r.toLowerCase() != t.toLowerCase())].take(kMaxRecentSearches).toList(growable: false);
    state = SearchState(query: state.query, results: state.results, loading: state.loading, error: state.error, recent: next);
    _storage?.saveStringList(_key, next);
  }

  void clearRecent() {
    state = SearchState(query: state.query, results: state.results, loading: state.loading, error: state.error);
    _storage?.remove(_key);
  }
}

final posSearchControllerProvider = StateNotifierProvider.autoDispose<SearchController, SearchState>((ref) {
  final vendorId = ref.watch(appModeProvider.select((s) => s.info?.vendorId));
  return SearchController(ref.watch(posSearchRepositoryProvider), ref.watch(storageServiceProvider), recentSearchesKey(vendorId));
});
