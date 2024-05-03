// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        EmailAuthProvider,
        PhoneAuthProvider;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/yes_no_selection.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'guest_book.dart';
import 'src/authentication.dart';
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Meetup'),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/codelab.png'),
          const SizedBox(height: 8),
          const IconAndDetail(Icons.calendar_today, 'October 30'),
          const IconAndDetail(Icons.location_city, 'San Francisco'),
          Consumer<ApplicationState>(
              builder: (BuildContext context, ApplicationState appState,
                      Widget? _) =>
                  AuthFunc(
                      loggedIn: appState.loggedIn,
                      signOut: () {
                        FirebaseAuth.instance.signOut();
                      })),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("What we'll be doing"),
          const Paragraph(
            'Join us for a day full of Firebase Workshops and Pizza!',
          ),
          const Header('Discussion'),
          Consumer<ApplicationState>(
              builder: (context, appState, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        switch (appState.attendees) {
                          1 => const Paragraph('1 person going'),
                          >= 2 =>
                            Paragraph('${appState.attendees} people going'),
                          _ => const Paragraph('No one going'),
                        },
                        // ...to here.
                        if (appState.loggedIn) ...[
                          // Add from here...
                          YesNoSelection(
                            state: appState.attending,
                            onSelection: (attending) =>
                                appState.attending = attending,
                          ),
                          // ...to here.
                          GuestBook(
                            addMessaage: (message) =>
                                appState.addMessageToGuestBook(message),
                            messages: appState.guestBookMessage,
                          ),
                        ],
                      ]))
        ],
      ),
    );
  }
}
