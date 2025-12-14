import "package:flutter/material.dart";

class ExpenseItem {
  ExpenseItem(this.title, this.amount);
  final String title;
  final double amount;
}

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<ExpenseItem> _items = [
    ExpenseItem("Hotel (demo)", 220.00),
    ExpenseItem("Food", 48.25),
    ExpenseItem("Uber", 18.70),
  ];

  double get total => _items.fold(0.0, (sum, e) => sum + e.amount);

  Future<void> _addExpense() async {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    final result = await showDialog<ExpenseItem>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(hintText: "e.g., Coffee"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "e.g., 12.50"),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel")),
            FilledButton(
              onPressed: () {
                final title = titleCtrl.text.trim();
                final amt = double.tryParse(amountCtrl.text.trim());
                if (title.isEmpty || amt == null) return;
                Navigator.pop(ctx, ExpenseItem(title, amt));
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );

    if (result == null) return;
    setState(() => _items.insert(0, result));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addExpense,
        icon: const Icon(Icons.add),
        label: const Text("Add expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: cs.primary.withOpacity(0.18),
                      ),
                      child: Icon(Icons.savings, color: cs.onSurface),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Trip Total",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      "\$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final e = _items[i];
                  return Card(
                    child: ListTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: cs.secondary.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child:
                            Icon(Icons.payments_outlined, color: cs.onSurface),
                      ),
                      title: Text(e.title),
                      trailing: Text(
                        "\$${e.amount.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.w700),
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
