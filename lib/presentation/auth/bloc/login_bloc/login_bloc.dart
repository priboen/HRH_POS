import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hrh_pos/data/datasources/auth/remotes/auth_remote_datasources.dart';
import 'package:hrh_pos/data/models/response/auth_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasources authRemoteDatasources;
  LoginBloc(this.authRemoteDatasources) : super(const _Initial()) {
    on<_Login>((event, emit) async{
      emit(const _Loading());
      final result = await authRemoteDatasources.login(event.email, event.password,);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      );
    });
  }
}
