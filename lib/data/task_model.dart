import 'package:hive_flutter/hive_flutter.dart';

class ActivityLog {
  final String title;
  final DateTime timestamp;
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

List<FieldTask> globalDummyTasks = [];

class HiveStorageBridge {
  static final _box = Hive.box('field_tasks_box');

  static void initializeAndSyncData() {
    if (_box.isEmpty) {
      _seedDatabaseInitialEntries();
      return;
    }

    try {
      List<FieldTask> dynamicList = [];
      var rawData = _box.get('tasks') as List;

      for (var item in rawData) {
        var map = Map<String, dynamic>.from(item);
        var rawTimeline = map['timeline'] as List;

        List<ActivityLog> parsedTimeline = rawTimeline.map((logItem) {
          var logMap = Map<String, dynamic>.from(logItem);
          DateTime parsedTime;
          try {
            parsedTime = DateTime.parse(logMap['timestamp']);
          } catch (e) {
            parsedTime = DateTime.now();
          }
          return ActivityLog(
            title: logMap['title'],
            timestamp: parsedTime,
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
    } catch (e) {
      _seedDatabaseInitialEntries();
    }
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
          'timestamp': log.timestamp.toIso8601String(),
          'userRole': log.userRole,
        }).toList(),
      };
    }).toList();

    _box.put('tasks', dataMap);
  }

  static void _seedDatabaseInitialEntries() {
    globalDummyTasks = [
      FieldTask(
        id: "TSK-9021",
        siteName: "Metro Hub Router Terminal Alpha",
        location: "Zone 4 - Core Infrastructure",
        priority: "High",
        status: "Pending",
        assignedTo: "agent",
        timeline: [
          ActivityLog(title: "Task assigned to network maintenance team", timestamp: DateTime.now().subtract(const Duration(hours: 4)), userRole: "Admin"),
          ActivityLog(title: "Log profile synchronized onto local buffer", timestamp: DateTime.now().subtract(const Duration(minutes: 45)), userRole: "Team Lead"),
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
          ActivityLog(title: "Site parameters verified on terminal launcher", timestamp: DateTime.now().subtract(const Duration(hours: 2)), userRole: "Regional Manager"),
        ],
      ),
    ];
    saveToDisk();
  }
}