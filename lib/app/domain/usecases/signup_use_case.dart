
import 'package:hajir/app/domain/entities/user.dart';
import 'package:hajir/app/domain/repositories/auth_repository.dart';
import 'package:hajir/app/usecases/pram_usecase.dart';

class SignUpUseCase extends ParamUseCase<User, String> {
  final AuthenticationRepository _repo;
  SignUpUseCase(this._repo);

  @override
  Future<User> execute(String username) {
    return _repo.signUp(username);
  }
}
