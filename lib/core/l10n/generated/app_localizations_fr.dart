// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'UniParent AFRAM';

  @override
  String get tagline => 'L\'œil du parent sur la vie universitaire';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get save => 'Enregistrer';

  @override
  String get send => 'Envoyer';

  @override
  String get close => 'Fermer';

  @override
  String get next => 'Suivant';

  @override
  String get back => 'Retour';

  @override
  String get retry => 'Réessayer';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get download => 'Télécharger';

  @override
  String get share => 'Partager';

  @override
  String get loading => 'Chargement…';

  @override
  String get errorTitle => 'Une erreur est survenue';

  @override
  String get emptyTitle => 'Rien pour le moment';

  @override
  String offlineBanner(String date) {
    return 'Hors ligne — données du $date';
  }

  @override
  String get offlineShort => 'Mode hors ligne';

  @override
  String get requiresNetwork =>
      'Cette action nécessite une connexion Internet.';

  @override
  String updatedAt(String date) {
    return 'Mis à jour $date';
  }

  @override
  String get onboardingTitle1 => 'Toute la scolarité en un coup d\'œil';

  @override
  String get onboardingBody1 =>
      'Finances, présences, notes et emploi du temps de votre enfant, en temps réel.';

  @override
  String get onboardingTitle2 => 'Payez en toute sécurité';

  @override
  String get onboardingBody2 =>
      'Mobile Money ou carte bancaire, reçu numérique immédiat, même pour les versements au guichet.';

  @override
  String get onboardingTitle3 => 'Restez informé';

  @override
  String get onboardingBody3 =>
      'Absences, nouvelles notes, annonces : soyez alerté dès qu\'il se passe quelque chose.';

  @override
  String get start => 'Commencer';

  @override
  String get login => 'Se connecter';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginSubtitle => 'Espace parents et étudiants';

  @override
  String get identifier => 'Email ou téléphone';

  @override
  String get identifierHint => 'parent@exemple.com ou +241…';

  @override
  String get password => 'Mot de passe';

  @override
  String get totpCode => 'Code de double authentification';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get firstLogin => 'Première connexion ?';

  @override
  String get activateAccount => 'Activer mon compte';

  @override
  String get loginWithOtp => 'Connexion par SMS';

  @override
  String get loginWithPassword => 'Connexion par mot de passe';

  @override
  String get phone => 'Numéro de téléphone';

  @override
  String get phoneHint => '+241 06 00 00 00';

  @override
  String get sendCode => 'Recevoir un code';

  @override
  String get otpTitle => 'Code de vérification';

  @override
  String otpSentTo(String phone) {
    return 'Saisissez le code à 6 chiffres envoyé au $phone.';
  }

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String resendIn(int seconds) {
    return 'Renvoyer dans $seconds s';
  }

  @override
  String get verify => 'Vérifier';

  @override
  String get biometricUnlock => 'Déverrouiller avec la biométrie';

  @override
  String get biometricReason =>
      'Confirmez votre identité pour accéder à UniParent';

  @override
  String get activationTitle => 'Activation du compte';

  @override
  String get activationCode => 'Code d\'invitation';

  @override
  String get activationCodeHint => 'Reçu par SMS de l\'AFRAM';

  @override
  String activationHello(String name) {
    return 'Bonjour $name !';
  }

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get passwordRules =>
      '8 caractères minimum, avec une majuscule, une minuscule et un chiffre.';

  @override
  String get passwordsDontMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get fieldRequired => 'Champ obligatoire';

  @override
  String get invalidPhone => 'Numéro invalide';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get resetDone => 'Mot de passe modifié. Connectez-vous.';

  @override
  String get sessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get navHome => 'Accueil';

  @override
  String get navFinances => 'Finances';

  @override
  String get navTracking => 'Suivi';

  @override
  String get navMessages => 'Messages';

  @override
  String get navMore => 'Plus';

  @override
  String hello(String name) {
    return 'Bonjour $name';
  }

  @override
  String get selectChild => 'Choisir l\'enfant';

  @override
  String get noChildren => 'Aucun enfant rattaché';

  @override
  String get noChildrenBody =>
      'Le rattachement est effectué par la scolarité de l\'AFRAM. Contactez-la si un enfant manque.';

  @override
  String get financialSituation => 'Situation financière';

  @override
  String get totalDue => 'Total dû';

  @override
  String get totalPaid => 'Payé';

  @override
  String get remaining => 'Reste à payer';

  @override
  String get nextDue => 'Prochaine échéance';

  @override
  String get upToDate => 'À jour';

  @override
  String get overdue => 'En retard';

  @override
  String get toPay => 'À payer';

  @override
  String get attendanceCard => 'Présence';

  @override
  String get attendanceRateMonth => 'Assiduité du mois';

  @override
  String get recentAbsences => 'Dernières absences';

  @override
  String get noAbsence => 'Aucune absence récente';

  @override
  String get resultsCard => 'Résultats';

  @override
  String get generalAverage => 'Moyenne générale';

  @override
  String get latestGrades => 'Dernières notes';

  @override
  String get noGrades => 'Aucune note publiée';

  @override
  String get todayCard => 'Aujourd\'hui';

  @override
  String get noClassToday => 'Pas de cours aujourd\'hui';

  @override
  String get alertsCard => 'Alertes';

  @override
  String get newsCard => 'Actualités';

  @override
  String get quickPay => 'Payer';

  @override
  String get quickWrite => 'Écrire';

  @override
  String get quickDocuments => 'Documents';

  @override
  String get quickTimetable => 'Emploi du temps';

  @override
  String get financesTitle => 'Finances';

  @override
  String get schedule => 'Échéancier';

  @override
  String get history => 'Historique';

  @override
  String get summary => 'Synthèse';

  @override
  String get invoice => 'Facture';

  @override
  String get dueDate => 'Échéance';

  @override
  String get pay => 'Payer';

  @override
  String get payNow => 'Payer maintenant';

  @override
  String get paymentTitle => 'Paiement';

  @override
  String get amountToPay => 'Montant à payer';

  @override
  String get fullAmount => 'Totalité';

  @override
  String get partialAmount => 'Montant partiel';

  @override
  String get paymentMethod => 'Moyen de paiement';

  @override
  String get mobileMoney => 'Mobile Money';

  @override
  String get mobileMoneyHint => 'Airtel Money, Moov Money';

  @override
  String get card => 'Carte bancaire';

  @override
  String get cardHint => 'Visa, Mastercard';

  @override
  String get mobileMoneyNumber => 'Numéro Mobile Money';

  @override
  String confirmPayment(String amount) {
    return 'Confirmer le paiement de $amount';
  }

  @override
  String get paymentPending => 'Paiement en attente de confirmation';

  @override
  String get paymentPendingBody =>
      'Validez la demande sur votre téléphone. Cet écran se met à jour automatiquement.';

  @override
  String get paymentSuccess => 'Paiement confirmé';

  @override
  String get paymentFailed => 'Paiement non abouti';

  @override
  String get paymentFailedBody =>
      'Aucun montant n\'a été débité. Vous pouvez réessayer.';

  @override
  String get openPaymentPage => 'Ouvrir la page de paiement';

  @override
  String get viewReceipt => 'Voir le reçu';

  @override
  String get receipt => 'Reçu';

  @override
  String paidBy(String name) {
    return 'Versé par $name';
  }

  @override
  String get online => 'En ligne';

  @override
  String get counter => 'Guichet';

  @override
  String get allPayments => 'Tous';

  @override
  String get noPayments => 'Aucun versement';

  @override
  String get noInvoices => 'Aucune facture';

  @override
  String get requestInstallment => 'Demander un échelonnement';

  @override
  String get installments => 'Nombre de tranches';

  @override
  String get reason => 'Motif';

  @override
  String get requestSent => 'Demande envoyée';

  @override
  String get paymentCertificate => 'Attestation de paiement';

  @override
  String get balanceByYear => 'Solde par année';

  @override
  String get paymentsEvolution => 'Évolution des versements';

  @override
  String get simulateSuccess => 'Simuler la validation (test)';

  @override
  String get simulateFailure => 'Simuler un échec (test)';

  @override
  String get lineStatus_PAYE => 'Payé';

  @override
  String get lineStatus_PARTIELLEMENT_PAYE => 'Partiellement payé';

  @override
  String get lineStatus_A_PAYER => 'À payer';

  @override
  String get lineStatus_EN_RETARD => 'En retard';

  @override
  String get lineStatus_ANNULE => 'Annulé';

  @override
  String get trackingTitle => 'Suivi';

  @override
  String get attendanceTitle => 'Présences';

  @override
  String get gradesTitle => 'Notes';

  @override
  String get present => 'Présent';

  @override
  String get absent => 'Absent';

  @override
  String get late => 'Retard';

  @override
  String get excused => 'Excusé';

  @override
  String lateMinutes(int minutes) {
    return '$minutes min de retard';
  }

  @override
  String get justify => 'Justifier';

  @override
  String get justified => 'Justifiée';

  @override
  String get justificationPending => 'Justificatif en examen';

  @override
  String get justificationRejected => 'Justificatif refusé';

  @override
  String get justifyTitle => 'Justifier l\'absence';

  @override
  String get attachProof => 'Joindre un justificatif';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get chooseFile => 'Choisir un fichier';

  @override
  String get proofSent => 'Justificatif envoyé à la scolarité';

  @override
  String get globalRate => 'Taux global';

  @override
  String get byCourse => 'Par matière';

  @override
  String get unjustifiedAbsences => 'Absences non justifiées';

  @override
  String get semester => 'Semestre';

  @override
  String get classAverage => 'Moyenne de la classe';

  @override
  String get rank => 'Rang';

  @override
  String get credits => 'Crédits ECTS';

  @override
  String get mention => 'Mention';

  @override
  String get decision => 'Décision';

  @override
  String coefficient(String value) {
    return 'Coef. $value';
  }

  @override
  String get evolution => 'Évolution';

  @override
  String get bulletin => 'Bulletin PDF';

  @override
  String get disputeGrade => 'Contester la note';

  @override
  String get disputeSent => 'Réclamation envoyée à la scolarité';

  @override
  String get timetableTitle => 'Emploi du temps';

  @override
  String get calendarTitle => 'Calendrier académique';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get cancelledClass => 'Annulé';

  @override
  String get postponedClass => 'Reporté';

  @override
  String get exportCalendar => 'Exporter vers mon agenda';

  @override
  String room(String room) {
    return 'Salle $room';
  }

  @override
  String get messagesTitle => 'Messagerie';

  @override
  String get newTicket => 'Nouvelle demande';

  @override
  String get subject => 'Sujet';

  @override
  String get service => 'Service';

  @override
  String get message => 'Message';

  @override
  String get priority => 'Priorité';

  @override
  String get attachment => 'Pièce jointe';

  @override
  String get writeMessage => 'Écrire un message…';

  @override
  String get noConversations => 'Aucune conversation';

  @override
  String get ticketResolved => 'Demande résolue';

  @override
  String get rateService => 'Votre avis sur la réponse';

  @override
  String get readReceipt => 'Lu';

  @override
  String get announcementsTitle => 'Annonces';

  @override
  String get appointmentsTitle => 'Rendez-vous';

  @override
  String get newAppointment => 'Prendre rendez-vous';

  @override
  String get withLabel => 'Avec';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get appointmentRequested => 'Demande de rendez-vous envoyée';

  @override
  String get noAppointments => 'Aucun rendez-vous';

  @override
  String get service_FINANCES => 'Finances';

  @override
  String get service_SCOLARITE => 'Scolarité';

  @override
  String get service_PEDAGOGIE => 'Pédagogie';

  @override
  String get service_DISCIPLINE => 'Discipline';

  @override
  String get service_SUPPORT_TECHNIQUE => 'Support technique';

  @override
  String get status_OUVERT => 'Ouvert';

  @override
  String get status_EN_COURS => 'En cours';

  @override
  String get status_RESOLU => 'Résolu';

  @override
  String get status_CLOTURE => 'Clôturé';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get vault => 'Coffre-fort';

  @override
  String get requests => 'Démarches';

  @override
  String get newRequest => 'Nouvelle demande';

  @override
  String get sign => 'Signer';

  @override
  String get signConfirm =>
      'En signant, vous reconnaissez avoir lu et accepté ce document.';

  @override
  String get signed => 'Signé';

  @override
  String get toSign => 'À signer';

  @override
  String get uploadDocument => 'Déposer une pièce';

  @override
  String get documentTitle => 'Intitulé';

  @override
  String get category => 'Catégorie';

  @override
  String get enrollmentCertificate => 'Attestation d\'inscription';

  @override
  String get noDocuments => 'Aucun document';

  @override
  String get noRequests => 'Aucune démarche';

  @override
  String get documentReady => 'Document prêt';

  @override
  String get disciplineTitle => 'Vie scolaire';

  @override
  String get acknowledge => 'Accuser réception';

  @override
  String get acknowledged => 'Réception confirmée';

  @override
  String convocationOn(String date) {
    return 'Convocation le $date';
  }

  @override
  String get noDiscipline => 'Rien à signaler';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String get notificationPrefs => 'Préférences de notification';

  @override
  String get push => 'Push';

  @override
  String get sms => 'SMS';

  @override
  String get email => 'Email';

  @override
  String get category_FINANCE => 'Finances';

  @override
  String get category_PRESENCE => 'Présences';

  @override
  String get category_NOTES => 'Notes';

  @override
  String get category_EMPLOI_DU_TEMPS => 'Emploi du temps';

  @override
  String get category_MESSAGERIE => 'Messages & annonces';

  @override
  String get category_DISCIPLINE => 'Vie scolaire';

  @override
  String get category_URGENCE => 'Urgences';

  @override
  String get moreTitle => 'Plus';

  @override
  String get profile => 'Mon profil';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get themeSystem => 'Automatique';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get security => 'Sécurité';

  @override
  String get biometrics => 'Connexion biométrique';

  @override
  String get biometricsUnavailable => 'Biométrie indisponible sur cet appareil';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get passwordChanged => 'Mot de passe modifié';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get logoutAll => 'Déconnecter tous mes appareils';

  @override
  String get logoutConfirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get about => 'À propos';

  @override
  String get help => 'Aide & FAQ';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get contactSchool => 'Contacter l\'AFRAM';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get scanQr => 'Scanner le QR de présence';

  @override
  String get scanSuccess => 'Présence enregistrée';

  @override
  String get profession => 'Profession';

  @override
  String get address => 'Adresse';

  @override
  String get emergencyContact => 'Contact d\'urgence';
}
