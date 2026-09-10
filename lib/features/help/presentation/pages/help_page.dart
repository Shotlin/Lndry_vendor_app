import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design/design_system.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../repositories/repositories.dart';
import '../widgets/ticket_detail_sheet.dart';

class HelpPage extends ConsumerStatefulWidget {
  const HelpPage({super.key});

  @override
  ConsumerState<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends ConsumerState<HelpPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _expandedFaq;
  bool _isCreatingTicket = false;
  final _ticketFormKey = GlobalKey<FormState>();
  final _ticketTitleController = TextEditingController();
  final _ticketDescController = TextEditingController();
  String _ticketCategory = 'Order Issue';

  List<Map<String, String>> _faqs(AppLocalizations l10n) => [
        {'q': l10n.helpFaq1Q, 'a': l10n.helpFaq1A},
        {'q': l10n.helpFaq2Q, 'a': l10n.helpFaq2A},
        {'q': l10n.helpFaq3Q, 'a': l10n.helpFaq3A},
        {'q': l10n.helpFaq4Q, 'a': l10n.helpFaq4A},
        {'q': l10n.helpFaq5Q, 'a': l10n.helpFaq5A},
        {'q': l10n.helpFaq6Q, 'a': l10n.helpFaq6A},
        {'q': l10n.helpFaq7Q, 'a': l10n.helpFaq7A},
        {'q': l10n.helpFaq8Q, 'a': l10n.helpFaq8A},
      ];

  // Live ticket list fetched from backend (replaces _demoTickets hardcoded list)
  List<Map<String, dynamic>> _tickets = [];
  bool _ticketsLoading = false;
  String? _ticketsError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTickets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ticketTitleController.dispose();
    _ticketDescController.dispose();
    super.dispose();
  }

  Future<void> _loadTickets() async {
    if (!mounted) return;
    setState(() {
      _ticketsLoading = true;
      _ticketsError = null;
    });
    try {
      final repo = ref.read(vendorRepositoryProvider);
      final list = await repo.getSupportTickets();
      if (mounted)
        setState(() {
          _tickets = List<Map<String, dynamic>>.from(list);
          _ticketsLoading = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _ticketsError = e.toString();
          _ticketsLoading = false;
        });
    }
  }

  Future<void> _submitTicket() async {
    if (!_ticketFormKey.currentState!.validate()) return;
    setState(() => _isCreatingTicket = true);
    try {
      final repo = ref.read(vendorRepositoryProvider);
      final ticket = await repo.createSupportTicket(
        title: _ticketTitleController.text.trim(),
        description: _ticketDescController.text.trim(),
        category: _ticketCategory,
      );
      if (mounted) {
        setState(() {
          _tickets.insert(0, Map<String, dynamic>.from(ticket));
          _isCreatingTicket = false;
        });
        Navigator.pop(context);
        // Switch to the Tickets tab so the user sees the new ticket
        _tabController.animateTo(2);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).helpTicketCreatedSnack),
            backgroundColor: const Color(0xFF11998e),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCreatingTicket = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).helpFailedCreateTicket('$e')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showCreateTicketSheet() {
    final l10n = AppLocalizations.of(context);
    _ticketTitleController.clear();
    _ticketDescController.clear();
    _ticketCategory = 'Order Issue';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20.w,
            right: 20.w,
            top: 24.h,
          ),
          child: Form(
            key: _ticketFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.helpCreateSupportTicketTitle,
                    style: AppTypography.headlineMedium
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  value: _ticketCategory,
                  decoration: InputDecoration(
                    labelText: l10n.servicesCategoryLabel,
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  items: [
                    DropdownMenuItem(
                        value: 'Order Issue', child: Text(l10n.helpCategoryOrderIssue)),
                    DropdownMenuItem(value: 'Payout', child: Text(l10n.helpCategoryPayout)),
                    DropdownMenuItem(
                        value: 'Technical', child: Text(l10n.helpCategoryTechnical)),
                    DropdownMenuItem(value: 'Account', child: Text(l10n.helpCategoryAccount)),
                    DropdownMenuItem(value: 'Other', child: Text(l10n.helpCategoryOther)),
                  ],
                  onChanged: (v) => setS(() => _ticketCategory = v ?? 'Other'),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _ticketTitleController,
                  decoration: InputDecoration(
                    labelText: l10n.helpSubjectLabel,
                    hintText: l10n.helpSubjectHint,
                    prefixIcon: const Icon(Icons.title_rounded),
                  ),
                  validator: (v) => v == null || v.isEmpty ? l10n.profileRequiredField : null,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _ticketDescController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: l10n.servicesDescriptionLabel,
                    hintText: l10n.helpDescriptionHint,
                    prefixIcon: const Icon(Icons.description_outlined),
                    alignLabelWithHint: true,
                  ),
                  validator: (v) => v == null || v.length < 10
                      ? l10n.helpDescriptionTooShort
                      : null,
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: _isCreatingTicket ? null : _submitTicket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: _isCreatingTicket
                      ? SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: const CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2))
                      : Text(l10n.helpSubmitTicketButton),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final canPop = context.canPop();
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go('/profile');
      },
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.darkBackground : const Color(0xFFF8F9FD),
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: isDark ? AppColors.white : AppColors.textBlack),
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/profile'),
          ),
          title: Text(
            l10n.profileHelpLabel,
            style: AppTypography.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.textBlack),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3.h,
            tabs: [
              Tab(text: l10n.helpTabContact),
              Tab(text: l10n.helpTabFaq),
              Tab(text: l10n.helpTabTickets),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildContactTab(isDark),
            _buildFaqTab(isDark),
            _buildTicketsTab(isDark),
          ],
        ),
      ),
    );
  }

  // ── Contact Tab ────────────────────────────────────────────────────────────

  Widget _buildContactTab(bool isDark) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Banner
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Icon(Icons.support_agent_rounded,
                    size: 56.r, color: AppColors.white),
                SizedBox(height: 12.h),
                Text(l10n.helpPartnerSupportTitle,
                    style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.white)),
                SizedBox(height: 4.h),
                Text(
                  l10n.helpPartnerSupportSubtitle,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.white.withValues(alpha: 0.8)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          Text(l10n.helpReachUsHeader,
              style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textBlack)),
          SizedBox(height: 12.h),

          _buildContactCard(
            isDark: isDark,
            icon: Icons.phone_rounded,
            color: const Color(0xFF11998e),
            title: l10n.helpCallSupportTitle,
            subtitle: l10n.helpCallSupportSubtitle,
            actionLabel: l10n.helpCallNowAction,
            onTap: () => _showSnackBar(l10n.helpCallingSnack),
          ),
          SizedBox(height: 12.h),
          _buildContactCard(
            isDark: isDark,
            icon: Icons.email_outlined,
            color: const Color(0xFF0083B0),
            title: l10n.helpEmailSupportTitle,
            subtitle: 'vendor-support@lndry.app',
            actionLabel: l10n.helpSendEmailAction,
            onTap: () => _showSnackBar(l10n.helpOpeningEmailSnack),
          ),
          SizedBox(height: 12.h),
          _buildContactCard(
            isDark: isDark,
            icon: Icons.chat_rounded,
            color: const Color(0xFF25D366),
            title: l10n.helpWhatsappSupportTitle,
            subtitle: '+91 98765 43210',
            actionLabel: l10n.helpOpenWhatsappAction,
            onTap: () => _showSnackBar(l10n.helpOpeningWhatsappSnack),
          ),
          SizedBox(height: 12.h),
          _buildContactCard(
            isDark: isDark,
            icon: Icons.confirmation_number_outlined,
            color: const Color(0xFF8E2DE2),
            title: l10n.helpCreateSupportTicketTitle,
            subtitle: l10n.helpCreateTicketSubtitle,
            actionLabel: l10n.helpCreateTicketAction,
            onTap: () {
              _tabController.animateTo(2);
              Future.delayed(
                  const Duration(milliseconds: 300), _showCreateTicketSheet);
            },
          ),

          SizedBox(height: 24.h),
          // SLA card
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border:
                  Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.helpResponseTimesHeader,
                    style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.white : AppColors.textBlack)),
                SizedBox(height: 12.h),
                _buildSlaRow(
                    icon: Icons.phone_rounded,
                    label: l10n.helpPhoneWhatsappLabel,
                    value: l10n.helpImmediateValue,
                    color: AppColors.success),
                _buildSlaRow(
                    icon: Icons.email_outlined,
                    label: l10n.profileEmailLabel,
                    value: l10n.helpLessThan4Hours,
                    color: AppColors.primary),
                _buildSlaRow(
                    icon: Icons.confirmation_number_outlined,
                    label: l10n.helpSupportTicketLabel,
                    value: l10n.helpLessThan24Hours,
                    color: AppColors.warning),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required bool isDark,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isDark ? AppColors.darkSurface : AppColors.white,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: color, size: 24.r),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.white
                                : AppColors.textBlack)),
                    Text(subtitle,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textSecondary)),
                  ]),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(actionLabel,
                  style: AppTypography.bodySmall
                      .copyWith(color: color, fontWeight: FontWeight.bold)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildSlaRow(
      {required IconData icon,
      required String label,
      required String value,
      required Color color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(children: [
        Icon(icon, size: 16.r, color: color),
        SizedBox(width: 10.w),
        Expanded(
            child: Text(label,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary))),
        Text(value,
            style: AppTypography.bodySmall
                .copyWith(color: color, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  // ── FAQ Tab ────────────────────────────────────────────────────────────────

  Widget _buildFaqTab(bool isDark) {
    final l10n = AppLocalizations.of(context);
    final faqs = _faqs(l10n);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(children: [
              Icon(Icons.lightbulb_outline_rounded,
                  color: AppColors.primary, size: 22.r),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  l10n.helpCantFindAnswer,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.primary),
                ),
              ),
              TextButton(
                onPressed: () {
                  _tabController.animateTo(2);
                  Future.delayed(const Duration(milliseconds: 300),
                      _showCreateTicketSheet);
                },
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.zero),
                child: Text(l10n.helpCreateAction),
              ),
            ]),
          ),
          SizedBox(height: 16.h),
          ...List.generate(faqs.length, (i) {
            final faq = faqs[i];
            final isExpanded = _expandedFaq == i;
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Material(
                color: isDark ? AppColors.darkSurface : AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () =>
                      setState(() => _expandedFaq = isExpanded ? null : i),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              width: 28.r,
                              height: 28.r,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: Text('${i + 1}',
                                    style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(faq['q']!,
                                  style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.white
                                          : AppColors.textBlack)),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ]),
                          if (isExpanded) ...[
                            SizedBox(height: 12.h),
                            Divider(
                                height: 1,
                                color:
                                    AppColors.outline.withValues(alpha: 0.2)),
                            SizedBox(height: 12.h),
                            Text(faq['a']!,
                                style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.5)),
                          ],
                        ]),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Tickets Tab ────────────────────────────────────────────────────────────

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'REPLIED':
        return AppColors.warning;
      case 'OPEN':
        return const Color(0xFF0083B0);
      case 'CLOSED':
        return const Color(0xFF9E9E9E);
      default:
        return AppColors.primary;
    }
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    switch (status.toUpperCase()) {
      case 'REPLIED':
        return l10n.helpStatusReplied;
      case 'OPEN':
        return l10n.helpStatusOpen;
      case 'CLOSED':
        return l10n.helpStatusClosed;
      default:
        return status;
    }
  }

  String _relativeDate(AppLocalizations l10n, String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return l10n.notificationsDaysAgo(diff.inDays);
    if (diff.inHours > 0) return l10n.notificationsHoursAgo(diff.inHours);
    return l10n.notificationsJustNow;
  }

  Widget _buildTicketsTab(bool isDark) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: _showCreateTicketSheet,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.helpCreateNewTicketButton),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
            ),
          ),
          SizedBox(height: 20.h),
          Text(l10n.helpYourTicketsHeader,
              style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textBlack)),
          SizedBox(height: 12.h),
          if (_ticketsLoading)
            const Center(child: CircularProgressIndicator())
          else if (_ticketsError != null)
            Center(
              child: Column(children: [
                Text(l10n.helpFailedToLoadTickets,
                    style:
                        AppTypography.bodyMedium.copyWith(color: Colors.red)),
                SizedBox(height: 8.h),
                TextButton(onPressed: _loadTickets, child: Text(l10n.commonRetry)),
              ]),
            )
          else if (_tickets.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Column(children: [
                  Icon(Icons.confirmation_number_outlined,
                      size: 48.r, color: AppColors.textSecondary),
                  SizedBox(height: 12.h),
                  Text(l10n.helpNoTicketsYet,
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                  SizedBox(height: 4.h),
                  Text(l10n.helpNoTicketsSubtitle,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center),
                ]),
              ),
            )
          else
            ..._tickets.map((ticket) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Material(
                    color: isDark ? AppColors.darkSurface : AppColors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.r),
                      onTap: () => showTicketDetailSheet(
                        context,
                        ref,
                        ticket,
                        onChanged: _loadTickets,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(ticket['ticket_ref'] as String? ?? '',
                                        style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold)),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 3.h),
                                      decoration: BoxDecoration(
                                        color: _statusColor(
                                                ticket['status'] as String? ??
                                                    '')
                                            .withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                      child: Text(
                                          _statusLabel(l10n,
                                              ticket['status'] as String? ??
                                                  ''),
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                  color: _statusColor(
                                                      ticket['status']
                                                              as String? ??
                                                          ''),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10.sp)),
                                    ),
                                  ]),
                              SizedBox(height: 8.h),
                              Text(ticket['title'] as String? ?? '',
                                  style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.white
                                          : AppColors.textBlack)),
                              SizedBox(height: 4.h),
                              Row(children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                      ticket['category'] as String? ?? '',
                                      style: AppTypography.bodySmall.copyWith(
                                          color: AppColors.primary,
                                          fontSize: 10.sp)),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                    _relativeDate(l10n,
                                        ticket['created_at'] as String?),
                                    style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary)),
                              ]),
                            ]),
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
