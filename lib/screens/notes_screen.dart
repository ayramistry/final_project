import "package:flutter/material.dart";

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<_NoteItem> _items = [
    _NoteItem("Passport / ID", true),
    _NoteItem("Chargers (phone + laptop)", false),
    _NoteItem("Comfy walking shoes", false),
    _NoteItem("Headphones", true),
    _NoteItem("Mini skincare + lip balm", false),
  ];

  Future<void> _addItem() async {
    final ctrl = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add to packing list"),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(
              hintText: "e.g., Sunglasses",
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel")),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) return;
    setState(() => _items.insert(0, _NoteItem(result, false)));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addItem,
        icon: const Icon(Icons.add),
        label: const Text("Add item"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cozy header card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: cs.tertiary.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.backpack_outlined),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Packing List 🧳",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Keep it simple — check things off as you go.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface.withOpacity(0.70),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: _items.isEmpty
                  ? Center(
                      child: Text(
                        "No notes yet.\nTap “Add item” to start ✨",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: cs.onSurface.withOpacity(0.7)),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final item = _items[i];

                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            leading: Checkbox(
                              value: item.done,
                              activeColor: cs.primary,
                              onChanged: (v) {
                                setState(() => item.done = v ?? false);
                              },
                            ),
                            title: Text(
                              item.text,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                decoration: item.done
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: cs.onSurface,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_outline,
                                  color: cs.onSurface.withOpacity(0.65)),
                              onPressed: () {
                                setState(() => _items.removeAt(i));
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteItem {
  _NoteItem(this.text, this.done);
  final String text;
  bool done;
}
