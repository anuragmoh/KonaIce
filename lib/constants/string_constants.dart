import 'package:kona_ice_pos/utils/date_formats.dart';

class StringConstants {
  static const title = "Kona Ice";
  static const loginText = "Log In";
  static const emailId = 'Email ID';
  static const password = 'Password';
  static const forgotPassword = 'Forgot Password?';
  static const signIn = 'Sign In';
  static const rememberPassword = 'Remember Password?';
  static const submit = 'Submit';
  static const pay = 'Pay';
  static const okay = 'Okay';
  static const signOut = 'Sign Out';
  static const hintEmail = "abc@gmail.com";
  static const na = 'NA';
  static const usCountryCode = '+1';
  static const test = 'TestCertification';
  static const bbpos = 'BBPOS';
  static const empty = 'empty';
  static const foodExtraPopupMsg = "text to reach back";
  static const reconnect = 'Reconnect';

  //DB Insertion default Value
  static const trueText = 'true';
  static const falseText = 'false';

  //AccountSwitch Screen TEXT
  static const selectMode = 'Select Mode';
  static const staffMode = 'Staff Mode';
  static const customerMode = 'Customer Mode';

//DASHBOARD TEXT
  static const dashboard = 'DASHBOARD';
  static const createAdhocEvent = 'Create Adhoc Event +';
  static const home = 'Home';
  static const notification = 'Notifications';
  static const settings = 'Settings';
  static const clockOut = 'Clock Out';
  static const clockIn = 'Clock In';
  static const defaultClockInTime = '00:00:00';

  //Event Menu Screen Text

  static const product = 'Product';
  static const orders = 'Orders';
  static const dummyOrder = "35891456";
  static const plusSymbol = '+';

  static const minusSymbol = '-';

  static const customMenu = 'Custom Menu';
  static const allCategories = 'All Categories';
  static const addFoodItems = 'Add food items ${StringConstants.plusSymbol}';
  static const addFoodItemsExtras =
      'Add Food Extras ${StringConstants.plusSymbol}';
  static const addNewMenuItem = 'Add New Menu Item';
  static const clear = 'CLEAR';
  static const cancel = 'CANCEL';
  static const cancelProfile = 'Cancel';
  static const addCustomer = 'Select Customer';
  static const guestCustomer = 'Guest Customer';
  static const charge = 'CHARGE';
  static const symbolDollar = '\$';
  static const saveOrder = 'Save Order';
  static const newOrder = 'New Order';
  static const noItemsAdded = 'No Items Added';
  static const customize = 'Customize';
  static const add = 'Add';
  static const update = 'Update';
  static const customMenuPackage = 'Custom Menu Package';
  static const amount = 'Amount';
  static const enterAmount = 'Enter Amount';
  static const save = 'Save';
  static const enterMenuName = 'Enter Menu Name';
  static const applyCoupon = 'Apply Coupon';
  static const addTip = 'Add Tip';
  static const goToSplash = 'goToSplash';
  static const addDiscount = "Add Discount";
  static const searchCustomerNameORNum = 'Search Customer';

  static const orderDetails = 'Order Details';
  static const customerName = 'Customer Name';
  static const phone = 'Phone';
  static const email = 'Email';
  static const orderItem = 'Order Item';
  static const foodCost = 'Food Cost(s):';
  static const salesTax = 'Sales Tax:';
  static const subTotal = 'Subtotal:';
  static const discount = 'Discount:';
  static const tip = 'Tip:';
  static const all_order_tip = 'Tip';
  static const all_order_taxAmount = 'Tax Amount';
  static const total = 'Total:';
  static const foodOrders = 'Food Orders';
  static const filterOrders = 'Filter Orders';
  static const orderId = 'Order ID';
  static const date = 'Date';
  static const payment = 'Payment';
  static const price = 'Price';
  static const status = 'Status';
  static const items = 'ITEMS';
  static const inProcess = 'IN PROGRESS';
  static const orderDate = 'Order Date';
  static const street = 'Street';
  static const storeAddress = 'Store Address';
  static const eventName = 'Event Name';
  static const eventAddress = 'Event Address';
  static const completed = 'Completed';
  static const resume = 'Resume';
  static const pending = 'Pending';
  static const preparing = 'Preparing';
  static const saved = 'Saved';
  static const qty = 'Qty';
  static const refund = 'Refund';
  static const refunded = 'Refunded';
  static const paymentMode = "Payment Mode";
  static const paymentModeCard = "Card";
  static const paymentModeCash = "Cash";

  static const totalAmount = 'Total Amount';
  static const amountReceived = 'Amount Received';
  static const amountToReturn = 'Amount To Return';
  static const proceed = 'Proceed';
  static const cash = 'Cash';
  static const creditCard = 'Credit Card(Scan)';
  static const creditCardManual = 'Credit Card(Manual)';
  static const qrCode = 'QR Code';
  static const paymentSuccessful = 'Payment Successful';
  static const howWouldYouLikeToReceiveTheReceipt =
      'Would you like to receive the receipt?';
  static const transactionId = 'Transaction ID';
  static const textMessage = 'Text Message';
  static const billTotal = 'Bill Total';
  static const orderCompleted = 'Your order is complete !';
  static const selectPaymentOption = 'Select Payment Option';
  static const confirmCardDetails = 'Please Confirm Details';

  static const cardDetails = 'Card Details';
  static const cardNumber = 'Please Enter Card Number';
  static const cardExpiryMonthYear = 'Month/Year';
  static const cardExpiryYear = 'Expiry Year';
  static const cardExpiryMsg = 'Expiry Date';
  static const cardExpiryEnterMsg = 'Please Enter Month/Year';
  static const cardExpiryCheckkMsg = "Please Check Month/Year";
  static const cardExpiryYearEnterMsg = "Please Enter Year";
  static const cardExpiryYearCheckMsg = "Please Check Year";
  static const cvvEnterMsg = "Please Enter Cvv";
  static const cardCvc = 'CVC';
  static const cardCvcMsg = 'Card CVC';
  static const addCreditCardDetails = 'Add Credit Card Details';
  static const paymentFail = 'Payment Failed';
  static const paymentFailMessage =
      'We had an issue processing your payment. Please try again.';
  static const totalAmountBlank = 'Please Enter Amount';
  static const enterZipcode = 'Please Enter ZipCode';

  // Create adhoc event popup
  static const popHeading = "Create Adhoc Event";
  static const name = "Name";
  static const enterName = "Enter event name";
  static const address = "Address";
  static const enterAddress = "Enter address";
  static const city = "City";
  static const enterCity = "Enter city";
  static const state = "State";
  static const enterState = "Enter state";
  static const zipCode = "Zipcode";
  static const enterZipCode = "Enter zipcode";
  static const equipment = "Equipment";
  static const selectEquipment = "Select Equipment";
  static const create = "Create";
  static const defaultEventName = "POS_MiscSales_";

  //MyProfile
  static const myProfile = 'My Profile';
  static const firstName = 'First Name';
  static const lastName = 'Last Name';
  static const contactNumber = 'Contact Number';
  static const changePassword = 'Change Password';
  static const oldPassword = 'Old Password*';
  static const newPassword = 'New Password*';
  static const confirmPassword = 'Confirm Password*';
  static const enterFirstName = 'Enter First Name';
  static const enterLastName = 'Enter Last Name';
  static const enterContactNumber = 'Enter Contact Number';
  static const enterEmailId = 'Enter Email ID';
  static const enterOldPassword = 'Enter Old Password';
  static const enterNewPassword = 'Enter New Password';
  static const enterConfirmPassword = 'Enter Confirm Password';
  static const confirm = "Confirm";
  static const edit = "Edit";
  static const error = "Error";
  static const markAllAsRead = 'Mark all as read';

  static const internetConnectionError = 'No Internet connection';
  static const apiNotResponding = 'API not responded in time';
  static const errorOccurredWithCode = 'Error occurred with code';
  static const errorSessionExpire = 'Your session has expired';

  // Error Messages
  static const emptyValidEmail = 'Please Enter Email Address';
  static const enterValidEmail = 'Please Enter Valid Email Address';
  static const emptyValidPassword = 'Please Enter Password';
  static const enterValidPassword = 'Please Enter Valid Password';
  static const enterValidPasswordLength =
      'Password should be at least 8 to 12 alphanumeric characters';
  static const enterSpecialChar = "Please Enter At least 1 Special character";
  static const noInternetConnection = 'Please check your internet connection.';
  static const somethingWentWrong =
      'Sorry, something went wrong. Please try again.';
  static const emptyLastName = "Please Enter Last Name";
  static const emptyFirstName = "Please Enter First Name";
  static const emptyContactNumber = "Please Enter Contact Number";

  static const emptyEventName = "Please enter event name";
  static const emptyAddress = "Please enter address";
  static const emptyCity = "Please enter city";
  static const emptyState = "Please enter state";
  static const emptyZipCode = "Please enter zipcode";
  static const selectEquipments = "Please select equipment";

  //Success Message
  static const savedOrderSuccess = 'Order saved successfully!';
  static const profileUpdateSuccessfully = 'Profile saved successfully!';
  static const eventCreatedSuccessfully = "Adhoc event created successfully";
  static const emailSendSuccessfully = "Email sent successfully.";

  //Data not available messages
  static const eventNotAvailable =
      'No event has been assigned to you for today';
  static const noMenuItemsAvailable =
      'No menu items available for the selected event';
  static const noOrdersToDisplay = "No records found in the order history";
  static const noRecordsFound = "No such records found";

  // Dialog String

  static const confirmMessage = "Do you really want to clear the cart ?";
  static const yes = "Yes";
  static const no = "No";
  static const done = "Done";
  static const confirmNewOrder =
      "Do you want to save or cancel currently selected order ?";
  static const btnCancel = "Cancel";
  static const confirmAmountMessage =
      "Are you sure, you want to refund the amount?";

  //Enter Tip Amount
  static const enterTip = "Enter Tip Amount.";

  //all Order status
  static const paymentStatusSuccess = "SUCCESS";
  static const paymentStatusFailed = "paymentFailed";
  static const paymentStatusSucc = "paymentSuccess";
  static const paymentStatus = "paymentStatus";
  static const paymentStatusPending = "PENDING";
  static const orderStatusSaved = "saved";
  static const orderStatusCompleted = "COMPLETED";
  static const orderStatusPreparing = "preparing";
  static const orderStatusCancelled = "CANCELLED";
  static const orderStatusNew = "NEW";

  //booleans
  static const updateTrue = "true";
  static const updateFalse = "false";

  // all device screen
  static const allDeviceScreenHead =
      "Please select customer device from the list";

  static String noDeviceAvailableToConnect = "No device available to connect";

  String getDefaultEventName() {
    return defaultEventName + Date.getDateAndTime();
  }
}

class ConstantKeys {
  static String cardValue = 'value';
  static String cardNumber = 'cardNumber';
  static String cardExpiry = 'cardExpiry';
  static String cardCvv = "cardCvv";
  static String cardMonth = "cardMonth";
  static String zipcode = "zipcode";
}
