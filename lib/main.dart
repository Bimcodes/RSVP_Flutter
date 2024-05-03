// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtk_flutter/app_state.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

final _router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const HomePage(), routes: [
    GoRoute(
        path: 'sign-in',
        builder: (context, state) {
          return SignInScreen(
            actions: [
              ForgotPasswordAction((context, email) {
                final uri = Uri(
                  path: '/sign-in/forgot-password',
                  queryParameters: <String, String?>{
                    'email': email,
                  },
                );
                context.push(uri.toString());
              }),
              AuthStateChangeAction((context, state) {
                final user;
              }),
            ],
          );
        })
  ])
]);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Meetup',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.deepPurple,
            ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
