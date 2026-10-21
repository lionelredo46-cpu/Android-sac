/// Endpoints REST versionnés de l'API UniParent (voir Swagger : /api/docs).
class ApiEndpoints {
  ApiEndpoints._();

  static const String v = '/api/v1';

  // Authentification
  static const String login = '$v/auth/login';
  static const String otpSend = '$v/auth/otp/send';
  static const String otpVerify = '$v/auth/otp/verify';
  static const String activateStart = '$v/auth/activate/start';
  static const String activate = '$v/auth/activate';
  static const String refresh = '$v/auth/refresh';
  static const String logout = '$v/auth/logout';
  static const String logoutAll = '$v/auth/logout-all';
  static const String forgotPassword = '$v/auth/forgot-password';
  static const String resetPassword = '$v/auth/reset-password';
  static const String changePassword = '$v/auth/change-password';

  // Profil & enfants
  static const String me = '$v/me';
  static const String myChildren = '$v/me/children';
  static const String devices = '$v/me/devices';
  static String child(String id) => '$v/children/$id';
  static String dashboard(String id) => '$v/children/$id/dashboard';

  // Finances
  static String invoices(String childId) => '$v/children/$childId/invoices';
  static String invoice(String id) => '$v/invoices/$id';
  static String payments(String childId) => '$v/children/$childId/payments';
  static String financeSummary(String childId) => '$v/children/$childId/finance/summary';
  static String paymentCertificate(String childId) => '$v/children/$childId/payment-certificate.pdf';
  static const String paymentProviders = '$v/payments/providers';
  static const String initiatePayment = '$v/payments/initiate';
  static String paymentStatus(String id) => '$v/payments/$id/status';
  static String sandboxConfirm(String id) => '$v/payments/$id/sandbox/confirm';
  static String receiptPdf(String id) => '$v/receipts/$id/pdf';
  static const String installmentRequests = '$v/installment-requests';

  // Présences
  static String attendance(String childId) => '$v/children/$childId/attendance';
  static String attendanceStats(String childId) => '$v/children/$childId/attendance/stats';
  static String justify(String attendanceId) => '$v/absences/$attendanceId/justify';
  static const String attendanceScan = '$v/attendance/scan';

  // Notes
  static String grades(String childId) => '$v/children/$childId/grades';
  static String gradesHistory(String childId) => '$v/children/$childId/grades/history';
  static String bulletin(String childId, String semesterId) => '$v/children/$childId/transcripts/$semesterId/pdf';
  static String disputeGrade(String gradeId) => '$v/grades/$gradeId/dispute';
  static String gradeDisputes(String childId) => '$v/children/$childId/grade-disputes';

  // Emploi du temps & calendrier
  static String timetable(String childId) => '$v/children/$childId/timetable';
  static String timetableIcs(String childId) => '$v/children/$childId/timetable.ics';
  static const String calendarEvents = '$v/calendar/events';

  // Messagerie, annonces, rendez-vous
  static const String conversations = '$v/conversations';
  static String conversation(String id) => '$v/conversations/$id';
  static String conversationMessages(String id) => '$v/conversations/$id/messages';
  static String rateConversation(String id) => '$v/conversations/$id/rate';
  static String attachment(String messageId, int index) => '$v/messages/$messageId/attachments/$index';
  static const String announcements = '$v/announcements';
  static const String appointments = '$v/appointments';
  static const String appointmentHosts = '$v/appointments/hosts';
  static String appointment(String id) => '$v/appointments/$id';

  // Documents, démarches, discipline
  static String vault(String childId) => '$v/children/$childId/documents';
  static String uploadDocument(String childId) => '$v/children/$childId/documents/upload';
  static String downloadDocument(String id) => '$v/documents/$id/download';
  static String signDocument(String id) => '$v/documents/$id/sign';
  static String enrollmentCertificate(String childId) => '$v/children/$childId/certificates/enrollment.pdf';
  static String requests(String childId) => '$v/children/$childId/requests';
  static const String createRequest = '$v/requests';
  static String requestDocument(String id) => '$v/requests/$id/document';
  static String discipline(String childId) => '$v/children/$childId/discipline';
  static String acknowledge(String id) => '$v/discipline/$id/acknowledge';

  // Notifications
  static const String notifications = '$v/notifications';
  static const String unreadCount = '$v/notifications/unread-count';
  static String markRead(String id) => '$v/notifications/$id/read';
  static const String readAll = '$v/notifications/read-all';
  static const String notificationPreferences = '$v/notification-preferences';
}
