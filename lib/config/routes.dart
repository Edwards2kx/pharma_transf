import 'package:go_router/go_router.dart';
import 'package:pharma_transfer/pages/home_page.dart';
import 'package:pharma_transfer/pages/login_page.dart';




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
    // GoRoute(
    //   path: ResultPage.route,
    //   builder: (context, state) {
    //     return const ResultPage();
    //   },
    // ),
  ],
);
