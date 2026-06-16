import 'package:get/get.dart';
import '../data/task_model.dart';

class TaskController extends GetxController {
  var tasks = <FieldTask>[].obs;
  var currentRole = ''.obs;
  var username = ''.obs;

  String convertToTimeAgo(DateTime loggedTime) {
    final Duration diff = DateTime.now().difference(loggedTime);

    if (diff.inDays >= 1) {
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
    } else if (diff.inMinutes >= 1) {
      return "${diff.inMinutes} min${diff.inMinutes > 1 ? 's' : ''} ago";
    } else {
      return "Just now";
    }
  }

  void bootOfflineDatabase(String user, String role) {
    username.value = user;
    currentRole.value = role;

    HiveStorageBridge.initializeAndSyncData();
    tasks.assignAll(globalDummyTasks);
  }

  void submitFieldAuditLogs(FieldTask task, String notes) {
    String query = notes.toLowerCase();
    task.visitNotes = notes;
    task.status = "Completed";
    task.aiFlag = "Normal";
    task.aiSummary = "Mock AI Audit: Operations parameters match reference metrics base setup fields securely.";

    if (query.contains('broken') || query.contains('fault') || query.contains('error')) {
      task.aiFlag = "Warning";
      task.aiSummary = "⚠️ MOCK AI FLAG: Component failure logs captured inside report parameters.";
    }
    if (query.contains('theft') || query.contains('damage') || query.contains('danger') || query.contains('fire')) {
      task.aiFlag = "Critical";
      task.aiSummary = "🚨 MOCK AI WARNING: Operational safety hazard detected. Immediate ground check required.";
    }

    task.timeline.add(ActivityLog(
        title: "Visit completed & field report compiled",
        timestamp: DateTime.now(),
        userRole: currentRole.value
    ));

    HiveStorageBridge.saveToDisk();
    tasks.refresh();
  }
}