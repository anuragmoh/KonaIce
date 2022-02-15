class UrlConstants {

  static const baseUrl = 'https://konaschoolsidedevapi.mi2.in';

  static const login = '/api/v1/sessions';
  static const logout = '/api/v1/secure/sessions';

  static const forgotPassword='/api/v1/users/forgot-password';
  static const dutyStatus = '/api/v1/secure/staffs/{userID}/dutystatus';
  static const clockInOutDetails = '/api/v1/secure/staffs/{userID}/check-in-detail';

  static const customerList = '/api/v1/secure/users-list';

  static const syncData = '/api/v2/secure/event-menu-sync';

  static const placeOrder = '/api/v2/secure/orders-stripe/staff-user';
  static const payOrder = '/api/v2/secure/orders-payment/staff-user';


  static getDutyStatus({required String userID}) {
     return dutyStatus.replaceAll('{userID}', userID);
  }

  static getCustomerList({required String searchText}) {
    return '$customerList?role=Customer&searchText=$searchText';
  }

   static getClockInOutDetails({required String userID, required String startTimestamp, required String endTimestamp}) {
     return '$clockInOutDetails?fromDate=$startTimestamp&toDate=$endTimestamp'.replaceAll('{userID}', userID);
   }

}
