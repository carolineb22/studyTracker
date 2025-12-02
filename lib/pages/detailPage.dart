import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String initialDescription;
  final String initialCategory;
  final DateTime? initialDueDate;
  final String initialPriority;

  final Function(String, String, String, DateTime?, String) onUpdate;
  final VoidCallback onDelete;

  const DetailsPage({
    super.key,
    required this.title,
    required this.initialDescription,
    required this.initialCategory,
    required this.initialDueDate,
    required this.initialPriority,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  String? _selectedCategory;
  String? _selectedPriority;
  DateTime? _dueDate;

  final List<String> _categories = [
    "Math",
    "Data Comm",
    "Mobile Dev",
    "OOP",
    "Other",
  ];

  final List<String> _priorityLevels = [
    "None",
    "Low",
    "Medium",
    "High",
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _selectedCategory = widget.initialCategory.isEmpty ? null : widget.initialCategory;
    _selectedPriority = widget.initialPriority;
    _dueDate = widget.initialDueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDBBB6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF73877B),
        title: const Text(
          "Details",
          style: TextStyle(
            color: Color(0xFFF5E4D7),
            fontFamily: 'ComicNeue',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4F5A52),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.delete),
                color: const Color(0xFFF5E4D7),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete Item"),
                      content: const Text("Are you sure you want to delete this item?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: const Text("Delete"),
                          onPressed: () {
                            widget.onDelete();
                            Navigator.pop(context); // close dialog
                            Navigator.pop(context); // close page
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Item name", style: TextStyle(fontSize: 22, color: Color(0xFF4F5A52), fontFamily: "ComicNeue")),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5E4D7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 25),

            const Text("Item description", style: TextStyle(fontSize: 22, color: Color(0xFF4F5A52), fontFamily: "ComicNeue")),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5E4D7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 25),

            const Text("Class / Category", style: TextStyle(fontSize: 22, color: Color(0xFF4F5A52), fontFamily: "ComicNeue")),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() { _selectedCategory = val; }),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5E4D7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 25),

            const Text("Due date", style: TextStyle(fontSize: 22, color: Color(0xFF4F5A52), fontFamily: "ComicNeue")),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDate: _dueDate ?? DateTime.now(),
                );
                if (selected != null) setState(() { _dueDate = selected; });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5E4D7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade600),
                ),
                child: Text(
                  _dueDate == null ? "Select a date" : "${_dueDate!.year}-${_dueDate!.month}-${_dueDate!.day}",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 25),

            const Text("Priority", style: TextStyle(fontSize: 22, color: Color(0xFF4F5A52), fontFamily: "ComicNeue")),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              items: ["None","Low","Medium","High"].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (val) => setState(() { _selectedPriority = val; }),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5E4D7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 40),

            // ---------------- SAVE BUTTON ----------------
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF73877B),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text("Save", style: TextStyle(color: Color(0xFFF5E4D7), fontSize: 20)),
                onPressed: () {
                  widget.onUpdate(
                    _nameController.text,
                    _descriptionController.text,
                    _selectedCategory ?? "",
                    _dueDate,
                    _selectedPriority ?? "None",
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
