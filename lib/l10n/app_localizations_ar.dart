// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'ساي فولت';

  @override
  String get tagline => 'أسرارك تحت سيطرتك';

  @override
  String get createVault => 'إنشاء الخزنة';

  @override
  String get unlockVault => 'فتح ساي فولت';

  @override
  String get masterPassword => 'كلمة المرور الرئيسية';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get unlock => 'فتح';

  @override
  String get passwordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get passwordTooWeak => 'استخدم 12 محرفًا على الأقل وعبارة متنوعة.';

  @override
  String get wrongPassword => 'كلمة المرور غير صحيحة أو بيانات الخزنة تالفة.';

  @override
  String get securityNotice =>
      'لا يمكن لساي فولت استعادة كلمة مرور رئيسية منسية. احتفظ بنسخة احتياطية مشفرة منفصلة.';

  @override
  String get dashboard => 'لوحة المعلومات';

  @override
  String get vault => 'الخزنة';

  @override
  String get generator => 'المولّد';

  @override
  String get settings => 'الإعدادات';

  @override
  String get breachCheck => 'فحص التسريب';

  @override
  String get help => 'المساعدة';

  @override
  String get about => 'حول التطبيق';

  @override
  String get securityModel => 'نموذج الأمان';

  @override
  String get lock => 'قفل';

  @override
  String get items => 'العناصر';

  @override
  String get breached => 'مسرّبة';

  @override
  String get favorites => 'المفضلة';

  @override
  String get averageRisk => 'متوسط الخطر';

  @override
  String get emptyVault => 'خزنتك فارغة';

  @override
  String get emptyVaultHint => 'أضف أول بيانات دخول مشفرة للبدء.';

  @override
  String get addItem => 'إضافة عنصر';

  @override
  String get editItem => 'تعديل العنصر';

  @override
  String get title => 'العنوان';

  @override
  String get username => 'اسم المستخدم أو البريد';

  @override
  String get password => 'كلمة المرور';

  @override
  String get url => 'الموقع';

  @override
  String get notes => 'ملاحظات';

  @override
  String get tags => 'الوسوم (مفصولة بفواصل)';

  @override
  String get favorite => 'مفضلة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get search => 'البحث في العناصر بعد فكها';

  @override
  String get copy => 'نسخ';

  @override
  String get copied => 'نُسخت مؤقتًا';

  @override
  String get reveal => 'إظهار';

  @override
  String get hide => 'إخفاء';

  @override
  String get checkNow => 'افحص الآن';

  @override
  String get onlineConsentRequired =>
      'فعّل موافقة فحص التسريب عبر الإنترنت من الإعدادات أولًا.';

  @override
  String get notFoundInBreach =>
      'لم تظهر في مجموعة التسريبات التي تم الاستعلام عنها.';

  @override
  String foundInBreach(int count) {
    return 'ظهرت $count مرة في مجموعة التسريبات.';
  }

  @override
  String get offlineAnalysis =>
      'يبقى تحليل القوة المحلي متاحًا. تطابق البادئة وحده لا يُعد دليلًا على التسريب.';

  @override
  String get generate => 'توليد كلمة مرور';

  @override
  String get length => 'الطول';

  @override
  String get uppercase => 'أحرف كبيرة';

  @override
  String get lowercase => 'أحرف صغيرة';

  @override
  String get digits => 'أرقام';

  @override
  String get symbols => 'رموز';

  @override
  String get avoidAmbiguous => 'تجنب المحارف المتشابهة';

  @override
  String get saveToVault => 'حفظ في الخزنة';

  @override
  String get theme => 'المظهر';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get dynamicColor => 'استخدام ألوان النظام الديناميكية';

  @override
  String get onlineBreachConsent =>
      'السماح بفحص التسريب بطريقة إخفاء الهوية الجزئي';

  @override
  String get biometricSecondStep => 'القياسات الحيوية كخطوة ثانية';

  @override
  String get autoLock => 'القفل التلقائي';

  @override
  String get oneMinute => 'دقيقة';

  @override
  String get fiveMinutes => '5 دقائق';

  @override
  String get fifteenMinutes => '15 دقيقة';

  @override
  String get clipboardDelay => 'مهلة مسح الحافظة';

  @override
  String get exportBackup => 'تصدير نسخة احتياطية مشفرة';

  @override
  String get importBackup => 'استيراد نسخة احتياطية مشفرة';

  @override
  String get backupPassphrase => 'عبارة مرور النسخة الاحتياطية';

  @override
  String get confirmBackupPassphrase => 'تأكيد عبارة مرور النسخة';

  @override
  String get backupComplete => 'تم إنشاء النسخة الاحتياطية المشفرة.';

  @override
  String get importComplete => 'تم التحقق من النسخة واستيرادها.';

  @override
  String get invalidBackup => 'فشل التحقق من كلمة النسخة أو صيغتها أو سلامتها.';

  @override
  String get conflictPolicy => 'معالجة التعارض';

  @override
  String get skip => 'تخطي الموجود';

  @override
  String get replace => 'استبدال الموجود';

  @override
  String get duplicate => 'الاستيراد كنسخ';

  @override
  String get generateReport => 'مشاركة ملخص PDF آمن';

  @override
  String get reportReady => 'ملخص الأمان جاهز للمشاركة.';

  @override
  String get privacySummary =>
      'ساي فولت يعمل محليًا أولًا. الفحص عبر الإنترنت اختياري ويرسل أول خمسة محارف فقط من SHA-1 إلى خدمة نطاق كلمات المرور المسرّبة.';

  @override
  String get educationalWarning =>
      'برنامج تعليمي بهندسة واعية بالإنتاج؛ لم يخضع لتدقيق أو اعتماد مستقل.';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get errorGeneric => 'حدث خطأ. لم تُسجل أي بيانات سرية.';

  @override
  String get sortNewest => 'الأحدث';

  @override
  String get sortTitle => 'العنوان أبجديًا';

  @override
  String get sortRisk => 'الأعلى خطورة';

  @override
  String get all => 'الكل';

  @override
  String get securityEvents => 'سجل أحداث الأمان';

  @override
  String get noEvents => 'لا توجد أحداث أمان بعد.';

  @override
  String get changeMasterPassword => 'تغيير كلمة المرور الرئيسية';

  @override
  String get currentMasterPassword => 'كلمة المرور الرئيسية الحالية';

  @override
  String get newMasterPassword => 'كلمة المرور الرئيسية الجديدة';

  @override
  String get masterPasswordChanged =>
      'تم تغيير الكلمة الرئيسية دون إعادة تشفير السجلات.';

  @override
  String get eventUnlockSuccess => 'تم فتح الخزنة';

  @override
  String get eventUnlockFailure => 'فشل فتح الخزنة';

  @override
  String get eventManualLock => 'قفل يدوي';

  @override
  String get eventBackgroundLock => 'قفل عند الانتقال للخلفية';

  @override
  String get eventTimeoutLock => 'قفل بسبب عدم النشاط';

  @override
  String get eventBackupExport => 'تم تصدير نسخة احتياطية';

  @override
  String get eventBackupImport => 'تم استيراد نسخة احتياطية';

  @override
  String get eventBreachCheck => 'فحص تسريب';

  @override
  String get eventMasterPasswordChange => 'تم تغيير الكلمة الرئيسية';
}
