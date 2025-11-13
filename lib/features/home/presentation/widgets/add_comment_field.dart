// features/home/presentation/widgets/add_comment_field.dart
import 'package:flutter/material.dart';

class AddCommentField extends StatefulWidget {
  final void Function(String) onSubmit;
  const AddCommentField({super.key, required this.onSubmit});

  @override
  State<AddCommentField> createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                final t = _ctrl.text.trim();
                if (t.isEmpty) return;
                widget.onSubmit(t);
                _ctrl.clear();
                FocusScope.of(context).unfocus();
              },
              icon: const Icon(Icons.send, color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
