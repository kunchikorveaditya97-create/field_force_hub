import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import 'tasks_tab.dart';
import 'reports_tab.dart';

class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _tabIndex = 0;
  final TaskController controller = Get.find<TaskController>();
  dynamic _selectedReportingTask;

  @override
  Widget build(BuildContext context) {
    bool isFieldForce = controller.currentRole.value == 'Field Agent' || controller.currentRole.value == 'Auditor';

    Widget buildDashboard() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WELCOME, ${controller.username.value.toUpperCase()}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Role Authorization: ${controller.currentRole.value}', style: const TextStyle(color: Color(0xFFB176FF), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const CircleAvatar(backgroundColor: Color(0xFF1E0B36), child: Icon(Icons.verified_user, color: Colors.white))
              ],
            ),
            const SizedBox(height: 30),
            Obx(() => GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.4,
              children: [
                _buildStatCard(Icons.storage, 'Database Layer', 'Hive Storage Locked'),
                _buildStatCard(Icons.assignment, 'Cached Records', '${controller.tasks.length} Nodes'),
                _buildStatCard(Icons.security, 'Access Hierarchy', controller.currentRole.value),
                _buildStatCard(Icons.insights, 'Mock AI Engine', 'Ready for Inputs'),
              ],
            ))
          ],
        ),
      );
    }

    // TAB TREE MATRIX WITH GETX DRIVEN AUTO UPDATE TIMELINES
    final List<Widget> tabs = [
      buildDashboard(),
      TasksTab(
        role: controller.currentRole.value,
        onTaskSelected: (task) {
          setState(() {
            _selectedReportingTask = task;
            _tabIndex = 2; // Auto routing shift directly to reporting block
          });
        },
      ),
      ReportsTab(
        selectedTask: _selectedReportingTask,
        onSubmissionSuccess: () {
          setState(() { _tabIndex = 1; });
        },
      ),

      // ELAPSED RUNTIME TIMELINE TRACER DISPLAY (GetX Live System Integration)
      Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('System Log Audit Trail Timeline', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.tasks.length,
              itemBuilder: (context, idx) {
                final task = controller.tasks[idx];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📍 NODE PROFILE: ${task.id}', style: const TextStyle(color: Color(0xFFB176FF), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                    const SizedBox(height: 8),
                    ...task.timeline.map((log) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Container(
                          decoration: const BoxDecoration(border: Border(left: BorderSide(color: Colors.white10, width: 2))),
                          padding: const EdgeInsets.only(left: 16.0, bottom: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(log.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              // GETX REAL-TIME DYNAMIC INTERVAL PARSING CONVERSION CALL
                              Text(
                                '${controller.convertToTimeAgo(log.timestamp)} | User Domain: ${log.userRole}',
                                style: const TextStyle(color: Colors.white38, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const Divider(color: Colors.white10, height: 20),
                  ],
                );
              },
            )
          ],
        ),
      ))
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F081D),
      appBar: AppBar(title: const Text('FIELD FORCE HUB', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)), backgroundColor: const Color(0xFF1E0B36), centerTitle: true, elevation: 0),
      body: IndexedStack(index: _tabIndex, children: tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() { _tabIndex = index; }),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E0B36),
        selectedItemColor: const Color(0xFFB176FF),
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.terminal), label: 'Terminal'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.badge), label: 'Timeline'),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String t, String v) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF160D29), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: const Color(0xFFB176FF), size: 20),
          Text(t, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          Text(v, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}