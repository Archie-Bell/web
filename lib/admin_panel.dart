import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedTab = 0;
  String _selectedRequest = "";

  // Temporary data
  List<Map<String, dynamic>> _getTemporaryRequests() {
    return [
      {"title": "Missing Person 1", "submittedBy": "Jane Doe", "timeAgo": "10 minutes ago"},
      {"title": "Missing Person 2", "submittedBy": "John Smith", "timeAgo": "25 minutes ago"},
      {"title": "Missing Person 3", "submittedBy": "Emma White", "timeAgo": "45 minutes ago"},
      {"title": "Missing Person 4", "submittedBy": "Sophia Brown", "timeAgo": "1 hour ago"},
      {"title": "Missing Person 5", "submittedBy": "Liam Davis", "timeAgo": "3 hours ago"},
      {"title": "Missing Person 6", "submittedBy": "Olivia Green", "timeAgo": "4 hours ago"},
      {"title": "Missing Person 7", "submittedBy": "James Black", "timeAgo": "6 hours ago"},
    ];
  }

  // Temporary data for Active Searches
  List<Map<String, dynamic>> _getActiveSearches() {
    return [
      {"name": "Missing Person 1", "active_since": "1 hour ago"},
      {"name": "Missing Person 2", "active_since": "3 hours ago"},
      {"name": "Missing Person 3", "active_since": "5 hours ago"},
      {"name": "Missing Person 4", "active_since": "7 hours ago"},
      {"name": "Missing Person 5", "active_since": "9 hours ago"},
      {"name": "Missing Person 6", "active_since": "10 hours ago"},
      {"name": "Missing Person 7", "active_since": "12 hours ago"},
    ];
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  void _onRequestSelected(String requestTitle) {
    setState(() {
      _selectedRequest = requestTitle;
    });
  }

  void _showActiveSearches() {
    List<Map<String, dynamic>> tempData = _getActiveSearches(); // Use the temporary data

    // Create a ScrollController
    ScrollController _scrollController = ScrollController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Active Searches"),
          content: Container(
            width: 400, 
            height: 350,
            child: Scrollbar(
              thumbVisibility: true,
              controller: _scrollController, // Attach the ScrollController to the Scrollbar
              child: ListView.builder(
                controller: _scrollController, // Attach the ScrollController to the ListView
                itemCount: tempData.length, // Dynamically handle all items
                itemBuilder: (context, index) {
                  var person = tempData[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Spacing between items
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(person["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text("Active since ${person["active_since"]}", style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // Space between box and button
                        ElevatedButton(
                          onPressed: () {
                            print("Viewing: ${person["name"]}");
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text("View"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archie Bell - Admin Panel'),
        actions: [
          ElevatedButton(
              onPressed: _showActiveSearches,
              child: const Text("Active Searches")),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {}, // TODO: Add logic for logout
            child: const Text("Logout")),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 800;

          return Row(
            children: [
              // Left Panel - Form Request List
              Flexible(
                flex: isSmallScreen ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Recent Form Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _getTemporaryRequests().map((request) {
                            return FormRequestTile(
                              title: request['title'],
                              onTap: _onRequestSelected,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Recent Found Submissions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _getTemporaryRequests().map((request) {
                            return FormRequestTile(
                              title: request['title'],
                              onTap: _onRequestSelected,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Right Panel - Request Details
              Flexible(
                flex: isSmallScreen ? 3 : 4,
                child: RequestDetails(
                  selectedTab: _selectedTab,
                  onTabSelected: _onTabSelected,
                  requestTitle: _selectedRequest,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FormRequestTile extends StatelessWidget {
  final String title;
  final Function(String) onTap;

  FormRequestTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Submitted by Jane Doe ## minutes ago."),
        onTap: () => onTap(title),
      ),
    );
  }
}

class RequestDetails extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabSelected;
  final String requestTitle;

  RequestDetails({required this.selectedTab, required this.onTabSelected, required this.requestTitle});

  @override
  Widget build(BuildContext context) {
    if (requestTitle.isEmpty) {
      return const Center(
        child: Text(
          "Select a form to view the details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      );
    }

    List<Widget> tabContents = [
      OverviewTab(requestTitle: requestTitle),
      ContactTab(requestTitle: requestTitle),
      MissingPersonInfoTab(requestTitle: requestTitle),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(requestTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        TabBarWidget(selectedTab: selectedTab, onTabSelected: onTabSelected),
        Expanded(child: tabContents[selectedTab]),
      ],
    );
  }
}

class TabBarWidget extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabSelected;

  TabBarWidget({required this.selectedTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TabButton(label: "Overview", index: 0, selectedTab: selectedTab, onTabSelected: onTabSelected),
        TabButton(label: "Contact", index: 1, selectedTab: selectedTab, onTabSelected: onTabSelected),
        TabButton(label: "Missing Person Information", index: 2, selectedTab: selectedTab, onTabSelected: onTabSelected),
      ],
    );
  }
}

class TabButton extends StatelessWidget {
  final String label;
  final int index;
  final int selectedTab;
  final Function(int) onTabSelected;

  TabButton({required this.label, required this.index, required this.selectedTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onTabSelected(index),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: selectedTab == index ? FontWeight.bold : FontWeight.normal,
          decoration: selectedTab == index ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  final String requestTitle;

  OverviewTab({required this.requestTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name of the Missing Person",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  requestTitle,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Last Found",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "123 ABC Street, Moose Jaw, SK XXX789",
                  style: TextStyle(fontSize: 16),
                ),
                const Text(
                  "Date and Time: MM/DD/YY 12:34 PM",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const SingleChildScrollView(
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text("Approve"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        showRejectDialog(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Reject"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(
                child: Text(
                  "Placeholder",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactTab extends StatelessWidget {
  final String requestTitle;
  ContactTab({required this.requestTitle});

  @override
  Widget build(BuildContext context) {
    // Temporary test data
    String contactName = "Jane Doe";
    String phoneNumber = "+1 (123) 456-7890";
    List<Map<String, dynamic>> previousSubmissions = [
      {"date": "03/01/25", "time": "12:34 PM", "approved": true},
      {"date": "02/15/25", "time": "10:15 AM", "approved": false},
      {"date": "01/28/25", "time": "03:45 PM", "approved": true},
      {"date": "01/10/25", "time": "09:20 AM", "approved": false},
      {"date": "12/25/24", "time": "06:30 PM", "approved": true},
    ];
    int formCount = previousSubmissions.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Contact Information
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Contact Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(contactName, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                
                const Text("Phone Number", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(phoneNumber, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                
                const Text("Additional Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("This person has submitted $formCount forms this year."),
                const Text("Previously submitted: "),
                const SizedBox(height: 16),
                const Text("This person submitted this form ## minutes ago. (MM/DD/YY at 12:34 PM)"),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Right Column: Scrollable Previous Submissions
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Previous Submissions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Time")),
                        DataColumn(label: Text("Approved?")),
                      ],
                      rows: previousSubmissions.map((submission) {
                        return DataRow(cells: [
                          DataCell(Text(submission["date"])),
                          DataCell(Text(submission["time"])),
                          DataCell(Checkbox(value: submission["approved"], onChanged: (value) {})),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class MissingPersonInfoTab extends StatelessWidget {
  final String requestTitle;
  MissingPersonInfoTab({required this.requestTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Reduced horizontal padding
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Placeholder Image
              Expanded(
                flex: 1,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child: Text(
                      "Placeholder",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Reduced width between columns
              
              // Middle Column: Missing Person Information
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Missing Person Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(requestTitle, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8), // Reduced spacing
                    Container(
                      height: 80, // Reduced height
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const SingleChildScrollView(
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8), // Reduced width between columns
              
              // Right Column: Data Table for Last Found Information
              Expanded(
                flex: 1,
                child: DataTable(
                  columnSpacing: 20, // Adjust column spacing
                  dataRowMinHeight: 50, // Set a reasonable min height
                  dataRowMaxHeight: double.infinity, // Allow dynamic expansion
                  columns: const [
                    DataColumn(label: Text("Last found at")),
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("Time")),
                  ],
                  rows: List.generate(
                    3,
                    (index) => const DataRow(
                      cells: [
                        DataCell(
                          IntrinsicHeight( // Ensures the row grows dynamically
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the top
                              children: [
                                Flexible( // Allows text to wrap inside cell
                                  child: Text(
                                    "123 ABC Street, Moose Jaw, SK XXX789.",
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(Text("MM/DD/YY")),
                        DataCell(Text("12:34 PM")),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Adjusted spacing
          
          // Action buttons (Approve/Reject)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Approve"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  showRejectDialog(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Reject"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showRejectDialog(BuildContext context) {
  TextEditingController reasonController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Reject Form"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Why are you rejecting this form request?"),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: "Enter reason",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center, // Center buttons at the bottom
        actions: <Widget>[
          TextButton(
            child: const Text("Reject"),
            onPressed: () {
              // TODO: Add logic for form rejection
            },
          ),
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}