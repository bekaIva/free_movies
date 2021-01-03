part of 'global_setting.dart';

class Update {
  final String updateUrl;
  final String updateNote;
  Update({this.updateNote, this.updateUrl});
  Update.fromJson(Map<String, dynamic> json)
      : updateUrl = json['updateUrl'],
        updateNote = json['updateNote'];
}
