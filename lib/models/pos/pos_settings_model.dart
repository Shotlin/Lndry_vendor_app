/// A WhatsApp message with `{Placeholders}`. The same shape Epic keeps in the shop setting `message-templates`,
/// so a shop sees the same messages on the counter software and on the phone.
class MessageTemplate {
  const MessageTemplate({required this.key, required this.label, required this.body, this.active = true});

  factory MessageTemplate.fromJson(Map<String, dynamic> j) => MessageTemplate(
        key: (j['key'] ?? '').toString(),
        label: (j['label'] ?? j['key'] ?? '').toString(),
        body: (j['body'] ?? '').toString(),
        active: j['active'] != false,
      );

  final String key;
  final String label;
  final String body;
  final bool active;
}

/// The four messages Epic starts with. Used until the shop saves its own.
const kDefaultMessageTemplates = <MessageTemplate>[
  MessageTemplate(
      key: 'order-booked',
      label: 'Order Booked',
      body: 'Hello {CustomerName}, your {Brand} order #{OrderNo} has been booked.\n\nItems: {TotalGarments}\nAmount: {TotalAmount}\nExpected delivery: {DeliveryDate}\n\nWe will keep you updated as your order moves through the laundry.'),
  MessageTemplate(
      key: 'order-processing',
      label: 'Order Processing',
      body: 'Hello {CustomerName}, we have started processing your {Brand} order #{OrderNo}. We will message you when it is ready.'),
  MessageTemplate(
      key: 'order-done',
      label: 'Order Done',
      body: 'Hello {CustomerName}, your {Brand} order #{OrderNo} is ready for collection.\n\nItems: {TotalGarments}\nBalance due: {Balance}\n\nThank you for choosing {Brand}.'),
  MessageTemplate(
      key: 'order-delivered',
      label: 'Order Delivered',
      body: 'Hello {CustomerName}, your {Brand} order #{OrderNo} has been delivered. Thank you for choosing {Brand}.'),
];

/// Fills `{Name}` placeholders from [values]. A placeholder with no value here (a link the app cannot make) is removed
/// rather than sent as raw `{InvoiceUrl}` text; blank lines left behind are tidied.
String fillTemplate(String body, Map<String, String> values) {
  final out = body.replaceAllMapped(RegExp(r'\{([A-Za-z][A-Za-z0-9]*)\}'), (m) => values[m[1]] ?? '');
  return out.split('\n').map((l) => l.trimRight()).join('\n').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
}

class PosStaffMember {
  const PosStaffMember({required this.id, required this.name, required this.phone, required this.role, required this.active});

  factory PosStaffMember.fromJson(Map<String, dynamic> j) => PosStaffMember(
        id: j['id'].toString(),
        name: (j['user_name'] ?? '').toString().trim(),
        phone: (j['user_phone'] ?? '').toString(),
        role: (j['role'] ?? j['shop_role'] ?? '').toString(),
        active: j['is_active'] != false,
      );

  final String id;
  final String name;
  final String phone;

  /// `VENDOR_OWNER`, `VENDOR_STAFF` or `VENDOR_RIDER`.
  final String role;
  final bool active;

  String get displayName => name.isEmpty ? phone : name;
}
