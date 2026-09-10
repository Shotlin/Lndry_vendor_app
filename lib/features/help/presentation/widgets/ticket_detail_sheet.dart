import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/design_system.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../repositories/repositories.dart';

/// Shown when a vendor taps a ticket — displays the conversation
/// (description, admin reply, any follow-up) and the status-driven
/// satisfaction flow:
///   OPEN      -> waiting for a reply, nothing else to do yet.
///   REPLIED   -> "Are you satisfied?" Yes (star rating, closes) or
///                No (follow-up message, reopens to OPEN).
///   CLOSED    -> final reply + rating (if any), read-only.
Future<void> showTicketDetailSheet(
  BuildContext context,
  WidgetRef ref,
  Map<String, dynamic> ticket, {
  required VoidCallback onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
    builder: (context) =>
        _TicketDetailSheet(ticket: ticket, onChanged: onChanged),
  );
}

class _TicketDetailSheet extends ConsumerStatefulWidget {
  const _TicketDetailSheet({required this.ticket, required this.onChanged});

  final Map<String, dynamic> ticket;
  final VoidCallback onChanged;

  @override
  ConsumerState<_TicketDetailSheet> createState() => _TicketDetailSheetState();
}

class _TicketDetailSheetState extends ConsumerState<_TicketDetailSheet> {
  late Map<String, dynamic> _ticket;

  // null = haven't asked yet; true = "Yes I'm satisfied" (show stars);
  // false = "No" (show follow-up box).
  bool? _satisfied;
  int _selectedStars = 0;
  final _followUpController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
  }

  @override
  void dispose() {
    _followUpController.dispose();
    super.dispose();
  }

  String get _status => _ticket['status'] as String? ?? 'OPEN';

  Future<void> _submitRating() async {
    if (_selectedStars == 0) return;
    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(vendorRepositoryProvider);
      final updated =
          await repo.rateSupportTicket(_ticket['id'] as String, _selectedStars);
      if (!mounted) return;
      setState(() => _ticket = updated);
      widget.onChanged();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).ticketThanksForFeedback)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).ticketFailedSubmitRating('$e'))));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _submitFollowUp() async {
    final message = _followUpController.text.trim();
    if (message.length < 3) return;
    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(vendorRepositoryProvider);
      final updated =
          await repo.followUpSupportTicket(_ticket['id'] as String, message);
      if (!mounted) return;
      setState(() {
        _ticket = updated;
        _satisfied = null;
        _followUpController.clear();
      });
      widget.onChanged();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context).ticketMessageSentSnack)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).ticketFailedToSend('$e'))));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final adminReply = _ticket['admin_reply'] as String?;
    final vendorReply = _ticket['vendor_reply'] as String?;
    final rating = _ticket['rating'] as int?;
    final repliedAt = _ticket['replied_at'] as String?;
    final vendorRepliedAt = _ticket['vendor_replied_at'] as String?;
    final showVendorFollowUp = vendorReply != null &&
        vendorRepliedAt != null &&
        (repliedAt == null ||
            DateTime.parse(vendorRepliedAt).isAfter(DateTime.parse(repliedAt)));

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return ListView(
            controller: scrollController,
            padding: EdgeInsets.all(20.w),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _ticket['title'] as String? ?? '',
                      style: AppTypography.headlineMedium
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _StatusPill(status: _status),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                _ticket['ticket_ref'] as String? ?? '',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 16.h),
              _ConversationBubble(
                label: l10n.ticketYouLabel,
                text: _ticket['description'] as String? ?? '',
                color: isDark
                    ? AppColors.darkSurfaceContainer
                    : const Color(0xFFF1F2FF),
              ),
              if (adminReply != null) ...[
                SizedBox(height: 10.h),
                _ConversationBubble(
                  label: l10n.ticketSupportTeamLabel,
                  text: adminReply,
                  color: AppColors.primaryContainer,
                ),
              ],
              if (showVendorFollowUp) ...[
                SizedBox(height: 10.h),
                _ConversationBubble(
                  label: l10n.ticketYouLabel,
                  text: vendorReply,
                  color: isDark
                      ? AppColors.darkSurfaceContainer
                      : const Color(0xFFF1F2FF),
                ),
              ],
              SizedBox(height: 20.h),
              if (_status == 'OPEN')
                _InfoBanner(text: l10n.ticketWaitingForReplyBanner),
              if (_status == 'REPLIED') ...[
                if (_satisfied == null) ...[
                  Text(l10n.ticketAreYouSatisfied,
                      style: AppTypography.bodyLarge
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _satisfied = true),
                          child: Text(l10n.ticketYesButton),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _satisfied = false),
                          child: Text(l10n.ticketNoButton),
                        ),
                      ),
                    ],
                  ),
                ] else if (_satisfied == true) ...[
                  Text(l10n.ticketRateExperience,
                      style: AppTypography.bodyLarge
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final starIndex = i + 1;
                      return IconButton(
                        onPressed: () =>
                            setState(() => _selectedStars = starIndex),
                        icon: Icon(
                          starIndex <= _selectedStars
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: AppColors.warning,
                          size: 32.r,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: _isSubmitting || _selectedStars == 0
                        ? null
                        : _submitRating,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(l10n.ticketSubmitRatingButton),
                  ),
                ] else ...[
                  Text(l10n.ticketWhatWouldYouAsk,
                      style: AppTypography.bodyLarge
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _followUpController,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: l10n.ticketTypeMessageHint,
                        border: const OutlineInputBorder()),
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitFollowUp,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(l10n.ticketSendButton),
                  ),
                ],
              ],
              if (_status == 'CLOSED') ...[
                if (rating != null) ...[
                  Text(l10n.ticketYourRatingHeader,
                      style: AppTypography.bodyLarge
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: AppColors.warning,
                        size: 28.r,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(l10n.ticketThanksForFeedback,
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                ] else
                  _InfoBanner(text: l10n.ticketClosedByTeamBanner),
              ],
              SizedBox(height: 24.h),
            ],
          );
        },
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (color, label) = switch (status) {
      'OPEN' => (const Color(0xFF0083B0), l10n.helpStatusOpen),
      'REPLIED' => (AppColors.warning, l10n.helpStatusReplied),
      _ => (AppColors.success, l10n.helpStatusClosed),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20.r)),
      child: Text(label,
          style: AppTypography.bodySmall
              .copyWith(color: color, fontWeight: FontWeight.bold)),
    );
  }
}

class _ConversationBubble extends StatelessWidget {
  const _ConversationBubble(
      {required this.label, required this.text, required this.color});
  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.primary)),
          SizedBox(height: 4.h),
          Text(text, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(text,
          style:
              AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
    );
  }
}
