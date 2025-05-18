part of 'item_sales_bloc.dart';

@freezed
class ItemSalesEvent with _$ItemSalesEvent {
  const factory ItemSalesEvent.started() = _Started;
  const factory ItemSalesEvent.getReport(DateTime startDate, DateTime endDate) =
      _GetReport;
}