import 'package:hive_flutter/hive_flutter.dart';

class ActivityLog {
  final String title;
  final String timestamp;
  final String userRole;

  ActivityLog({required this.title, required this.timestamp, required this.userRole});
}

class FieldTask {
  final String id;
  final String siteName;
  final String location;
  final String priority;
  String status;
  String visitNotes;
  String aiSummary;
  String aiFlag;
  final String assignedTo;
  List<ActivityLog> timeline;

  FieldTask({
    required this.id,
    required this.siteName,
    required this.location,
    required this.priority,
    required this.status,
    this.visitNotes = '',
    this.aiSummary = '',
    this.aiFlag = 'Normal',
    required this.assignedTo,
    required this.timeline,
  });
}

// ------------------------------------------------------------------
// CENTRALIZED DATA SEEDING VARIABLE & REPOSITORY
// ------------------------------------------------------------------
List<FieldTask> globalDummyTasks = [];

class HiveStorageBridge {
  static final _box = Hive.box('field_tasks_box');

  // Core boot method: Loads file data parameters or seeds clean placeholders
  static void initializeAndSyncData() {
    if (_box.isEmpty) {
      globalDummyTasks = [
        FieldTask(
          id: "TSK-9021",
          siteName: "Metro Hub Router Terminal Alpha",
          location: "Zone 4 - Core Infrastructure",
          priority: "High",
          status: "Pending",
          assignedTo: "agent",
          timeline: [
            ActivityLog(title: "Task created by Regional Dispatcher", timestamp: "10:15 AM", userRole: "Admin/Manager"),
            ActivityLog(title: "Allocated to active operational grid", timestamp: "10:30 AM", userRole: "Team Lead"),
          ],
        ),
        FieldTask(
          id: "TSK-4082",
          siteName: "Reliance Distribution Hub B3",
          location: "Commercial Complex Sector 12",
          priority: "Medium",
          status: "In-Progress",
          assignedTo: "agent",
          timeline: [
            ActivityLog(title: "Task created and pushed to cloud", timestamp: "09:00 AM", userRole: "Admin/Manager"),
            ActivityLog(title: "Agent checked into tracking boundary", timestamp: "11:15 AM", userRole: "Field Agent"),
          ],
        ),
        FieldTask(
          id: "TSK-1011",
          siteName: "Downtown Smart Node Node-X",
          location: "South Block Crossing",
          priority: "Low",
          status: "Pending",
          assignedTo: "agent",
          timeline: [
            ActivityLog(title: "Task provisioned into backlog pool", timestamp: "02:00 PM", userRole: "Admin/Manager"),
          ],
        ),
      ];
      saveToDisk();
      return;
    }

    // Reconstruction phase loop from binary mapping objects
    List<FieldTask> dynamicList = [];
    var rawData = _box.get('tasks') as List;

    for (var item in rawData) {
      var map = Map<String, dynamic>.from(item);
      var rawTimeline = map['timeline'] as List;

      List<ActivityLog> parsedTimeline = rawTimeline.map((logItem) {
        var logMap = Map<String, dynamic>.from(logItem);
        return ActivityLog(
          title: logMap['title'],
          timestamp: logMap['timestamp'],
          userRole: logMap['userRole'],
        );
      }).toList();

      dynamicList.add(FieldTask(
        id: map['id'],
        siteName: map['siteName'],
        location: map['location'],
        priority: map['priority'],
        status: map['status'],
        visitNotes: map['visitNotes'],
        aiSummary: map['aiSummary'],
        aiFlag: map['aiFlag'],
        assignedTo: map['assignedTo'],
        timeline: parsedTimeline,
      ));
    }
    globalDummyTasks = dynamicList;
  }

  static void saveToDisk() {
    List<Map<String, dynamic>> dataMap = globalDummyTasks.map((task) {
      return {
        'id': task.id,
        'siteName': task.siteName,
        'location': task.location,
        'priority': task.priority,
        'status': task.status,
        'visitNotes': task.visitNotes,
        'aiSummary': task.aiSummary,
        'aiFlag': task.aiFlag,
        'assignedTo': task.assignedTo,
        'timeline': task.timeline.map((log) => {
          'title': log.title,
          'timestamp': log.timestamp,
          'userRole': log.userRole,
        }).toList(),
      };
    }).toList();

    _box.put('tasks', dataMap);
  }
}