import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String title;
  final bool isDone;
  final ValueChanged<bool?> onCheck;
  final VoidCallback onDelete;
  final VoidCallback? onTap; // <-- Add this

  const ListItem({
    super.key,
    required this.title,
    required this.isDone,
    required this.onCheck,
    required this.onDelete,
    this.onTap, // <-- Add this
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // <-- Make the whole row clickable
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF5E4D7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title)),
            Checkbox(
              value: isDone,
              onChanged: onCheck,
              fillColor: MaterialStateProperty.all(const Color(0xFF73877B)),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
