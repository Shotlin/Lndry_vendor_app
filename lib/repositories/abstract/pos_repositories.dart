import '../../models/pos/pos_catalogue_model.dart';
import '../../models/pos/pos_customer_model.dart';
import '../../models/pos/pos_dashboard_model.dart';
import '../../models/pos/pos_order_model.dart';

abstract class PosDashboardRepository {
  Future<PosDashboard> getDashboard();
}

abstract class PosCatalogueRepository {
  Future<PosCatalogue> getCatalogue();
  Future<PosCategory> createCategory(String name);
  Future<PosService> createService(String name);
  Future<PosGarment> createGarment({required String name, required String unit, String? categoryId});

  /// Adds a shop-wide price for (garment, service).
  Future<PosPrice> createPrice({required String garmentId, required String serviceId, required int ratePaise});
  Future<PosPrice> updatePrice({required String priceId, required int ratePaise});

  /// `kind` is `charge` or `discount`.
  Future<List<PosAdjustmentRule>> listRules(String kind);
}

abstract class PosCounterRepository {
  /// Customers who have bought from this shop, newest first. An empty [search] returns the recent ones.
  Future<List<PosCustomer>> searchCustomers(String search);

  /// Finds the customer by phone or creates them.
  Future<PosCustomer> createCustomer({required String name, required String phone});

  Future<PosQuote> quote(OrderRequest request);

  /// [idempotencyKey] (a UUID v4) makes a retried save return the same order instead of booking twice.
  Future<BookedOrder> book(OrderRequest request, {required String idempotencyKey});
}
