
import 'package:project_0/models/genres_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'filter_model.g.dart';

@HiveType(typeId: 0)
class FilterModel {
@HiveField(0)
  final int id = Uuid().v4().hashCode ;
  @HiveField(1)
  final String name = '';
  @HiveField(2)
  final List<GenresModel> genres = [];
  @HiveField(3)
  final bool favorite = false;
  final bool isSelected = false;

  
  FilterModel();
}