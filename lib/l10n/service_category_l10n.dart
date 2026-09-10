import '../models/models.dart';
import 'generated/app_localizations.dart';

/// Localized display label for [ServiceCategory], mirroring
/// [ServiceCategoryX.label] but resolved through [AppLocalizations].
String serviceCategoryLabel(AppLocalizations l10n, ServiceCategory category) {
  return switch (category) {
    ServiceCategory.wash => l10n.serviceCategoryWash,
    ServiceCategory.iron => l10n.serviceCategoryIron,
    ServiceCategory.washAndIron => l10n.serviceCategoryWashAndIron,
    ServiceCategory.dryClean => l10n.serviceCategoryDryClean,
    ServiceCategory.fold => l10n.serviceCategoryFold,
    ServiceCategory.premium => l10n.serviceCategoryPremium,
  };
}
