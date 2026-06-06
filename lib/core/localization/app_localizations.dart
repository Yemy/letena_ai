import '../constants/app_strings.dart';
import '../../providers/language_provider.dart';

class AppLocalizations {
  final AppLanguage language;
  AppLocalizations(this.language);

  // AI Chat & Voice
  String get talkToCompanion {
    switch (language) {
      case AppLanguage.amharic: return 'ከ Letena ጋር ያውሩ...';
      case AppLanguage.tigrigna: return 'ምስ Letena ተዛረብ...';
      case AppLanguage.oromo: return 'Letena wajjiin haasawaa...';
      default: return 'Talk to Letena...';
    }
  }

  String get companionRole {
    switch (language) {
      case AppLanguage.amharic: return 'የጤንነት አጋዥዎ';
      case AppLanguage.tigrigna: return 'ናይ ዉልቀ ረድኤት ሞዓልቦ';
      case AppLanguage.oromo: return 'Hiriyyaa Keessan';
      default: return 'Your Wellness Companion';
    }
  }

  String get imStressed {
    switch (language) {
      case AppLanguage.amharic: return 'ተጨንቄያለሁ 😔';
      case AppLanguage.tigrigna: return 'ተጨኒቐ ኣለኹ 😔';
      case AppLanguage.oromo: return 'Nan dhiphadhe 😔';
      default: return 'I\'m stressed 😔';
    }
  }

  String get guideMeditation {
    switch (language) {
      case AppLanguage.amharic: return 'ማሰላሰል 🧘';
      case AppLanguage.tigrigna: return 'ሜዲቴሽን 🧘';
      case AppLanguage.oromo: return 'Meditation 🧘';
      default: return 'Guide meditation 🧘';
    }
  }

  String get greetingMessage {
    switch (language) {
      case AppLanguage.amharic: return "ሰላም! እኔ Letena ነኝ፣ የግል ጤንነት አጋዥዎ። 💚\n\nከጭንቀትዎ እንድትገላገሉ እና ጤናማ ልምዶችን እንድትገነቡ ልረዳዎ እዚህ ነኝ።\n\nአሁን ምን ይሰማዎታል?";
      case AppLanguage.tigrigna: return "ሰላም! ኣነ Letena እየ፣ ናይ ዉልቀ ረድኤት ሞዓልቦ። 💚\n\nካብ ጭንቀት ክትናገፉን ጥዕና ዘለዎ ልምዲ ክትሃንጹን ክግዘኩም ኣብዚ ኣለኹ።\n\nሕጂ እንታይ ይስመዓኩም ኣሎ?";
      case AppLanguage.oromo: return "Akkam! Ani Letena dha, hiriyyaa keessan. 💚\n\nDhiphina irraa akka boqottan isin gargaaruuf asan jira.\n\nAmmatti maaltu isinitti dhaga'amaa jira?";
      default: return "Hi! I'm Letena, your personal wellness companion. 💚\n\nI'm here to help you prevent burnout, build healthy habits, and thrive — every single day.\n\nHow are you feeling right now?";
    }
  }

  String get defaultFallback {
    switch (language) {
      case AppLanguage.amharic: return "እኔ Letena ነኝ፣ የጤንነት አጋዥዎ። 💚 ጤናማ ልምዶችን እንድትገነቡ ልረዳዎ እዚህ ነኝ። አሁን ምን ይሰማዎታል፣ እና በምን ልርዳዎ እችላለሁ?";
      case AppLanguage.tigrigna: return "ኣነ Letena እየ፣ ናይ ዉልቀ ረድኤት ሞዓልቦ። 💚 ጥዕና ዘለዎ ልምዲ ክትሃንጹን ክግዘኩም ኣብዚ ኣለኹ። ሕጂ እንታይ ይስመዓኩም ኣሎ፣ ብኸመይ ክሕግዘኩም እኽእል?";
      case AppLanguage.oromo: return "Ani Letena dha, hiriyyaa keessan. 💚 Ammatti maaltu isinitti dhaga'amaa jira, akkamittin isin gargaaruu danda'a?";
      default: return "I'm Letena, your wellness companion. 💚 I'm here to help you build healthy habits. How are you feeling right now, and what would you most like support with today?";
    }
  }

  // Onboarding
  String get welcomeTitle1 {
    switch (language) {
      case AppLanguage.amharic: return 'የጤንነት ጉዞዎ እዚህ ይጀምራል';
      case AppLanguage.tigrigna: return 'ናይ ጥዕና ጉዕዞኹም ኣብዚ ይጅምር';
      case AppLanguage.oromo: return 'Imalli Fayyaa Keessan Asitti Jalqaba';
      default: return AppStrings.welcomeTitle1;
    }
  }

  String get welcomeBody1 {
    switch (language) {
      case AppLanguage.amharic: return 'የዕድሜ ልክ ልምዶችን ይገንቡ፣ ከጭንቀት ይላቀቁ፣ እና በየቀኑ ያድጉ።';
      case AppLanguage.tigrigna: return 'ናይ ዕድመ ልክ ልምዲ ህነጹ፣ ካብ ጭንቀት ተላቐቑ፣ ነፍሲ ወከፍ መዓልቲ ድማ ዕበዩ።';
      case AppLanguage.oromo: return 'Aadaa jireenya guutuu ijaaraa, dhiphina dhoorkaa, guyyaa guyyaan guddadhaa.';
      default: return AppStrings.welcomeBody1;
    }
  }

  String get welcomeTitle2 {
    switch (language) {
      case AppLanguage.amharic: return 'በደንብ የሚረዳዎ AI';
      case AppLanguage.tigrigna: return 'ኣጸቢቑ ዝርድኣኩም AI';
      case AppLanguage.oromo: return 'AI Haala Gaariin Isin Hubatu';
      default: return AppStrings.welcomeTitle2;
    }
  }

  String get welcomeBody2 {
    switch (language) {
      case AppLanguage.amharic: return 'የግል አጋዥዎ Letena ባህሪዎን በማጥናት በራስዎ ቋንቋ በፍቅር ይመራዎታል።';
      case AppLanguage.tigrigna: return 'Letena ባህሪኹም ብምጽናዕ ብቋንቋኹም ብፍቕሪ ይመርሓኩም።';
      case AppLanguage.oromo: return 'AI n Letena amala keessan barachuun afaan keessaniin jaalalaan isin qajeelcha.';
      default: return AppStrings.welcomeBody2;
    }
  }

  String get welcomeTitle3 {
    switch (language) {
      case AppLanguage.amharic: return 'ጤንነት በጋራ የተሻለ ነው';
      case AppLanguage.tigrigna: return 'ጥዕና ብሓባር ዝሐሸ እዩ';
      case AppLanguage.oromo: return 'Fayyummaan Waliin Gaariidha';
      default: return AppStrings.welcomeTitle3;
    }
  }

  String get welcomeBody3 {
    switch (language) {
      case AppLanguage.amharic: return 'ጉዞዎን ከሚረዱ ማህበረሰቦች ጋር በሚስጥር ይገናኙ።';
      case AppLanguage.tigrigna: return 'ንጉዕዞኹም ምስ ዝርድኡ ማሕበረሰባት ብምስጢር ተራኸቡ።';
      case AppLanguage.oromo: return 'Hawaasa imala keessan hubatan wajjin iccitiin wal-qunnamaa.';
      default: return AppStrings.welcomeBody3;
    }
  }

  String get welcomeTitle4 {
    switch (language) {
      case AppLanguage.amharic: return 'ከፍጽምና ይልቅ እድገት';
      case AppLanguage.tigrigna: return 'ካብ ፍጽምና ንላዕሊ ዕቤት';
      case AppLanguage.oromo: return 'Guddina Malee Mudaa dhabummaa Miti';
      default: return AppStrings.welcomeTitle4;
    }
  }

  String get welcomeBody4 {
    switch (language) {
      case AppLanguage.amharic: return 'ልምዶችን ያግኙ፣ እና እያንዳንዱን ትንሽ ድል ከ Letena ጋር አብረው ያክብሩ።';
      case AppLanguage.tigrigna: return 'ልምዲ ረኸቡ፣ ነፍሲ ወከፍ ንእሽቶ ዓወት ከኣ ምስ Letena ሓቢርኩም ኣብዕሉ።';
      case AppLanguage.oromo: return 'Muuxannoo argadhaa, injifannoo xiqqaa hunda Letena wajjin kabajaa.';
      default: return AppStrings.welcomeBody4;
    }
  }

  // Buttons
  String get nextButton {
    switch (language) {
      case AppLanguage.amharic: return 'ቀጣይ';
      case AppLanguage.tigrigna: return 'ቀጺል';
      case AppLanguage.oromo: return 'Itti Fufi';
      default: return 'Next';
    }
  }

  String get backButton {
    switch (language) {
      case AppLanguage.amharic: return 'ተመለስ';
      case AppLanguage.tigrigna: return 'ተመለስ';
      case AppLanguage.oromo: return 'Duuba';
      default: return 'Back';
    }
  }

  String get getStartedButton {
    switch (language) {
      case AppLanguage.amharic: return 'ይጀምሩ';
      case AppLanguage.tigrigna: return 'ጀምር';
      case AppLanguage.oromo: return 'Jalqabi';
      default: return 'Get Started';
    }
  }

  // Home Screen
  String get goodMorning {
    switch (language) {
      case AppLanguage.amharic: return 'እንደምን አደሩ';
      case AppLanguage.tigrigna: return 'ከመይ ሓዲርኩም';
      case AppLanguage.oromo: return 'Akkam bultan';
      default: return 'Good morning';
    }
  }

  String get goodAfternoon {
    switch (language) {
      case AppLanguage.amharic: return 'እንደምን ዋሉ';
      case AppLanguage.tigrigna: return 'ከመይ ውዒልኩም';
      case AppLanguage.oromo: return 'Akkam ooltan';
      default: return 'Good afternoon';
    }
  }

  String get goodEvening {
    switch (language) {
      case AppLanguage.amharic: return 'እንደምን አመሹ';
      case AppLanguage.tigrigna: return 'ከመይ ኣምሲኹም';
      case AppLanguage.oromo: return 'Akkam galgaltan';
      default: return 'Good evening';
    }
  }

  String get youreA {
    switch (language) {
      case AppLanguage.amharic: return 'እርስዎ፡';
      case AppLanguage.tigrigna: return 'ንስኹም፡';
      case AppLanguage.oromo: return 'Isin:';
      default: return 'You\'re a';
    }
  }

  String get dailyQuests {
    switch (language) {
      case AppLanguage.amharic: return 'ዕለታዊ ተግባሮች';
      case AppLanguage.tigrigna: return 'ዕለታዊ ዕማማት';
      case AppLanguage.oromo: return 'Hojiiwwan Guyyaa';
      default: return 'Daily Quests';
    }
  }

  String get doneWord {
    switch (language) {
      case AppLanguage.amharic: return 'ተጠናቋል';
      case AppLanguage.tigrigna: return 'ተዛዚሙ';
      case AppLanguage.oromo: return 'Xumurame';
      default: return 'done';
    }
  }

  String get letenaSays {
    switch (language) {
      case AppLanguage.amharic: return 'Letena ትላለች...';
      case AppLanguage.tigrigna: return 'Letena ትብል...';
      case AppLanguage.oromo: return 'Letena akkas jetti...';
      default: return 'Letena says...';
    }
  }

  String get howAreYouFeeling {
    switch (language) {
      case AppLanguage.amharic: return 'ዛሬ ምን ይሰማዎታል?';
      case AppLanguage.tigrigna: return 'ሎሚ እንታይ ይስመዓኩም ኣሎ?';
      case AppLanguage.oromo: return 'Har\'a maaltu isinitti dhaga\'ama?';
      default: return 'How are you feeling today?';
    }
  }

  String get quickCheckIn {
    switch (language) {
      case AppLanguage.amharic: return 'ፈጣን ዳሰሳ — 30 ሰከንድ ይወስዳል ⚡';
      case AppLanguage.tigrigna: return 'ቅልጡፍ ዳህሳስ — 30 ካልኢት ይወስድ ⚡';
      case AppLanguage.oromo: return 'Saffisaan madaaluu — sekondii 30 fudhata ⚡';
      default: return 'Quick check-in — takes 30 seconds ⚡';
    }
  }
}
