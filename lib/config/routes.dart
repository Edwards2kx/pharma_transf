import 'package:go_router/go_router.dart';
import 'package:pharma_transfer/presentation/screens/home_screen/home_page.dart';
import 'package:pharma_transfer/presentation/screens/login_screen/login_page.dart';

//TODO usar GoRouter para navegar a la vista del mapa
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: LoginPage.route,
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: HomePage.route,
      builder: (context, state) {
        return const HomePage();
      },
    ),
  ],
);
