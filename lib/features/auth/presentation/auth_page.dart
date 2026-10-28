import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/security/screen_protection.dart';
import '../../../core/security/vault_session.dart';
import '../../../l10n/app_localizations.dart';

final class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

final class _AuthPageState extends ConsumerState<AuthPage> {
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    ScreenProtection.setSensitive(true);
  }

  @override
  void dispose() {
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _submit(VaultSession session) async {
    final strings = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);
    bool success;
    if (!session.hasVault) {
      if (_password.text != _confirmation.text) {
        setState(() => _error = strings.passwordMismatch);
        return;
      }
      success = await session.setup(_password.text);
    } else {
      success = await session.unlock(_password.text);
      if (success && ref.read(settingsProvider).biometric) {
        final confirmed = await ref
            .read(dependenciesProvider)
            .biometrics
            .confirm();
        if (!confirmed) {
          await session.lock(LockReason.manual);
          success = false;
        }
      }
    }
    _password.clear();
    _confirmation.clear();
    if (!success && mounted) setState(() => _error = strings.wrongPassword);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.shield_outlined,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                        semanticLabel: strings.appName,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        session.hasVault
                            ? strings.unlockVault
                            : strings.createVault,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(strings.securityNotice, textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        autofillHints: const <String>[AutofillHints.password],
                        decoration: InputDecoration(
                          labelText: strings.masterPassword,
                          suffixIcon: IconButton(
                            tooltip: _obscure ? strings.reveal : strings.hide,
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (value) =>
                            !session.hasVault && (value?.length ?? 0) < 12
                            ? strings.passwordTooWeak
                            : null,
                        onFieldSubmitted: (_) =>
                            session.hasVault ? _submit(session) : null,
                      ),
                      if (!session.hasVault) ...<Widget>[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmation,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: strings.confirmPassword,
                          ),
                        ),
                      ],
                      if (_error != null) ...<Widget>[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: session.busy ? null : () => _submit(session),
                        icon: session.busy
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.lock_open),
                        label: Text(
                          session.hasVault
                              ? strings.unlock
                              : strings.continueLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
