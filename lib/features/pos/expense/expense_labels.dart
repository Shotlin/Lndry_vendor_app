import '../../../l10n/generated/app_localizations.dart';

/// Plain-word name of an expense type. A type the shop invented (the server keeps any text) is shown as it was written.
String expenseCategoryLabel(AppLocalizations l, String category) {
  switch (category.toUpperCase()) {
    case 'RENT':
      return l.posCatRent;
    case 'SALARY':
      return l.posCatSalary;
    case 'ELECTRICITY':
      return l.posCatElectricity;
    case 'WATER':
      return l.posCatWater;
    case 'DETERGENT':
      return l.posCatDetergent;
    case 'TRANSPORT':
      return l.posCatTransport;
    case 'REPAIR':
      return l.posCatRepair;
    case 'TEA':
      return l.posCatTea;
    case 'OTHER':
    case 'UNCLASSIFIED':
      return l.posCatOther;
  }
  final t = category.replaceAll('_', ' ').trim().toLowerCase();
  return t.isEmpty ? l.posCatOther : t[0].toUpperCase() + t.substring(1);
}

String expenseModeLabel(AppLocalizations l, String mode) {
  switch (mode.toUpperCase()) {
    case 'CASH':
      return l.posExpModeCash;
    case 'UPI':
      return l.posExpModeUpi;
    case 'BANK_TRANSFER':
    case 'BANK':
      return l.posExpModeBank;
    case 'CARD':
      return l.posExpModeCard;
  }
  return l.posExpModeOther;
}
