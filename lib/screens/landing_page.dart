import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../provider/sim_provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final status = await Permission.phone.request();
      if (!mounted) return;
      if (status.isGranted) {
        context.read<SimProvider>().loadSimInfo();
      } else {
        ShadToaster.of(context).show(
          const ShadToast.destructive(
            title: Text('Permission Denied'),
            description: Text('Phone permission is required to read SIM info.'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SimProvider>();
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text('SIM Information', style: theme.textTheme.h4),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: theme.colorScheme.border, height: 1),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.loadSimInfo,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ── Status badges row ──────────────────────────
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (provider.hasSimCard)
                        const ShadBadge(child: Text('SIM Active'))
                      else
                        const ShadBadge.destructive(child: Text('No SIM')),
                      if (provider.isDualSim)
                        const ShadBadge.secondary(child: Text('Dual SIM')),
                      if (provider.isEsim)
                        const ShadBadge.outline(child: Text('eSIM')),
                      if (provider.isRoaming)
                        const ShadBadge.destructive(child: Text('Roaming')),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Network card ───────────────────────────────
                  ShadCard(
                    title: Row(
                      children: [
                        Icon(
                          LucideIcons.signal,
                          size: 16,
                          color: theme.colorScheme.foreground,
                        ),
                        const SizedBox(width: 8),
                        Text('Network', style: theme.textTheme.h4),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        _infoRow(
                          'Operator',
                          provider.networkOperatorName,
                          theme,
                        ),
                        _infoRow(
                          'Country Code',
                          provider.networkCountryCode,
                          theme,
                        ),
                        _infoRow('Network Type', provider.networkType, theme),
                        _infoRow('SIM State', provider.simState, theme),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── SIM Details card ───────────────────────────
                  ShadCard(
                    title: Row(
                      children: [
                        Icon(
                          LucideIcons.creditCard,
                          size: 16,
                          color: theme.colorScheme.foreground,
                        ),
                        const SizedBox(width: 8),
                        Text('SIM Details', style: theme.textTheme.h4),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        _infoRow(
                          'Country Code',
                          provider.simCountryCode,
                          theme,
                        ),
                        _infoRow(
                          'Operator Name',
                          provider.simOperatorName,
                          theme,
                        ),
                        _infoRow(
                          'Operator Code',
                          provider.simOperatorCode,
                          theme,
                        ),
                        _infoRow(
                          'Serial Number',
                          provider.simSerialNumber,
                          theme,
                        ),
                        _infoRow('Phone Number', provider.phoneNumber, theme),
                        _infoRow(
                          'SIM Count',
                          provider.simCount.toString(),
                          theme,
                        ),
                        _infoRow(
                          'Supports eSIM',
                          provider.supportsEsim.toString(),
                          theme,
                        ),
                        _infoRow('Device ID', provider.deviceId, theme),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── All SIM Information ────────────────────────
                  Text('All SIM Slots', style: theme.textTheme.h4),
                  const SizedBox(height: 12),

                  if (provider.allSimInfo.isEmpty)
                    ShadCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.info,
                              size: 16,
                              color: theme.colorScheme.mutedForeground,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'No SIM slot data available.',
                              style: theme.textTheme.muted,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...provider.allSimInfo.asMap().entries.map((entry) {
                      final index = entry.key;
                      final sim = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ShadCard(
                          title: Row(
                            children: [
                              Icon(
                                LucideIcons.smartphone,
                                size: 16,
                                color: theme.colorScheme.foreground,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'SIM Slot ${index + 1}',
                                style: theme.textTheme.h4,
                              ),
                              const SizedBox(width: 8),
                              if (sim.isEsim == true)
                                const ShadBadge.outline(child: Text('eSIM')),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              _infoRow(
                                'Subscription ID',
                                sim.subscriptionId?.toString(),
                                theme,
                              ),
                              _infoRow(
                                'Operator Name',
                                sim.operatorName,
                                theme,
                              ),
                              _infoRow(
                                'Operator Code',
                                sim.operatorCode,
                                theme,
                              ),
                              _infoRow('Country Code', sim.countryCode, theme),
                              _infoRow('Phone Number', sim.phoneNumber, theme),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _infoRow(String label, String? value, ShadThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.muted),
          Flexible(
            child: Text(
              value ?? 'N/A',
              style: theme.textTheme.small,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
