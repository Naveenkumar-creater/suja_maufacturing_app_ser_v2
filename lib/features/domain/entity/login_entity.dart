import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable{
  final String? loginId;
  final String? password;
  final String? personFname;
  final String? deptName;
  final String? personLname;
  final String? orgName;
  final String? clientAuthToken;

  const LoginEntity({
    this.loginId,
    this.password,
    this.personFname,
    this.deptName,
    this.personLname,
    this.orgName,
    this.clientAuthToken,
  });
  
  @override

  List<Object?> get props => [loginId,password];

}