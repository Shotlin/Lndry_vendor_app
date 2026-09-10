import 'generated/app_localizations.dart';

/// Localized day-of-week labels, index 0 = Sunday .. 6 = Saturday, matching
/// the backend's `day_of_week` convention used throughout the slots feature.
List<String> daysOfWeekLabels(AppLocalizations l10n) => [
      l10n.slotsSunday,
      l10n.slotsMonday,
      l10n.slotsTuesday,
      l10n.slotsWednesday,
      l10n.slotsThursday,
      l10n.slotsFriday,
      l10n.slotsSaturday,
    ];
