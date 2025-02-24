import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swag_post/App/request/create/controllers/request_controller.dart';

class Parameters extends StatefulWidget {
  const Parameters({super.key, this.controllerId});
  final String? controllerId;

  @override
  State<Parameters> createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  final _sc = Get.find<RequestCreateController>();
  // Global key to manage form state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // State for select all checkbox
  bool _isSelectAll = false;

  // Method to add a new parameter row
  void _addParameterRow() {
    setState(() {
      _sc.parameters.add(ParameterEntry(
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
      for (var param in _sc.parameters) {
        param.isSelected = _isSelectAll;
      }
    });
  }

  // Method to build URL with selected parameters

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
                // DataTable for Parameters
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
                    child: Obx(
                      () => DataTable(
                        columns: [
                          // Select All Checkbox Column
                          DataColumn(
                            label: Container(
                              height: 55,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Color.fromARGB(
                                              255, 62, 62, 62)))),
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
                                          color: Color.fromARGB(
                                              255, 62, 62, 62)))),
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
                        rows: _sc.parameters.map((parameter) {
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

                                        _isSelectAll = _sc.parameters
                                            .every((p) => p.isSelected);

                                        _sc.buildUrlWithParameters();
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
                                    onChanged: (value) {
                                      _sc.buildUrlWithParameters();
                                    },
                                    controller: parameter.key,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              // Value Input Cell
                              DataCell(
                                SizedBox(
                                  width: Get.width * 0.3,
                                  child: TextFormField(
                                    controller: parameter.value,
                                    onChanged: (value) {
                                      _sc.buildUrlWithParameters();
                                    },
                                    style: const TextStyle(color: Colors.white),
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
                ),

                const SizedBox(height: 10),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addParameterRow,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Parameter'),
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
class ParameterEntry {
  TextEditingController key;
  TextEditingController value;
  bool isSelected;

  ParameterEntry({
    required this.key,
    required this.value,
    this.isSelected = false,
  });
}
