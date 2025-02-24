import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swag_post/App/request/create/controllers/request_controller.dart';

class Headers extends StatefulWidget {
  const Headers({super.key});

  @override
  State<Headers> createState() => _HeadersState();
}

class _HeadersState extends State<Headers> {
  // Global key to manage form state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // State for select all checkbox
  bool _isSelectAll = false;
  final _sc = Get.find<RequestCreateController>();

  var autoheaders = {
    "Content-Type": "application/json",
  };

  // Method to add a new parameter row
  void _addParameterRow() {
    setState(() {
      _sc.headersEntries.add(HeaderEntry(
        key: TextEditingController(),
        value: TextEditingController(),
        isSelected: false,
      ));
    });
  }

  // Method to toggle all checkboxes
  void _toggleSelectAll(bool? value) {
    setState(() {
      _isSelectAll = value ?? false;
      for (var param in _sc.headersEntries) {
        param.isSelected = _isSelectAll;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Query Params',
                  style: TextStyle(color: Color(0xff9b9b9b)),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 62, 62, 62))),
                    child: DataTable(
                      columns: [
                        // Select All Checkbox Column
                        DataColumn(
                          label: Container(
                            height: 55,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: const BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color:
                                            Color.fromARGB(255, 62, 62, 62)))),
                            child: Checkbox(
                              side: const BorderSide(color: Colors.white),
                              value: _isSelectAll,
                              onChanged: _toggleSelectAll,
                            ),
                          ),
                        ),
                        // Key Column
                        DataColumn(
                          label: Container(
                            width: Get.width * 0.3,
                            height: 55,
                            decoration: const BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color:
                                            Color.fromARGB(255, 62, 62, 62)))),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Key',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                        // Value Column
                        DataColumn(
                          label: SizedBox(
                            width: Get.width * 0.3,
                            child: const Text('Value',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                      rows: _sc.headersEntries.map((parameter) {
                        return DataRow(
                          cells: [
                            // Checkbox Cell
                            DataCell(
                              Container(
                                height: 50,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: Color.fromARGB(
                                                255, 62, 62, 62)))),
                                child: Checkbox(
                                  value: parameter.isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      parameter.isSelected = value ?? false;

                                      // Update select all state
                                      _isSelectAll = _sc.headersEntries
                                          .every((p) => p.isSelected);
                                      _sc.buildHeader();
                                    });
                                  },
                                ),
                              ),
                            ),
                            // Key Input Cell
                            DataCell(
                              Container(
                                width: Get.width * 0.3,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: Color.fromARGB(
                                                255, 62, 62, 62)))),
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: parameter.key,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                  onChanged: (value) {
                                    _sc.buildHeader();
                                  },
                                ),
                              ),
                            ),
                            // Value Input Cell
                            DataCell(
                              SizedBox(
                                width: Get.width * 0.3,
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: parameter.value,
                                  onChanged: (value) {
                                    _sc.buildHeader();
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add Parameter Button
                    ElevatedButton.icon(
                      onPressed: _addParameterRow,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Header'),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Data model for parameter entries
class HeaderEntry {
  TextEditingController key;
  TextEditingController value;
  bool isSelected;

  HeaderEntry({
    required this.key,
    required this.value,
    this.isSelected = false,
  });
}
