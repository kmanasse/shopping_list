import 'package:flutter/material.dart';

class Item {
  Item(this.name);

  final String name;
  bool bought = false;
}

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.yellow),
      home: const HomeScreen(title: 'Grocery List'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = [Item('Milk'), Item('Bread'), Item('Rice')];
  final controller = TextEditingController();

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void addItem() {
    final text = controller.text.trim();
    if (text.isEmpty) {
      showMessage('Type an item first');
      return;
    }
    if (items.any((item) => item.name.toLowerCase() == text.toLowerCase())) {
      showMessage('$text is already on the list');
      return;
    }
    setState(() {
      items.add(Item(text));
    });
    controller.clear();
  }

  void deleteItem(int index) {
    final name = items[index].name;
    setState(() {
      items.removeAt(index);
    });
    showMessage('$name removed');
  }

  void clearBought() {
    setState(() {
      items.removeWhere((item) => item.bought);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = items.where((item) => !item.bought).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} ($left left)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_outlined),
            onPressed: clearBought,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Add an item'),
                    onSubmitted: (_) => addItem(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: addItem,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(
                    item.bought ? Icons.check_circle : Icons.shopping_basket,
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      decoration:
                      item.bought ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => deleteItem(index),
                  ),
                  onTap: () {
                    setState(() {
                      item.bought = !item.bought;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}