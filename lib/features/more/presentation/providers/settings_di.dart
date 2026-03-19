import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_settings.dart';
import 'settings_provider.dart';

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(
    () => AppSettingsNotifier());
