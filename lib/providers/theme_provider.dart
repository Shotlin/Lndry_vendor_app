import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dark mode is disabled app-wide — always light, regardless of the
/// device's system theme.
final themeModeProvider = Provider<ThemeMode>((ref) => ThemeMode.light);
