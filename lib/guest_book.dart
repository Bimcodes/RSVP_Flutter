import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/guest_book_message.dart';
import 'src/widgets.dart';

class GuestBook extends StatefulWidget {
  final FutureOr<void> Function(String message) addMessaage;
  final List<GuestBookMessage> messages;

  const GuestBook(
      {required this.addMessaage, required this.messages, super.key});

  @override
  State<GuestBook> createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: SizedBox(
                //height: MediaQuery.sizeOf(context).height,
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: _controller,
                      decoration:
                          const InputDecoration(hintText: 'Leave a message'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your message to continue';
                        }
                        return null;
                      },
                    )),
                    const SizedBox(width: 8),
                    StyledButton(
                        child: const Row(
                          children: [
                            Icon(Icons.send),
                            SizedBox(
                              width: 4,
                            )
                          ],
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await widget.addMessaage(_controller.text);
                            _controller.clear();
                          }
                        }),
                  ],
                ),
              )),
        ),
        const SizedBox(
          height: 8,
        ),
        for (var message in widget.messages)
          SizedBox(
              width: MediaQuery.sizeOf(context).width * 1,
              child: Paragraph('${message.name}: ${message.message}')),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }
}
