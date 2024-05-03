

import '../../domain/entity/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    String? loginId,
    String? password,
    String? personFname,
    String? deptName,
    String? personLname,
    String? orgName,
    String? clientAuthToken,
  }) : super(
          loginId: loginId,
          password: password,
          personFname: personFname,
          deptName: deptName,
          personLname: personLname,
          orgName: orgName,
          clientAuthToken: clientAuthToken,
        );

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final userLogin = json['response_data']['user_login'];
      if (userLogin == null) {
      throw Exception(
          'Invalid username or password'); // Throw an exception if asset list is null
    }

    return LoginModel(
      loginId: userLogin['login_id'],
      password: userLogin['login_password'],
      personFname: userLogin['person_fname'],
      deptName: userLogin['dept_name'],
      personLname: userLogin['person_lname'],
      orgName: userLogin['org_name'],
      clientAuthToken: userLogin['client_aut_token'],
    );
  }
    Map<String, dynamic> toJson() {
    return {
      'login_id': loginId,
      'login_password': password,
      'person_fname': personFname,
      'dept_name': deptName,
      'person_lname': personLname,
      'org_name': orgName,
      'client_aut_token': clientAuthToken,
    };
  }
}
