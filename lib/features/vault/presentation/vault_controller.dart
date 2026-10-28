import 'package:flutter/foundation.dart';

import '../data/vault_repository.dart';
import '../domain/vault_entry.dart';

enum VaultSort { newest, title, risk }

final class VaultController extends ChangeNotifier {
  VaultController(this.repository);

  final VaultRepository repository;
  List<VaultEntry> _entries = <VaultEntry>[];
  String _query = '';
  String? _tag;
  bool _favoritesOnly = false;
  VaultSort _sort = VaultSort.newest;
  bool _loading = false;
  Object? _error;

  List<VaultEntry> get entries => List<VaultEntry>.unmodifiable(_entries);
  bool get loading => _loading;
  Object? get error => _error;
  VaultSort get sort => _sort;
  bool get favoritesOnly => _favoritesOnly;
  String? get selectedTag => _tag;
  Set<String> get tags => _entries.expand((entry) => entry.tags).toSet();

  List<VaultEntry> get visibleEntries {
    final needle = _query.trim().toLowerCase();
    final visible = _entries.where((entry) {
      if (_favoritesOnly && !entry.favorite) return false;
      if (_tag != null && !entry.tags.contains(_tag)) return false;
      if (needle.isEmpty) return true;
      return <String>[
        entry.title,
        entry.username,
        entry.url,
        entry.tags.join(' '),
      ].any((value) => value.toLowerCase().contains(needle));
    }).toList();
    switch (_sort) {
      case VaultSort.newest:
        visible.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case VaultSort.title:
        visible.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      case VaultSort.risk:
        visible.sort((a, b) => b.riskScore.compareTo(a.riskScore));
    }
    return visible;
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _entries = await repository.all();
    } catch (error) {
      _error = error;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> save(VaultEntry entry) async {
    await repository.save(entry);
    await load();
  }

  Future<void> add({
    required String title,
    required String password,
    String username = '',
    String url = '',
    String notes = '',
    List<String> tags = const <String>[],
    bool favorite = false,
    int riskScore = 0,
  }) async {
    await repository.create(
      title: title,
      password: password,
      username: username,
      url: url,
      notes: notes,
      tags: tags,
      favorite: favorite,
      riskScore: riskScore,
    );
    await load();
  }

  Future<void> delete(String id) async {
    await repository.delete(id);
    await load();
  }

  void search(String value) {
    _query = value;
    notifyListeners();
  }

  void setTag(String? value) {
    _tag = value;
    notifyListeners();
  }

  void setFavorites(bool value) {
    _favoritesOnly = value;
    notifyListeners();
  }

  void setSort(VaultSort value) {
    _sort = value;
    notifyListeners();
  }

  void clear() {
    _entries = <VaultEntry>[];
    _query = '';
    _tag = null;
    _error = null;
    notifyListeners();
  }
}
