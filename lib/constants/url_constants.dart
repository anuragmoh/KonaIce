class UrlConstants {

  static const baseUrl = 'https://konaschoolsidedevapi.mi2.in';

  static const login = '/api/v1/sessions';
  static const logout = '/api/v1/sessions';

  static const forgotPassword='/api/v1/users/forgot-password';
  static const dutyStatus = '/api/v2/secure/staffs/{userID}/dutystatus';


  static getDutyStatus({required String userID}) {
     return dutyStatus.replaceAll('{userID}', userID);
  }

}
