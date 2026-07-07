import 'package:flutter/material.dart';

import '../services/feedback_service.dart';
import '../theme/app_theme.dart';

// Feedback form as a bottom sheet: pick a type, type a message, optionally
// leave an email. Submits through FeedbackService (Worker -> GitHub issue) so
// the user never leaves the app or needs a GitHub account.
class FeedbackSheet extends StatefulWidget {
  final FeedbackType initialType;
  final String? appName;
  final String? appId;
  const FeedbackSheet({
    super.key,
    required this.initialType,
    this.appName,
    this.appId,
  });

  static Future<void> show(
    BuildContext context, {
    required FeedbackType initialType,
    String? appName,
    String? appId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FeedbackSheet(
        initialType: initialType,
        appName: appName,
        appId: appId,
      ),
    );
  }

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet> {
  final _formKey = GlobalKey<FormState>();
  final _message = TextEditingController();
  final _email = TextEditingController();
  late FeedbackType _type = widget.initialType;
  bool _sending = false;

  @override
  void dispose() {
    _message.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    try {
      await FeedbackService.submit(
        type: _type,
        message: _message.text.trim(),
        email: _email.text.trim(),
        appName: widget.appName,
        appId: widget.appId,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thanks — your feedback was sent.")),
      );
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final scope = widget.appName != null ? " on ${widget.appName}" : "";
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Send feedback$scope", style: sora(20, color: t.text)),
            const SizedBox(height: 6),
            Text("Goes straight to the developer — no GitHub account needed.",
                style: dmSans(13, color: t.muted)),
            const SizedBox(height: 18),
            _typeSelector(),
            const SizedBox(height: 14),
            TextFormField(
              controller: _message,
              autofocus: true,
              minLines: 3,
              maxLines: 6,
              maxLength: 5000,
              decoration: InputDecoration(labelText: _messageLabel),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? "Please type a message" : null,
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: "Email (optional, if you want a reply)"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _sending ? null : _submit,
                child: _sending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text("Send"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeSelector() {
    return Wrap(
      spacing: 8,
      children: [
        for (final type in FeedbackType.values)
          ChoiceChip(
            label: Text(_chipLabel(type)),
            selected: _type == type,
            onSelected: (_) => setState(() => _type = type),
          ),
      ],
    );
  }

  String _chipLabel(FeedbackType type) => switch (type) {
        FeedbackType.suggestion => "Suggest",
        FeedbackType.bug => "Report a bug",
        FeedbackType.feedback => "Feedback",
      };

  String get _messageLabel => switch (_type) {
        FeedbackType.suggestion => "What would you like to see?",
        FeedbackType.bug => "What happened? Steps, device, Android version",
        FeedbackType.feedback => "Your feedback",
      };
}
