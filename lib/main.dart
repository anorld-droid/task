import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/domain/providers/user_provider.dart';
import 'package:task/firebase_options.dart';
import 'package:task/ui/responsive/mobile_screen_layout.dart';
import 'package:task/ui/responsive/responsive_layout_screen.dart';
import 'package:task/ui/responsive/web_screen_layout.dart';
import 'package:task/ui/views/dashboard.dart';
import 'package:task/ui/views/login_screen.dart';
import 'package:task/utils/colors.dart';

void main() async {
  Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      if (kDebugMode) {
        print('getInitialAppLink: $appLink');
      }
      openAppLink(appLink);
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (kDebugMode) {
        print('onAppLink: $uri');
      }
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    _navigatorKey.currentState?.pushNamed(uri.fragment);
  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jithvar Task',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        navigatorKey: _navigatorKey,
        initialRoute: "/",
        onGenerateRoute: (RouteSettings settings) {
          Widget routeWidget = const ResponsiveWidget(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout());

          // Mimic web routing
          final routeName = settings.name;
          if (routeName != null) {
            if (routeName.startsWith('/profile/')) {
              List<String> id = routeName.split('/');
              routeWidget = ResponsiveWidget(
                webScreenLayout: WebScreenLayout(
                  screen: Dashboard(uid: id.last),
                ),
                mobileScreenLayout: MobileScreenLayout(
                  screen: Dashboard(uid: id.last),
                ),
              );
            }
          }
          return MaterialPageRoute(
            builder: (context) => StreamBuilder(
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return routeWidget;
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }
                return const LoginScreen();
              }),
              stream: FirebaseAuth.instance.authStateChanges(),
            ),
          );
        },
      ),
    );
  }
}
