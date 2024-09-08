import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/screen/flchart.dart';
import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  ApiService apiService = ApiService(); // Instance of your ApiService class
  List<dynamic> expenses = [];
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchExpenses(); // Fetch expenses on page load
  }

  Future<void> _fetchExpenses() async {
    try {
      List<dynamic> fetchedExpenses = await apiService.fetchExpenses();
      setState(() {
        expenses = fetchedExpenses;
      });
    } catch (e) {
      print("Error fetching expenses: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: expenses.isEmpty
          ? Center(child: Text("No Expenses Yet"))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                var expense = expenses[index];
                return ListTile(
                  title: Text(expense['description']),
                  subtitle:
                      Text('\Rs${expense['amount']} - ${expense['category']}'),
                  trailing: Text(expense['date']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addExpenseDialog(); // Call the function to show the dialog for adding expenses
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addExpenseDialog() {
    // Clear the text fields when showing the dialog
    descriptionController.clear();
    amountController.clear();
    categoryController.clear();
    dateController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
ElevatedButton(onPressed: (){
  Navigator.push(context, MaterialPageRoute(builder: (_)=>AnimatedChartsPage()));
}, child: Text("h")),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                  keyboardType: TextInputType.datetime,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                Navigator.pop(context);
                await _addExpense(
                  descriptionController.text,
                  double.tryParse(amountController.text) ?? 0.0,
                  categoryController.text,
                  dateController.text,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addExpense(
      String description, double amount, String category, String date) async {
    try {
      await apiService.addExpense({
        'description': description,
        'amount': amount,
        'category': category,
        'date': date,
      });
      _fetchExpenses(); // Refresh the list after adding an expense
    } catch (e) {
      print("Error adding expense: $e");
    }
  }
}
