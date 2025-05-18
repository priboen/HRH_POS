part of 'sync_all_data_bloc.dart';

@freezed
class SyncAllDataEvent with _$SyncAllDataEvent {
  const factory SyncAllDataEvent.started() = _Started;
  const factory SyncAllDataEvent.syncAllData() = _SyncAllData;
}
