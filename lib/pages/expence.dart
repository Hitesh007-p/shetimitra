import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shetimitra/l10n/app_localizations.dart';

class ExpenseManagementPage extends StatefulWidget {
  const ExpenseManagementPage({
    super.key,
    required this.crops,
    required this.seasons,
  });

  final String crops;
  final String seasons;

  @override
  State<ExpenseManagementPage> createState() => _ExpenseManagementPageState();
}

class _ExpenseManagementPageState extends State<ExpenseManagementPage> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  DateTime? _selectedDate;
  final List<Map<String, dynamic>> _expenseList = [];

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _addExpense() {
    if (_typeController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _selectedDate != null) {
      setState(() {
        _expenseList.add({
          'type': _typeController.text,
          'price': double.parse(_priceController.text),
          'date': _selectedDate!,
        });
        _typeController.clear();
        _priceController.clear();
        _selectedDate = null;
      });
    }
  }

  void _removeExpense(int index) {
    setState(() {
      _expenseList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totalAmount = _expenseList.fold<double>(
      0.0,
      (sum, item) => sum + item['price'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('expenseManagement')),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.cropName(widget.crops),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${l10n.t('totalExpense')}: ?${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _typeController,
                      decoration: InputDecoration(
                        labelText: l10n.t('taskName'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.t('amountSpent'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? l10n.t('pickDate')
                                : '${l10n.t('datePrefix')}: ${_formatDate(_selectedDate!)}',
                          ),
                        ),
                        IconButton(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(l10n.t('addExpense')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.t('expenseList'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _expenseList.length,
                itemBuilder: (context, index) {
                  final expense = _expenseList[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.currency_rupee, color: Colors.white),
                      ),
                      title: Text(
                        expense['type'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${l10n.t('datePrefix')}: ${_formatDate(expense['date'])}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '?${expense['price'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _removeExpense(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
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
