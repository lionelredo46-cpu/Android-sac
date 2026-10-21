import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'UniParent AFRAM'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In fr, this message translates to:
  /// **'L\'œil du parent sur la vie universitaire'**
  String get tagline;

  /// No description provided for @ok.
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @send.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get send;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @next.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get next;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @seeAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout voir'**
  String get seeAll;

  /// No description provided for @download.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger'**
  String get download;

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get loading;

  /// No description provided for @errorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get errorTitle;

  /// No description provided for @emptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rien pour le moment'**
  String get emptyTitle;

  /// No description provided for @offlineBanner.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne — données du {date}'**
  String offlineBanner(String date);

  /// No description provided for @offlineShort.
  ///
  /// In fr, this message translates to:
  /// **'Mode hors ligne'**
  String get offlineShort;

  /// No description provided for @requiresNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Cette action nécessite une connexion Internet.'**
  String get requiresNetwork;

  /// No description provided for @updatedAt.
  ///
  /// In fr, this message translates to:
  /// **'Mis à jour {date}'**
  String updatedAt(String date);

  /// No description provided for @onboardingTitle1.
  ///
  /// In fr, this message translates to:
  /// **'Toute la scolarité en un coup d\'œil'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In fr, this message translates to:
  /// **'Finances, présences, notes et emploi du temps de votre enfant, en temps réel.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In fr, this message translates to:
  /// **'Payez en toute sécurité'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In fr, this message translates to:
  /// **'Mobile Money ou carte bancaire, reçu numérique immédiat, même pour les versements au guichet.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In fr, this message translates to:
  /// **'Restez informé'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In fr, this message translates to:
  /// **'Absences, nouvelles notes, annonces : soyez alerté dès qu\'il se passe quelque chose.'**
  String get onboardingBody3;

  /// No description provided for @start.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get start;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get login;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Espace parents et étudiants'**
  String get loginSubtitle;

  /// No description provided for @identifier.
  ///
  /// In fr, this message translates to:
  /// **'Email ou téléphone'**
  String get identifier;

  /// No description provided for @identifierHint.
  ///
  /// In fr, this message translates to:
  /// **'parent@exemple.com ou +241…'**
  String get identifierHint;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @totpCode.
  ///
  /// In fr, this message translates to:
  /// **'Code de double authentification'**
  String get totpCode;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @firstLogin.
  ///
  /// In fr, this message translates to:
  /// **'Première connexion ?'**
  String get firstLogin;

  /// No description provided for @activateAccount.
  ///
  /// In fr, this message translates to:
  /// **'Activer mon compte'**
  String get activateAccount;

  /// No description provided for @loginWithOtp.
  ///
  /// In fr, this message translates to:
  /// **'Connexion par SMS'**
  String get loginWithOtp;

  /// No description provided for @loginWithPassword.
  ///
  /// In fr, this message translates to:
  /// **'Connexion par mot de passe'**
  String get loginWithPassword;

  /// No description provided for @phone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone'**
  String get phone;

  /// No description provided for @phoneHint.
  ///
  /// In fr, this message translates to:
  /// **'+241 06 00 00 00'**
  String get phoneHint;

  /// No description provided for @sendCode.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir un code'**
  String get sendCode;

  /// No description provided for @otpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Code de vérification'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le code à 6 chiffres envoyé au {phone}.'**
  String otpSentTo(String phone);

  /// No description provided for @resendCode.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code'**
  String get resendCode;

  /// No description provided for @resendIn.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer dans {seconds} s'**
  String resendIn(int seconds);

  /// No description provided for @verify.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier'**
  String get verify;

  /// No description provided for @biometricUnlock.
  ///
  /// In fr, this message translates to:
  /// **'Déverrouiller avec la biométrie'**
  String get biometricUnlock;

  /// No description provided for @biometricReason.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez votre identité pour accéder à UniParent'**
  String get biometricReason;

  /// No description provided for @activationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Activation du compte'**
  String get activationTitle;

  /// No description provided for @activationCode.
  ///
  /// In fr, this message translates to:
  /// **'Code d\'invitation'**
  String get activationCode;

  /// No description provided for @activationCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'Reçu par SMS de l\'AFRAM'**
  String get activationCodeHint;

  /// No description provided for @activationHello.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {name} !'**
  String activationHello(String name);

  /// No description provided for @newPassword.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmPassword;

  /// No description provided for @passwordRules.
  ///
  /// In fr, this message translates to:
  /// **'8 caractères minimum, avec une majuscule, une minuscule et un chiffre.'**
  String get passwordRules;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get passwordsDontMatch;

  /// No description provided for @fieldRequired.
  ///
  /// In fr, this message translates to:
  /// **'Champ obligatoire'**
  String get fieldRequired;

  /// No description provided for @invalidPhone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro invalide'**
  String get invalidPhone;

  /// No description provided for @resetPassword.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le mot de passe'**
  String get resetPassword;

  /// No description provided for @resetDone.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe modifié. Connectez-vous.'**
  String get resetDone;

  /// No description provided for @sessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Votre session a expiré. Veuillez vous reconnecter.'**
  String get sessionExpired;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navFinances.
  ///
  /// In fr, this message translates to:
  /// **'Finances'**
  String get navFinances;

  /// No description provided for @navTracking.
  ///
  /// In fr, this message translates to:
  /// **'Suivi'**
  String get navTracking;

  /// No description provided for @navMessages.
  ///
  /// In fr, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navMore.
  ///
  /// In fr, this message translates to:
  /// **'Plus'**
  String get navMore;

  /// No description provided for @hello.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {name}'**
  String hello(String name);

  /// No description provided for @selectChild.
  ///
  /// In fr, this message translates to:
  /// **'Choisir l\'enfant'**
  String get selectChild;

  /// No description provided for @noChildren.
  ///
  /// In fr, this message translates to:
  /// **'Aucun enfant rattaché'**
  String get noChildren;

  /// No description provided for @noChildrenBody.
  ///
  /// In fr, this message translates to:
  /// **'Le rattachement est effectué par la scolarité de l\'AFRAM. Contactez-la si un enfant manque.'**
  String get noChildrenBody;

  /// No description provided for @financialSituation.
  ///
  /// In fr, this message translates to:
  /// **'Situation financière'**
  String get financialSituation;

  /// No description provided for @totalDue.
  ///
  /// In fr, this message translates to:
  /// **'Total dû'**
  String get totalDue;

  /// No description provided for @totalPaid.
  ///
  /// In fr, this message translates to:
  /// **'Payé'**
  String get totalPaid;

  /// No description provided for @remaining.
  ///
  /// In fr, this message translates to:
  /// **'Reste à payer'**
  String get remaining;

  /// No description provided for @nextDue.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine échéance'**
  String get nextDue;

  /// No description provided for @upToDate.
  ///
  /// In fr, this message translates to:
  /// **'À jour'**
  String get upToDate;

  /// No description provided for @overdue.
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get overdue;

  /// No description provided for @toPay.
  ///
  /// In fr, this message translates to:
  /// **'À payer'**
  String get toPay;

  /// No description provided for @attendanceCard.
  ///
  /// In fr, this message translates to:
  /// **'Présence'**
  String get attendanceCard;

  /// No description provided for @attendanceRateMonth.
  ///
  /// In fr, this message translates to:
  /// **'Assiduité du mois'**
  String get attendanceRateMonth;

  /// No description provided for @recentAbsences.
  ///
  /// In fr, this message translates to:
  /// **'Dernières absences'**
  String get recentAbsences;

  /// No description provided for @noAbsence.
  ///
  /// In fr, this message translates to:
  /// **'Aucune absence récente'**
  String get noAbsence;

  /// No description provided for @resultsCard.
  ///
  /// In fr, this message translates to:
  /// **'Résultats'**
  String get resultsCard;

  /// No description provided for @generalAverage.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne générale'**
  String get generalAverage;

  /// No description provided for @latestGrades.
  ///
  /// In fr, this message translates to:
  /// **'Dernières notes'**
  String get latestGrades;

  /// No description provided for @noGrades.
  ///
  /// In fr, this message translates to:
  /// **'Aucune note publiée'**
  String get noGrades;

  /// No description provided for @todayCard.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get todayCard;

  /// No description provided for @noClassToday.
  ///
  /// In fr, this message translates to:
  /// **'Pas de cours aujourd\'hui'**
  String get noClassToday;

  /// No description provided for @alertsCard.
  ///
  /// In fr, this message translates to:
  /// **'Alertes'**
  String get alertsCard;

  /// No description provided for @newsCard.
  ///
  /// In fr, this message translates to:
  /// **'Actualités'**
  String get newsCard;

  /// No description provided for @quickPay.
  ///
  /// In fr, this message translates to:
  /// **'Payer'**
  String get quickPay;

  /// No description provided for @quickWrite.
  ///
  /// In fr, this message translates to:
  /// **'Écrire'**
  String get quickWrite;

  /// No description provided for @quickDocuments.
  ///
  /// In fr, this message translates to:
  /// **'Documents'**
  String get quickDocuments;

  /// No description provided for @quickTimetable.
  ///
  /// In fr, this message translates to:
  /// **'Emploi du temps'**
  String get quickTimetable;

  /// No description provided for @financesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Finances'**
  String get financesTitle;

  /// No description provided for @schedule.
  ///
  /// In fr, this message translates to:
  /// **'Échéancier'**
  String get schedule;

  /// No description provided for @history.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get history;

  /// No description provided for @summary.
  ///
  /// In fr, this message translates to:
  /// **'Synthèse'**
  String get summary;

  /// No description provided for @invoice.
  ///
  /// In fr, this message translates to:
  /// **'Facture'**
  String get invoice;

  /// No description provided for @dueDate.
  ///
  /// In fr, this message translates to:
  /// **'Échéance'**
  String get dueDate;

  /// No description provided for @pay.
  ///
  /// In fr, this message translates to:
  /// **'Payer'**
  String get pay;

  /// No description provided for @payNow.
  ///
  /// In fr, this message translates to:
  /// **'Payer maintenant'**
  String get payNow;

  /// No description provided for @paymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get paymentTitle;

  /// No description provided for @amountToPay.
  ///
  /// In fr, this message translates to:
  /// **'Montant à payer'**
  String get amountToPay;

  /// No description provided for @fullAmount.
  ///
  /// In fr, this message translates to:
  /// **'Totalité'**
  String get fullAmount;

  /// No description provided for @partialAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant partiel'**
  String get partialAmount;

  /// No description provided for @paymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Moyen de paiement'**
  String get paymentMethod;

  /// No description provided for @mobileMoney.
  ///
  /// In fr, this message translates to:
  /// **'Mobile Money'**
  String get mobileMoney;

  /// No description provided for @mobileMoneyHint.
  ///
  /// In fr, this message translates to:
  /// **'Airtel Money, Moov Money'**
  String get mobileMoneyHint;

  /// No description provided for @card.
  ///
  /// In fr, this message translates to:
  /// **'Carte bancaire'**
  String get card;

  /// No description provided for @cardHint.
  ///
  /// In fr, this message translates to:
  /// **'Visa, Mastercard'**
  String get cardHint;

  /// No description provided for @mobileMoneyNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro Mobile Money'**
  String get mobileMoneyNumber;

  /// No description provided for @confirmPayment.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le paiement de {amount}'**
  String confirmPayment(String amount);

  /// No description provided for @paymentPending.
  ///
  /// In fr, this message translates to:
  /// **'Paiement en attente de confirmation'**
  String get paymentPending;

  /// No description provided for @paymentPendingBody.
  ///
  /// In fr, this message translates to:
  /// **'Validez la demande sur votre téléphone. Cet écran se met à jour automatiquement.'**
  String get paymentPendingBody;

  /// No description provided for @paymentSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Paiement confirmé'**
  String get paymentSuccess;

  /// No description provided for @paymentFailed.
  ///
  /// In fr, this message translates to:
  /// **'Paiement non abouti'**
  String get paymentFailed;

  /// No description provided for @paymentFailedBody.
  ///
  /// In fr, this message translates to:
  /// **'Aucun montant n\'a été débité. Vous pouvez réessayer.'**
  String get paymentFailedBody;

  /// No description provided for @openPaymentPage.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir la page de paiement'**
  String get openPaymentPage;

  /// No description provided for @viewReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Voir le reçu'**
  String get viewReceipt;

  /// No description provided for @receipt.
  ///
  /// In fr, this message translates to:
  /// **'Reçu'**
  String get receipt;

  /// No description provided for @paidBy.
  ///
  /// In fr, this message translates to:
  /// **'Versé par {name}'**
  String paidBy(String name);

  /// No description provided for @online.
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get online;

  /// No description provided for @counter.
  ///
  /// In fr, this message translates to:
  /// **'Guichet'**
  String get counter;

  /// No description provided for @allPayments.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get allPayments;

  /// No description provided for @noPayments.
  ///
  /// In fr, this message translates to:
  /// **'Aucun versement'**
  String get noPayments;

  /// No description provided for @noInvoices.
  ///
  /// In fr, this message translates to:
  /// **'Aucune facture'**
  String get noInvoices;

  /// No description provided for @requestInstallment.
  ///
  /// In fr, this message translates to:
  /// **'Demander un échelonnement'**
  String get requestInstallment;

  /// No description provided for @installments.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de tranches'**
  String get installments;

  /// No description provided for @reason.
  ///
  /// In fr, this message translates to:
  /// **'Motif'**
  String get reason;

  /// No description provided for @requestSent.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée'**
  String get requestSent;

  /// No description provided for @paymentCertificate.
  ///
  /// In fr, this message translates to:
  /// **'Attestation de paiement'**
  String get paymentCertificate;

  /// No description provided for @balanceByYear.
  ///
  /// In fr, this message translates to:
  /// **'Solde par année'**
  String get balanceByYear;

  /// No description provided for @paymentsEvolution.
  ///
  /// In fr, this message translates to:
  /// **'Évolution des versements'**
  String get paymentsEvolution;

  /// No description provided for @simulateSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Simuler la validation (test)'**
  String get simulateSuccess;

  /// No description provided for @simulateFailure.
  ///
  /// In fr, this message translates to:
  /// **'Simuler un échec (test)'**
  String get simulateFailure;

  /// No description provided for @lineStatus_PAYE.
  ///
  /// In fr, this message translates to:
  /// **'Payé'**
  String get lineStatus_PAYE;

  /// No description provided for @lineStatus_PARTIELLEMENT_PAYE.
  ///
  /// In fr, this message translates to:
  /// **'Partiellement payé'**
  String get lineStatus_PARTIELLEMENT_PAYE;

  /// No description provided for @lineStatus_A_PAYER.
  ///
  /// In fr, this message translates to:
  /// **'À payer'**
  String get lineStatus_A_PAYER;

  /// No description provided for @lineStatus_EN_RETARD.
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get lineStatus_EN_RETARD;

  /// No description provided for @lineStatus_ANNULE.
  ///
  /// In fr, this message translates to:
  /// **'Annulé'**
  String get lineStatus_ANNULE;

  /// No description provided for @trackingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Suivi'**
  String get trackingTitle;

  /// No description provided for @attendanceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Présences'**
  String get attendanceTitle;

  /// No description provided for @gradesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get gradesTitle;

  /// No description provided for @present.
  ///
  /// In fr, this message translates to:
  /// **'Présent'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In fr, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @late.
  ///
  /// In fr, this message translates to:
  /// **'Retard'**
  String get late;

  /// No description provided for @excused.
  ///
  /// In fr, this message translates to:
  /// **'Excusé'**
  String get excused;

  /// No description provided for @lateMinutes.
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min de retard'**
  String lateMinutes(int minutes);

  /// No description provided for @justify.
  ///
  /// In fr, this message translates to:
  /// **'Justifier'**
  String get justify;

  /// No description provided for @justified.
  ///
  /// In fr, this message translates to:
  /// **'Justifiée'**
  String get justified;

  /// No description provided for @justificationPending.
  ///
  /// In fr, this message translates to:
  /// **'Justificatif en examen'**
  String get justificationPending;

  /// No description provided for @justificationRejected.
  ///
  /// In fr, this message translates to:
  /// **'Justificatif refusé'**
  String get justificationRejected;

  /// No description provided for @justifyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Justifier l\'absence'**
  String get justifyTitle;

  /// No description provided for @attachProof.
  ///
  /// In fr, this message translates to:
  /// **'Joindre un justificatif'**
  String get attachProof;

  /// No description provided for @takePhoto.
  ///
  /// In fr, this message translates to:
  /// **'Prendre une photo'**
  String get takePhoto;

  /// No description provided for @chooseFile.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un fichier'**
  String get chooseFile;

  /// No description provided for @proofSent.
  ///
  /// In fr, this message translates to:
  /// **'Justificatif envoyé à la scolarité'**
  String get proofSent;

  /// No description provided for @globalRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux global'**
  String get globalRate;

  /// No description provided for @byCourse.
  ///
  /// In fr, this message translates to:
  /// **'Par matière'**
  String get byCourse;

  /// No description provided for @unjustifiedAbsences.
  ///
  /// In fr, this message translates to:
  /// **'Absences non justifiées'**
  String get unjustifiedAbsences;

  /// No description provided for @semester.
  ///
  /// In fr, this message translates to:
  /// **'Semestre'**
  String get semester;

  /// No description provided for @classAverage.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne de la classe'**
  String get classAverage;

  /// No description provided for @rank.
  ///
  /// In fr, this message translates to:
  /// **'Rang'**
  String get rank;

  /// No description provided for @credits.
  ///
  /// In fr, this message translates to:
  /// **'Crédits ECTS'**
  String get credits;

  /// No description provided for @mention.
  ///
  /// In fr, this message translates to:
  /// **'Mention'**
  String get mention;

  /// No description provided for @decision.
  ///
  /// In fr, this message translates to:
  /// **'Décision'**
  String get decision;

  /// No description provided for @coefficient.
  ///
  /// In fr, this message translates to:
  /// **'Coef. {value}'**
  String coefficient(String value);

  /// No description provided for @evolution.
  ///
  /// In fr, this message translates to:
  /// **'Évolution'**
  String get evolution;

  /// No description provided for @bulletin.
  ///
  /// In fr, this message translates to:
  /// **'Bulletin PDF'**
  String get bulletin;

  /// No description provided for @disputeGrade.
  ///
  /// In fr, this message translates to:
  /// **'Contester la note'**
  String get disputeGrade;

  /// No description provided for @disputeSent.
  ///
  /// In fr, this message translates to:
  /// **'Réclamation envoyée à la scolarité'**
  String get disputeSent;

  /// No description provided for @timetableTitle.
  ///
  /// In fr, this message translates to:
  /// **'Emploi du temps'**
  String get timetableTitle;

  /// No description provided for @calendarTitle.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier académique'**
  String get calendarTitle;

  /// No description provided for @thisWeek.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get thisWeek;

  /// No description provided for @cancelledClass.
  ///
  /// In fr, this message translates to:
  /// **'Annulé'**
  String get cancelledClass;

  /// No description provided for @postponedClass.
  ///
  /// In fr, this message translates to:
  /// **'Reporté'**
  String get postponedClass;

  /// No description provided for @exportCalendar.
  ///
  /// In fr, this message translates to:
  /// **'Exporter vers mon agenda'**
  String get exportCalendar;

  /// No description provided for @room.
  ///
  /// In fr, this message translates to:
  /// **'Salle {room}'**
  String room(String room);

  /// No description provided for @messagesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Messagerie'**
  String get messagesTitle;

  /// No description provided for @newTicket.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle demande'**
  String get newTicket;

  /// No description provided for @subject.
  ///
  /// In fr, this message translates to:
  /// **'Sujet'**
  String get subject;

  /// No description provided for @service.
  ///
  /// In fr, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @message.
  ///
  /// In fr, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @priority.
  ///
  /// In fr, this message translates to:
  /// **'Priorité'**
  String get priority;

  /// No description provided for @attachment.
  ///
  /// In fr, this message translates to:
  /// **'Pièce jointe'**
  String get attachment;

  /// No description provided for @writeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Écrire un message…'**
  String get writeMessage;

  /// No description provided for @noConversations.
  ///
  /// In fr, this message translates to:
  /// **'Aucune conversation'**
  String get noConversations;

  /// No description provided for @ticketResolved.
  ///
  /// In fr, this message translates to:
  /// **'Demande résolue'**
  String get ticketResolved;

  /// No description provided for @rateService.
  ///
  /// In fr, this message translates to:
  /// **'Votre avis sur la réponse'**
  String get rateService;

  /// No description provided for @readReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Lu'**
  String get readReceipt;

  /// No description provided for @announcementsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annonces'**
  String get announcementsTitle;

  /// No description provided for @appointmentsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rendez-vous'**
  String get appointmentsTitle;

  /// No description provided for @newAppointment.
  ///
  /// In fr, this message translates to:
  /// **'Prendre rendez-vous'**
  String get newAppointment;

  /// No description provided for @withLabel.
  ///
  /// In fr, this message translates to:
  /// **'Avec'**
  String get withLabel;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In fr, this message translates to:
  /// **'Heure'**
  String get time;

  /// No description provided for @appointmentRequested.
  ///
  /// In fr, this message translates to:
  /// **'Demande de rendez-vous envoyée'**
  String get appointmentRequested;

  /// No description provided for @noAppointments.
  ///
  /// In fr, this message translates to:
  /// **'Aucun rendez-vous'**
  String get noAppointments;

  /// No description provided for @service_FINANCES.
  ///
  /// In fr, this message translates to:
  /// **'Finances'**
  String get service_FINANCES;

  /// No description provided for @service_SCOLARITE.
  ///
  /// In fr, this message translates to:
  /// **'Scolarité'**
  String get service_SCOLARITE;

  /// No description provided for @service_PEDAGOGIE.
  ///
  /// In fr, this message translates to:
  /// **'Pédagogie'**
  String get service_PEDAGOGIE;

  /// No description provided for @service_DISCIPLINE.
  ///
  /// In fr, this message translates to:
  /// **'Discipline'**
  String get service_DISCIPLINE;

  /// No description provided for @service_SUPPORT_TECHNIQUE.
  ///
  /// In fr, this message translates to:
  /// **'Support technique'**
  String get service_SUPPORT_TECHNIQUE;

  /// No description provided for @status_OUVERT.
  ///
  /// In fr, this message translates to:
  /// **'Ouvert'**
  String get status_OUVERT;

  /// No description provided for @status_EN_COURS.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get status_EN_COURS;

  /// No description provided for @status_RESOLU.
  ///
  /// In fr, this message translates to:
  /// **'Résolu'**
  String get status_RESOLU;

  /// No description provided for @status_CLOTURE.
  ///
  /// In fr, this message translates to:
  /// **'Clôturé'**
  String get status_CLOTURE;

  /// No description provided for @documentsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @vault.
  ///
  /// In fr, this message translates to:
  /// **'Coffre-fort'**
  String get vault;

  /// No description provided for @requests.
  ///
  /// In fr, this message translates to:
  /// **'Démarches'**
  String get requests;

  /// No description provided for @newRequest.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle demande'**
  String get newRequest;

  /// No description provided for @sign.
  ///
  /// In fr, this message translates to:
  /// **'Signer'**
  String get sign;

  /// No description provided for @signConfirm.
  ///
  /// In fr, this message translates to:
  /// **'En signant, vous reconnaissez avoir lu et accepté ce document.'**
  String get signConfirm;

  /// No description provided for @signed.
  ///
  /// In fr, this message translates to:
  /// **'Signé'**
  String get signed;

  /// No description provided for @toSign.
  ///
  /// In fr, this message translates to:
  /// **'À signer'**
  String get toSign;

  /// No description provided for @uploadDocument.
  ///
  /// In fr, this message translates to:
  /// **'Déposer une pièce'**
  String get uploadDocument;

  /// No description provided for @documentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Intitulé'**
  String get documentTitle;

  /// No description provided for @category.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get category;

  /// No description provided for @enrollmentCertificate.
  ///
  /// In fr, this message translates to:
  /// **'Attestation d\'inscription'**
  String get enrollmentCertificate;

  /// No description provided for @noDocuments.
  ///
  /// In fr, this message translates to:
  /// **'Aucun document'**
  String get noDocuments;

  /// No description provided for @noRequests.
  ///
  /// In fr, this message translates to:
  /// **'Aucune démarche'**
  String get noRequests;

  /// No description provided for @documentReady.
  ///
  /// In fr, this message translates to:
  /// **'Document prêt'**
  String get documentReady;

  /// No description provided for @disciplineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vie scolaire'**
  String get disciplineTitle;

  /// No description provided for @acknowledge.
  ///
  /// In fr, this message translates to:
  /// **'Accuser réception'**
  String get acknowledge;

  /// No description provided for @acknowledged.
  ///
  /// In fr, this message translates to:
  /// **'Réception confirmée'**
  String get acknowledged;

  /// No description provided for @convocationOn.
  ///
  /// In fr, this message translates to:
  /// **'Convocation le {date}'**
  String convocationOn(String date);

  /// No description provided for @noDiscipline.
  ///
  /// In fr, this message translates to:
  /// **'Rien à signaler'**
  String get noDiscipline;

  /// No description provided for @notificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @markAllRead.
  ///
  /// In fr, this message translates to:
  /// **'Tout marquer comme lu'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification'**
  String get noNotifications;

  /// No description provided for @notificationPrefs.
  ///
  /// In fr, this message translates to:
  /// **'Préférences de notification'**
  String get notificationPrefs;

  /// No description provided for @push.
  ///
  /// In fr, this message translates to:
  /// **'Push'**
  String get push;

  /// No description provided for @sms.
  ///
  /// In fr, this message translates to:
  /// **'SMS'**
  String get sms;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @category_FINANCE.
  ///
  /// In fr, this message translates to:
  /// **'Finances'**
  String get category_FINANCE;

  /// No description provided for @category_PRESENCE.
  ///
  /// In fr, this message translates to:
  /// **'Présences'**
  String get category_PRESENCE;

  /// No description provided for @category_NOTES.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get category_NOTES;

  /// No description provided for @category_EMPLOI_DU_TEMPS.
  ///
  /// In fr, this message translates to:
  /// **'Emploi du temps'**
  String get category_EMPLOI_DU_TEMPS;

  /// No description provided for @category_MESSAGERIE.
  ///
  /// In fr, this message translates to:
  /// **'Messages & annonces'**
  String get category_MESSAGERIE;

  /// No description provided for @category_DISCIPLINE.
  ///
  /// In fr, this message translates to:
  /// **'Vie scolaire'**
  String get category_DISCIPLINE;

  /// No description provided for @category_URGENCE.
  ///
  /// In fr, this message translates to:
  /// **'Urgences'**
  String get category_URGENCE;

  /// No description provided for @moreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Plus'**
  String get moreTitle;

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get profile;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Automatique'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// No description provided for @security.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get security;

  /// No description provided for @biometrics.
  ///
  /// In fr, this message translates to:
  /// **'Connexion biométrique'**
  String get biometrics;

  /// No description provided for @biometricsUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Biométrie indisponible sur cet appareil'**
  String get biometricsUnavailable;

  /// No description provided for @changePassword.
  ///
  /// In fr, this message translates to:
  /// **'Changer le mot de passe'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe actuel'**
  String get currentPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe modifié'**
  String get passwordChanged;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logout;

  /// No description provided for @logoutAll.
  ///
  /// In fr, this message translates to:
  /// **'Déconnecter tous mes appareils'**
  String get logoutAll;

  /// No description provided for @logoutConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment vous déconnecter ?'**
  String get logoutConfirm;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @help.
  ///
  /// In fr, this message translates to:
  /// **'Aide & FAQ'**
  String get help;

  /// No description provided for @privacy.
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité'**
  String get privacy;

  /// No description provided for @contactSchool.
  ///
  /// In fr, this message translates to:
  /// **'Contacter l\'AFRAM'**
  String get contactSchool;

  /// No description provided for @version.
  ///
  /// In fr, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @scanQr.
  ///
  /// In fr, this message translates to:
  /// **'Scanner le QR de présence'**
  String get scanQr;

  /// No description provided for @scanSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Présence enregistrée'**
  String get scanSuccess;

  /// No description provided for @profession.
  ///
  /// In fr, this message translates to:
  /// **'Profession'**
  String get profession;

  /// No description provided for @address.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get address;

  /// No description provided for @emergencyContact.
  ///
  /// In fr, this message translates to:
  /// **'Contact d\'urgence'**
  String get emergencyContact;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
