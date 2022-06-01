class UrlConstants {
  static const baseUrl = 'https://konaschoolsidedevapi.mi2.in';

  static const login = '/api/v1/sessions';
  static const logout = '/api/v1/secure/sessions';
  static const getProfile = '/api/v1/secure/users/{userId}';

  static const forgotPassword = '/api/v1/users/forgot-password';
  static const dutyStatus = '/api/v1/secure/staffs/{userID}/dutystatus';
  static const clockInOutDetails =
      '/api/v1/secure/staffs/{userID}/check-in-detail';

  static const customerList = '/api/v2/secure/customer-list';

  static const syncData = '/api/v2/secure/event-menu-sync';

  static const placeOrder = '/api/v2/secure/orders-stripe/staff-user';
  static const payOrder = '/api/v2/secure/orders-payment/staff-user';
  static const finixSendReceipt =
      '/api/v2/secure/orders/{orderId}/finix/receipt';
  static const refundPayment =
      '/api/v2/secure/orders/{orderId}/finix/refund';
  static const finixMannualPay = '';

  static const assets =
      '/api/v1/secure/assets/grid-data?limit=9999&applyActivatedStatus=true&activated=true';

  static const createAdhocEvent = '/api/v1/secure/events/adhoc';

  static const allOrders = '/api/v2/secure/orders';

  static getAllOrders(
      {required String orderStatus,
      required String eventId,
      required int offset,
      required int lastSync}) {
    return '$allOrders?searchText=&orderStatus=$orderStatus&eventId=$eventId&limit=0&offset=$offset&lastSyncAt=$lastSync';
  }

  static getDutyStatus({required String userID}) {
    return dutyStatus.replaceAll('{userID}', userID);
  }

  static getFinixSendReceipt({required String orderId}) {
    return finixSendReceipt.replaceAll('{orderId}', orderId);
  }

  static getRefundPayment({required String orderId}) {
    return refundPayment.replaceAll('{orderId}', orderId);
  }

  static getCustomerList({required String searchText}) {
    return '$customerList?searchText=$searchText';
  }

  static getClockInOutDetails(
      {required String userID,
      required String startTimestamp,
      required String endTimestamp}) {
    return '$clockInOutDetails?fromDate=$startTimestamp&toDate=$endTimestamp'
        .replaceAll('{userID}', userID);
  }

  static getMyProfile({required String userID}) {
    return getProfile.replaceAll('{userId}', userID);
  }

  static updateMyProfile({required String userID}) {
    return getProfile.replaceAll('{userId}', userID);
  }

  static deleteOrder({required String orderId}) {
    return '$allOrders?orderCodeOrId=$orderId';
  }

  static const paymentBaseUrl = 'https://api.stripe.com';

  static const paymentGetToken = '/v1/tokens';

  static const paymentMethod = '/v1/payment_methods';
}
