import 'package:hydrated_bloc/hydrated_bloc.dart';

class MockStorage implements Storage {
  @override
  dynamic read(
    String key,
  ) {}

  @override
  Future<void> write(
    String key,
    dynamic value,
  ) async {}

  @override
  Future<void> delete(
    String key,
  ) async {}

  @override
  Future<void> clear() async {}
}
