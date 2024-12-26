import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/auth/remotes/auth_remote_datasources.dart';

part 'logout_event.dart';
part 'logout_state.dart';
part 'logout_bloc.freezed.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDatasources authRemoteDatasources;
  LogoutBloc(this.authRemoteDatasources) : super(const _Initial()) {
    on<_Logout>((event, emit) async {
      emit (const _Loading());
      final result = await authRemoteDatasources.logout();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Success()),
      );
    });
  }
}
