import 'package:daybook/Pages/Entries/create_entry.dart';
import 'package:daybook/Pages/Habits/create_habit.dart';
import 'package:daybook/Pages/Intro/walkthrough_page.dart';
import 'package:daybook/Pages/Journeys/create_journey.dart';
import 'package:daybook/Pages/Entries/display_entry.dart';
import 'package:daybook/Pages/Journeys/display_journey.dart';
import 'package:daybook/Pages/Journeys/select_entries.dart';
import 'package:daybook/Pages/Profile/edit_profile.dart';
import 'package:daybook/Pages/splash_screen.dart';
import 'package:daybook/Provider/email_sign_in.dart';
import 'package:daybook/Provider/google_sign_in.dart';
import 'package:daybook/Provider/theme_change.dart';
// import 'package:daybook/Services/fcmNotificationService.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Pages/Entries/pick_image_screen.dart';
import 'Pages/Entries/ocr_entry.dart';
import 'Pages/Profile/profile.dart';
import 'Pages/Authentication/signup.dart';
import 'Pages/Authentication/login.dart';
import 'Pages/home.dart';
import 'dart:async';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _setupCrashlytics();

  // FirebaseMessaging messaging = FirebaseMessaging();
  
  // messaging.configure(
  //   onMessage: (message) async{
  //     print(message);
  //     String fcmToken = await messaging.getToken();
  //     print(fcmToken);
  //   },
  // );
  // PushNotificationService pushNotificationService = PushNotificationService();
  // await pushNotificationService.initialise();

  runApp(MyApp());
}

Future<void> _setupCrashlytics() async {
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  Function originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    originalOnError(errorDetails);
  };
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger(lightTheme)),
      ],
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  static final String title = 'Daybook';
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return  
      MultiProvider(
        providers: [
          ChangeNotifierProvider<GoogleSignInProvider>(create: (context) {
            return GoogleSignInProvider();
            },
          ),
          ChangeNotifierProvider<EmailSignInProvider>(create: (context) {
            return EmailSignInProvider();
            },
          ),
        ],
        child: MaterialApp(
        theme: theme.getTheme,
        debugShowCheckedModeBanner: false,
        title: title,
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/splashScreen': (BuildContext context)=>SplashScreen(),
          '/intro': (BuildContext context)=>WalkThroughScreen(),
          '/signup': (BuildContext context) => Signup(),
          '/login': (BuildContext context) => LoginPage(),
          '/home': (BuildContext context) => HomePage(),
          '/createEntry': (BuildContext context) => CreateEntryScreen(),
          '/createOCREntry': (BuildContext context) => CreateOCREntryScreen(),
          '/captureEntry': (BuildContext context) => PickImageScreen(),
          '/createJourney': (BuildContext context) => CreateJourneyScreen(),
          '/createHabit': (BuildContext context) => CreateHabitScreen(),
          '/displayEntry': (BuildContext context) => DisplayEntryScreen(),
          '/displayJourney': (BuildContext context) => DisplayJourneyScreen(),
          '/selectEntries': (BuildContext context) => SelectEntriesScreen(),
          '/profile': (BuildContext context) => ProfileScreen(),
          '/editProfile': (BuildContext context) => EditProfile(),
        },
      ),
    );
  }
}
