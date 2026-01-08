import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_grid/core/data/user.dart';
import 'package:news_grid/core/logic/app_theme_cubit/app_theme_cubit.dart';
import 'package:news_grid/core/shared_preferences/shared_preferences.dart';
import 'package:news_grid/features/settings/widgets/settings_toggle.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await StorageService.getUser();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_user == null) {
      return const Center(child: Text("Unable to load settings"));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Settings",
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 32),
              // Notifications Toggle
              SettingsToggle(
                title: "Notifications",
                subtitle: "Receive daily news updates",
                icon: Icons.notifications_outlined,
                value: _user!.notificationEnabled ?? false,
                onChanged: (value) async {
                  final updatedUser = _user!.copyWith(
                    notificationEnabled: value,
                  );
                  setState(() {
                    _user = updatedUser;
                  });
                  await StorageService.saveUser(updatedUser);
                },
              ),
              const SizedBox(height: 16),
              // Theme Toggle
              BlocBuilder<AppThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  final isDark = themeMode == ThemeMode.dark;
                  return SettingsToggle(
                    title: "Dark Mode",
                    subtitle: "Switch between light and dark themes",
                    icon: isDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    value: isDark,
                    onChanged: (value) async {
                      final newMode = value ? ThemeMode.dark : ThemeMode.light;

                      // Update UI immediately via Cubit
                      context.read<AppThemeCubit>().toggle();

                      // Persist new state
                      final updatedUser = _user!.copyWith(themeMode: newMode);
                      setState(() {
                        _user = updatedUser;
                      });
                      await StorageService.saveUser(updatedUser);
                    },
                  );
                },
              ),

              const Spacer(),
              // App Version
              Center(
                child: Column(
                  children: [
                    Text(
                      "App Version 1.0.0",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }
}
