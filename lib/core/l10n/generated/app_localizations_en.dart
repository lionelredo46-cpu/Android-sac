// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'UniParent AFRAM';

  @override
  String get tagline => 'A parent\'s eye on university life';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get send => 'Send';

  @override
  String get close => 'Close';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Retry';

  @override
  String get seeAll => 'See all';

  @override
  String get download => 'Download';

  @override
  String get share => 'Share';

  @override
  String get loading => 'Loading…';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get emptyTitle => 'Nothing yet';

  @override
  String offlineBanner(String date) {
    return 'Offline — data from $date';
  }

  @override
  String get offlineShort => 'Offline mode';

  @override
  String get requiresNetwork => 'This action requires an Internet connection.';

  @override
  String updatedAt(String date) {
    return 'Updated $date';
  }

  @override
  String get onboardingTitle1 => 'Your child\'s studies at a glance';

  @override
  String get onboardingBody1 =>
      'Fees, attendance, grades and timetable in real time.';

  @override
  String get onboardingTitle2 => 'Pay securely';

  @override
  String get onboardingBody2 =>
      'Mobile Money or card, instant digital receipt — even for payments made at the counter.';

  @override
  String get onboardingTitle3 => 'Stay informed';

  @override
  String get onboardingBody3 =>
      'Absences, new grades, announcements: get notified as soon as something happens.';

  @override
  String get start => 'Get started';

  @override
  String get login => 'Sign in';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Parents and students area';

  @override
  String get identifier => 'Email or phone';

  @override
  String get identifierHint => 'parent@example.com or +241…';

  @override
  String get password => 'Password';

  @override
  String get totpCode => 'Two-factor code';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get firstLogin => 'First time here?';

  @override
  String get activateAccount => 'Activate my account';

  @override
  String get loginWithOtp => 'Sign in with SMS';

  @override
  String get loginWithPassword => 'Sign in with password';

  @override
  String get phone => 'Phone number';

  @override
  String get phoneHint => '+241 06 00 00 00';

  @override
  String get sendCode => 'Get a code';

  @override
  String get otpTitle => 'Verification code';

  @override
  String otpSentTo(String phone) {
    return 'Enter the 6-digit code sent to $phone.';
  }

  @override
  String get resendCode => 'Resend code';

  @override
  String resendIn(int seconds) {
    return 'Resend in $seconds s';
  }

  @override
  String get verify => 'Verify';

  @override
  String get biometricUnlock => 'Unlock with biometrics';

  @override
  String get biometricReason => 'Confirm your identity to open UniParent';

  @override
  String get activationTitle => 'Account activation';

  @override
  String get activationCode => 'Invitation code';

  @override
  String get activationCodeHint => 'Received by SMS from AFRAM';

  @override
  String activationHello(String name) {
    return 'Hello $name!';
  }

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordRules =>
      'At least 8 characters, with an uppercase letter, a lowercase letter and a digit.';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get fieldRequired => 'Required field';

  @override
  String get invalidPhone => 'Invalid number';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetDone => 'Password changed. Please sign in.';

  @override
  String get sessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get navHome => 'Home';

  @override
  String get navFinances => 'Fees';

  @override
  String get navTracking => 'Progress';

  @override
  String get navMessages => 'Messages';

  @override
  String get navMore => 'More';

  @override
  String hello(String name) {
    return 'Hello $name';
  }

  @override
  String get selectChild => 'Choose child';

  @override
  String get noChildren => 'No linked child';

  @override
  String get noChildrenBody =>
      'Children are linked by the AFRAM registrar. Contact them if a child is missing.';

  @override
  String get financialSituation => 'Fees';

  @override
  String get totalDue => 'Total due';

  @override
  String get totalPaid => 'Paid';

  @override
  String get remaining => 'Balance';

  @override
  String get nextDue => 'Next due date';

  @override
  String get upToDate => 'Up to date';

  @override
  String get overdue => 'Overdue';

  @override
  String get toPay => 'To pay';

  @override
  String get attendanceCard => 'Attendance';

  @override
  String get attendanceRateMonth => 'This month\'s attendance';

  @override
  String get recentAbsences => 'Recent absences';

  @override
  String get noAbsence => 'No recent absence';

  @override
  String get resultsCard => 'Results';

  @override
  String get generalAverage => 'Overall average';

  @override
  String get latestGrades => 'Latest grades';

  @override
  String get noGrades => 'No published grade';

  @override
  String get todayCard => 'Today';

  @override
  String get noClassToday => 'No class today';

  @override
  String get alertsCard => 'Alerts';

  @override
  String get newsCard => 'News';

  @override
  String get quickPay => 'Pay';

  @override
  String get quickWrite => 'Write';

  @override
  String get quickDocuments => 'Documents';

  @override
  String get quickTimetable => 'Timetable';

  @override
  String get financesTitle => 'Fees';

  @override
  String get schedule => 'Schedule';

  @override
  String get history => 'History';

  @override
  String get summary => 'Overview';

  @override
  String get invoice => 'Invoice';

  @override
  String get dueDate => 'Due date';

  @override
  String get pay => 'Pay';

  @override
  String get payNow => 'Pay now';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get amountToPay => 'Amount to pay';

  @override
  String get fullAmount => 'Full amount';

  @override
  String get partialAmount => 'Partial amount';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get mobileMoney => 'Mobile Money';

  @override
  String get mobileMoneyHint => 'Airtel Money, Moov Money';

  @override
  String get card => 'Bank card';

  @override
  String get cardHint => 'Visa, Mastercard';

  @override
  String get mobileMoneyNumber => 'Mobile Money number';

  @override
  String confirmPayment(String amount) {
    return 'Confirm payment of $amount';
  }

  @override
  String get paymentPending => 'Waiting for payment confirmation';

  @override
  String get paymentPendingBody =>
      'Approve the request on your phone. This screen updates automatically.';

  @override
  String get paymentSuccess => 'Payment confirmed';

  @override
  String get paymentFailed => 'Payment not completed';

  @override
  String get paymentFailedBody => 'Nothing was charged. You can try again.';

  @override
  String get openPaymentPage => 'Open payment page';

  @override
  String get viewReceipt => 'View receipt';

  @override
  String get receipt => 'Receipt';

  @override
  String paidBy(String name) {
    return 'Paid by $name';
  }

  @override
  String get online => 'Online';

  @override
  String get counter => 'Counter';

  @override
  String get allPayments => 'All';

  @override
  String get noPayments => 'No payment';

  @override
  String get noInvoices => 'No invoice';

  @override
  String get requestInstallment => 'Request a payment plan';

  @override
  String get installments => 'Number of instalments';

  @override
  String get reason => 'Reason';

  @override
  String get requestSent => 'Request sent';

  @override
  String get paymentCertificate => 'Payment certificate';

  @override
  String get balanceByYear => 'Balance per year';

  @override
  String get paymentsEvolution => 'Payments over time';

  @override
  String get simulateSuccess => 'Simulate approval (test)';

  @override
  String get simulateFailure => 'Simulate failure (test)';

  @override
  String get lineStatus_PAYE => 'Paid';

  @override
  String get lineStatus_PARTIELLEMENT_PAYE => 'Partially paid';

  @override
  String get lineStatus_A_PAYER => 'To pay';

  @override
  String get lineStatus_EN_RETARD => 'Overdue';

  @override
  String get lineStatus_ANNULE => 'Cancelled';

  @override
  String get trackingTitle => 'Progress';

  @override
  String get attendanceTitle => 'Attendance';

  @override
  String get gradesTitle => 'Grades';

  @override
  String get present => 'Present';

  @override
  String get absent => 'Absent';

  @override
  String get late => 'Late';

  @override
  String get excused => 'Excused';

  @override
  String lateMinutes(int minutes) {
    return '$minutes min late';
  }

  @override
  String get justify => 'Justify';

  @override
  String get justified => 'Justified';

  @override
  String get justificationPending => 'Justification under review';

  @override
  String get justificationRejected => 'Justification rejected';

  @override
  String get justifyTitle => 'Justify absence';

  @override
  String get attachProof => 'Attach proof';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFile => 'Choose a file';

  @override
  String get proofSent => 'Proof sent to the registrar';

  @override
  String get globalRate => 'Overall rate';

  @override
  String get byCourse => 'By course';

  @override
  String get unjustifiedAbsences => 'Unjustified absences';

  @override
  String get semester => 'Semester';

  @override
  String get classAverage => 'Class average';

  @override
  String get rank => 'Rank';

  @override
  String get credits => 'ECTS credits';

  @override
  String get mention => 'Honours';

  @override
  String get decision => 'Decision';

  @override
  String coefficient(String value) {
    return 'Weight $value';
  }

  @override
  String get evolution => 'Progress';

  @override
  String get bulletin => 'Report card PDF';

  @override
  String get disputeGrade => 'Dispute grade';

  @override
  String get disputeSent => 'Dispute sent to the registrar';

  @override
  String get timetableTitle => 'Timetable';

  @override
  String get calendarTitle => 'Academic calendar';

  @override
  String get thisWeek => 'This week';

  @override
  String get cancelledClass => 'Cancelled';

  @override
  String get postponedClass => 'Postponed';

  @override
  String get exportCalendar => 'Export to my calendar';

  @override
  String room(String room) {
    return 'Room $room';
  }

  @override
  String get messagesTitle => 'Messages';

  @override
  String get newTicket => 'New request';

  @override
  String get subject => 'Subject';

  @override
  String get service => 'Department';

  @override
  String get message => 'Message';

  @override
  String get priority => 'Priority';

  @override
  String get attachment => 'Attachment';

  @override
  String get writeMessage => 'Write a message…';

  @override
  String get noConversations => 'No conversation';

  @override
  String get ticketResolved => 'Request resolved';

  @override
  String get rateService => 'Rate the answer';

  @override
  String get readReceipt => 'Read';

  @override
  String get announcementsTitle => 'Announcements';

  @override
  String get appointmentsTitle => 'Appointments';

  @override
  String get newAppointment => 'Book an appointment';

  @override
  String get withLabel => 'With';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get appointmentRequested => 'Appointment request sent';

  @override
  String get noAppointments => 'No appointment';

  @override
  String get service_FINANCES => 'Finance';

  @override
  String get service_SCOLARITE => 'Registrar';

  @override
  String get service_PEDAGOGIE => 'Academics';

  @override
  String get service_DISCIPLINE => 'Discipline';

  @override
  String get service_SUPPORT_TECHNIQUE => 'Technical support';

  @override
  String get status_OUVERT => 'Open';

  @override
  String get status_EN_COURS => 'In progress';

  @override
  String get status_RESOLU => 'Resolved';

  @override
  String get status_CLOTURE => 'Closed';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get vault => 'Vault';

  @override
  String get requests => 'Requests';

  @override
  String get newRequest => 'New request';

  @override
  String get sign => 'Sign';

  @override
  String get signConfirm =>
      'By signing, you confirm you have read and accept this document.';

  @override
  String get signed => 'Signed';

  @override
  String get toSign => 'To sign';

  @override
  String get uploadDocument => 'Upload a document';

  @override
  String get documentTitle => 'Title';

  @override
  String get category => 'Category';

  @override
  String get enrollmentCertificate => 'Enrolment certificate';

  @override
  String get noDocuments => 'No document';

  @override
  String get noRequests => 'No request';

  @override
  String get documentReady => 'Document ready';

  @override
  String get disciplineTitle => 'Student life';

  @override
  String get acknowledge => 'Acknowledge';

  @override
  String get acknowledged => 'Receipt confirmed';

  @override
  String convocationOn(String date) {
    return 'Meeting on $date';
  }

  @override
  String get noDiscipline => 'Nothing to report';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get noNotifications => 'No notification';

  @override
  String get notificationPrefs => 'Notification preferences';

  @override
  String get push => 'Push';

  @override
  String get sms => 'SMS';

  @override
  String get email => 'Email';

  @override
  String get category_FINANCE => 'Fees';

  @override
  String get category_PRESENCE => 'Attendance';

  @override
  String get category_NOTES => 'Grades';

  @override
  String get category_EMPLOI_DU_TEMPS => 'Timetable';

  @override
  String get category_MESSAGERIE => 'Messages & announcements';

  @override
  String get category_DISCIPLINE => 'Student life';

  @override
  String get category_URGENCE => 'Emergencies';

  @override
  String get moreTitle => 'More';

  @override
  String get profile => 'My profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'Automatic';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get security => 'Security';

  @override
  String get biometrics => 'Biometric sign-in';

  @override
  String get biometricsUnavailable => 'Biometrics unavailable on this device';

  @override
  String get changePassword => 'Change password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get passwordChanged => 'Password changed';

  @override
  String get logout => 'Sign out';

  @override
  String get logoutAll => 'Sign out of all my devices';

  @override
  String get logoutConfirm => 'Do you really want to sign out?';

  @override
  String get about => 'About';

  @override
  String get help => 'Help & FAQ';

  @override
  String get privacy => 'Privacy';

  @override
  String get contactSchool => 'Contact AFRAM';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get scanQr => 'Scan attendance QR code';

  @override
  String get scanSuccess => 'Attendance recorded';

  @override
  String get profession => 'Occupation';

  @override
  String get address => 'Address';

  @override
  String get emergencyContact => 'Emergency contact';

  @override
  String get ttToday => 'Today';

  @override
  String get ttLiveNow => 'LIVE NOW';

  @override
  String get ttNow => 'Now';

  @override
  String get ttViewDay => 'Day';

  @override
  String get ttViewWeek => 'Week';

  @override
  String get ttNfc => 'NFC';

  @override
  String get ttExport => 'Export';

  @override
  String get ttPrevWeek => 'Previous week';

  @override
  String get ttNextWeek => 'Next week';

  @override
  String get ttNoClassDay => 'No class this day';

  @override
  String get ttNoClassDayBody =>
      'A good time to revise or move your projects forward.';

  @override
  String get ttNoClassWeek => 'No class this week';

  @override
  String ttClassesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count classes',
      one: '1 class',
      zero: 'No class',
    );
    return '$_temp0';
  }

  @override
  String get ttPresent => 'Present';

  @override
  String get ttAbsent => 'Absent';

  @override
  String get ttLate => 'Late';

  @override
  String get ttExcused => 'Excused';

  @override
  String get ttTeacher => 'Teacher';

  @override
  String get ttRoomLabel => 'Room';

  @override
  String get ttCampus => 'Campus';

  @override
  String get ttDuration => 'Duration';

  @override
  String ttMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get ttAttendanceLabel => 'Roll call';

  @override
  String get ttAttendancePending => 'Roll call has not taken place yet';

  @override
  String get ttSlotDetail => 'Class details';

  @override
  String get ttSelectSlotHint => 'Select a class to see its details.';

  @override
  String get ttExportPreview => 'Export preview';

  @override
  String get ttAddToCalendar => 'Add to my calendar';

  @override
  String get ttCheckRoom => 'Check my room';

  @override
  String get ttShowPanel => 'Show panel';

  @override
  String get ttHidePanel => 'Hide panel';

  @override
  String get ttExportTitle => 'Export the week';

  @override
  String ttExportSubtitle(String range) {
    return 'Week of $range';
  }

  @override
  String get ttPdfTitle => 'Editorial PDF';

  @override
  String get ttPdfBody =>
      'Vector A4, colour per subject, authenticity QR code.';

  @override
  String get ttLandscape => 'Landscape';

  @override
  String get ttPortrait => 'Portrait';

  @override
  String get ttPreviewPdf => 'Preview, print and share';

  @override
  String get ttIcsTitle => 'Calendar (.ics)';

  @override
  String ttIcsBody(int minutes) {
    return 'Google Calendar, Apple Calendar or Outlook, with a reminder $minutes min before each class.';
  }

  @override
  String get ttIcsAction => 'Open in calendar';

  @override
  String get ttImageTitle => 'Shareable image';

  @override
  String get ttImageBody =>
      'Story or pocket card format, for WhatsApp, SMS or chat.';

  @override
  String get ttStory => 'Story 9:16';

  @override
  String get ttSquare => 'Card 1:1';

  @override
  String get ttShareImage => 'Share image';

  @override
  String ttCalendarName(String name) {
    return 'AFRAM — $name';
  }

  @override
  String get ttPdfDocTitle => 'Timetable';

  @override
  String get ttPdfStudent => 'Student:';

  @override
  String get ttPdfMatricule => 'Student ID';

  @override
  String get ttPdfGroup => 'Group';

  @override
  String get ttPdfGenerated => 'Generated on';

  @override
  String get ttPdfAuthentic => 'Authentic document';

  @override
  String get ttPdfVerifyHint => 'Scan the QR code to verify this schedule.';

  @override
  String get ttPdfTime => 'Time';

  @override
  String get ttPdfCourse => 'Class';

  @override
  String get ttPdfStatus => 'Status';

  @override
  String get ttPdfPage => 'Page';

  @override
  String get ttReminder => 'Reminder';

  @override
  String get ttStoryTitle => 'My week';

  @override
  String ttStoryMore(int count) {
    return '+$count more classes';
  }

  @override
  String get ttStoryFooter => 'Made with UniParent AFRAM';

  @override
  String get ttNfcTitle => 'NFC hub';

  @override
  String get ttNfcSync => 'Tap-to-Sync';

  @override
  String get ttNfcRoom => 'My room';

  @override
  String get ttNfcAttendance => 'Check-in';

  @override
  String get ttNfcCard => 'Student card';

  @override
  String get ttNfcSyncHint =>
      'Hold two phones back to back to swap this week\'s timetable, no network needed.';

  @override
  String get ttNfcRoomHint =>
      'Hold your phone near the NFC tag at the room or lecture hall entrance.';

  @override
  String get ttNfcAttendanceHint =>
      'Hold your phone near the check-in terminal or badge.';

  @override
  String get ttNfcCardHint =>
      'Hold a student card near the phone (MIFARE, DESFire or NFC).';

  @override
  String get ttNfcScan => 'Start scanning';

  @override
  String get ttNfcScanning => 'Searching…';

  @override
  String get ttNfcReceive => 'Receive';

  @override
  String get ttNfcShare => 'Share my week';

  @override
  String get ttNfcSharing =>
      'Ready: bring the other phone close, screen on and unlocked.';

  @override
  String get ttNfcStopSharing => 'Stop sharing';

  @override
  String get ttNfcShareUnavailable =>
      'Sending over NFC is not available on this device: you can only receive.';

  @override
  String get ttNfcSimulate => 'Simulate a tag (demo)';

  @override
  String get ttNfcUnavailable => 'This device has no NFC chip.';

  @override
  String get ttNfcDisabled => 'NFC is turned off: enable it in settings.';

  @override
  String get ttNfcIosPrompt => 'Hold your iPhone near the NFC tag';

  @override
  String get ttNfcIosSuccess => 'Read successfully';

  @override
  String get ttNfcTimeout => 'No tag detected. Try again.';

  @override
  String get ttNfcCancelled => 'Scan cancelled.';

  @override
  String get ttNfcUnreadable => 'Unreadable tag or unknown format.';

  @override
  String get ttNfcRetry => 'Scan again';

  @override
  String get ttRoomYes => 'Yes, this is your room';

  @override
  String get ttRoomNo => 'This is not your room';

  @override
  String ttRoomExpected(String course, String room, String campus) {
    return '“$course” takes place in $room ($campus).';
  }

  @override
  String get ttRoomNoCourse => 'No more classes scheduled for you today.';

  @override
  String ttRoomToday(String room) {
    return 'Your classes in $room today';
  }

  @override
  String get ttRoomNone =>
      'None of your classes takes place in this room today.';

  @override
  String get ttAttendanceOk => 'Check-in confirmed';

  @override
  String ttAttendanceLate(int minutes) {
    return '$minutes min late recorded';
  }

  @override
  String ttCardLinked(String name) {
    return '$name\'s card';
  }

  @override
  String get ttCardOpen => 'Open their timetable';

  @override
  String get ttCardUnknown => 'Card not linked';

  @override
  String get ttCardLinkHint =>
      'Link this card to a student: it will then open their timetable in one tap.';

  @override
  String ttCardLinkTo(String name) {
    return 'Link to $name';
  }

  @override
  String ttCardUid(String uid, String technology) {
    return 'ID $uid · $technology';
  }

  @override
  String ttShareReceived(String name) {
    return '$name\'s timetable received';
  }

  @override
  String get ttShareView => 'View';

  @override
  String get ttSharedTitle => 'Shared timetable';

  @override
  String ttSharedBy(String name, String date) {
    return 'Shared by $name on $date';
  }

  @override
  String get ttNfcTooLarge => 'This week is too large to share over NFC.';

  @override
  String get ttIcsScopeWeek => 'This week';

  @override
  String get ttIcsScopeTerm => '8 weeks';
}
