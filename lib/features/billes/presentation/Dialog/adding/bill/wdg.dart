import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:flutter/material.dart';

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  TextEditingController customerNameController = TextEditingController();
  List<String> normalCustomerNames = ["John Doe", "Jane Smith", "Ali Ahmed"];

  // Simulate your custom method that updates customer existence
  void _updateCustomerExistence(String name) {
    print("Customer exists: $name");
    // Your existing logic to check for customer existence
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AutoCompleteTextField Example'),
      ),
      body:  AutoCompleteTextField<String>(
        controller: customerNameController,
        suggestions: normalCustomerNames,
        style: TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
          labelText: 'أسم العميل',
          border: OutlineInputBorder(),
        ),
        itemFilter: (item, query) {
          return item.toLowerCase().contains(query.toLowerCase());
        },
        itemBuilder: (context, item) {
          return ListTile(
            title: Text(item),
          );
        },
        submitOnSuggestionTap: true, // Ensure tapping suggestion submits
        textSubmitted: (item) {
          print(item); // Debugging
          setState(() {  // Ensure setState updates parent widget state
            customerNameController.text = item;  // Update text controller
            _updateCustomerExistence(item);  // Call your custom method
          });
        },
        itemSubmitted: (item) {
          print("Item submitted: $item");  // Debugging
          setState(() {
            customerNameController.text = item;
            _updateCustomerExistence(item);
          });
        },
        itemSorter: (a, b) {
          return a.compareTo(b); // Sorting suggestion items
        }, key: GlobalKey(),
      ),
    );
  }
}
