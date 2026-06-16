import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../data/task_model.dart';

class TasksTab extends StatefulWidget {
  final String role;
  final Function(FieldTask) onTaskSelected;

  const TasksTab({super.key, required this.role, required this.onTaskSelected});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  String selectedFilter = 'All';
  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    bool canManage = widget.role == 'Admin' || widget.role == 'Regional Manager' || widget.role == 'Team Lead';

    return Obx(() {
      List<FieldTask> filtered = controller.tasks.where((t) {
        if (selectedFilter == 'All') return true;
        return t.status == selectedFilter;
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start, // <-- FIXED: CrossAxisAlignment ab sahi hai!
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Operational Checklists Matrix', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedFilter,
                  dropdownColor: const Color(0xFF1E0B36),
                  style: const TextStyle(color: Color(0xFFB176FF), fontWeight: FontWeight.bold),
                  underline: Container(),
                  items: <String>['All', 'Pending', 'In-Progress', 'Completed'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                  onChanged: (val) => setState(() { selectedFilter = val!; }),
                )
              ],
            ),
          ),
          if (canManage)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF25143E), borderRadius: BorderRadius.circular(10)),
                child: Text('Privileged Scope ($selectedFilter): Managing cross-team operational data maps.', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ),
            ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No parameters registered matching filter criteria.', style: TextStyle(color: Colors.white38, fontSize: 13)))
                : ListView.builder(
              itemCount: filtered.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, idx) {
                final task = filtered[idx];
                Color priorityColor = task.priority == 'High' ? Colors.redAccent : (task.priority == 'Medium' ? Colors.orangeAccent : Colors.greenAccent);

                return Card(
                  color: const Color(0xFF160D29),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white10)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(task.id, style: TextStyle(color: priorityColor, fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                            Text(task.status, style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(task.siteName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(task.location, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                        const Divider(color: Colors.white10, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Priority: ${task.priority}', style: TextStyle(color: priorityColor, fontSize: 12)),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25143E), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                              onPressed: () => widget.onTaskSelected(task),
                              child: Text(task.status == 'Completed' ? 'View Logs' : 'Execute Visit', style: const TextStyle(color: Color(0xFFB176FF), fontSize: 11, fontWeight: FontWeight.bold)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
    });
  }
}