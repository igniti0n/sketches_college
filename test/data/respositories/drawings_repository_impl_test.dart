import 'package:mockito/mockito.dart';
import 'package:paint_app/data/datasources/database_source.dart';
import 'package:paint_app/data/repositories/drawings_repository_impl.dart';

class MockDatabaseSource extends Mock implements DatabaseSource {}

void main() {
  final MockDatabaseSource _mockDb = MockDatabaseSource();
  final DrawingsRepositoryImpl drawingsRepositoryImpl =
      DrawingsRepositoryImpl(_mockDb);
}
