import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String title;
  final bool isDone;
  final ValueChanged<bool?>? onCheck;
  final VoidCallback? onTap;

  const ListItem({
    super.key,
    required this.title,
    required this.isDone,
    this.onCheck,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF5E4D7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: 20,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  color: const Color(0xFF4F5A52),
                ),
              ),
            ),

            // Checkbox on the RIGHT side
            Checkbox(
              value: isDone,
              onChanged: onCheck,
              activeColor: const Color(0xFF73877B),
              checkColor: const Color(0xFFF5E4D7),
              side: const BorderSide(
                color: Color(0xFF73877B),
                width: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
