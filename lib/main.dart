import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart'
//     hide ChangeNotifierProvider;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pharma_transfer/firebase_options.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'controller/provider_transferencias.dart';
import 'utils/widgets/loading_overlay_widget.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  Gemini.init(
      apiKey: apiKey!,
      generationConfig: GenerationConfig(temperature: 0));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProviderTransferencias(),
        )
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.black54,
      overlayWidgetBuilder: (_) => const LoadingOverlayWidget(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        routerConfig: appRouter,
      ),
    );
  }
}
