import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:simpoc/provider/sim_provider.dart';
import 'package:simpoc/screens/landing_page.dart';
import 'package:simpoc/service/sim_card_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NoScreenshot.instance.screenshotOff();
  await NoScreenshot.instance.screenshotWithImage();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SimProvider(SimService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      themeMode: ThemeMode.light,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadSlateColorScheme.light(),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(),
      ),
      appBuilder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Theme.of(context),
          builder: (context, child) => ShadAppBuilder(child: child!),
          home: const LandingPage(),
        );
      },
    );
  }
}