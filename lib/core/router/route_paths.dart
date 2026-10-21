class RoutePaths {
  RoutePaths._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/login/otp';
  static const activate = '/activate';
  static const forgotPassword = '/forgot-password';
  static const lock = '/lock';

  // Onglets (navigation inférieure)
  static const home = '/home';
  static const finances = '/finances';
  static const tracking = '/tracking';
  static const messages = '/messages';
  static const more = '/more';

  // Écrans secondaires
  static String invoice(String id) => '/finances/invoice/$id';
  static String pay(String invoiceId) => '/finances/pay/$invoiceId';
  static String paymentStatus(String paymentId) => '/finances/payment/$paymentId';
  static const timetable = '/timetable';
  static String timetableSlot(String id) => '/timetable/slot/$id';
  static const timetableShared = '/timetable/shared';
  static const calendar = '/calendar';
  static const newTicket = '/messages/new';
  static String conversation(String id) => '/messages/thread/$id';
  static const announcements = '/announcements';
  static const appointments = '/appointments';
  static const documents = '/documents';
  static const discipline = '/discipline';
  static const notifications = '/notifications';
  static const settings = '/settings';
  static const profile = '/profile';
  static const about = '/about';
  static const scan = '/scan';

  static const publicRoutes = {splash, onboarding, login, otp, activate, forgotPassword};
}
