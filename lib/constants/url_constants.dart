class UrlConstants {

  static const baseUrl = 'https://konaschoolsidedevapi.mi2.in';

  static const login = '/api/v1/sessions';
  static const logout = '/api/v1/secure/sessions';

  static const forgotPassword='/api/v1/users/forgot-password';
  static const dutyStatus = '/api/v1/secure/staffs/{userID}/dutystatus';

  static const customerList = '/api/v1/secure/users-list';


  static getDutyStatus({required String userID}) {
     return dutyStatus.replaceAll('{userID}', userID);
  }

  static getCustomerList({required String searchText}) {
    return '$customerList?role=Staff&searchText=$searchText';
  }

}
