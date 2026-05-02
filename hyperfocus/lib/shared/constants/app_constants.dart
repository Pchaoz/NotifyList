class AppConstants {
  static const String appName = 'Hyperfocus';
  static const String appVersion = '0.1.0';

  // Default settings
  static const int defaultReminderMinutes = 20;
  static const int defaultPingIntervalMinutes = 120;
  static const String defaultPingQuietStart = '23:00';
  static const String defaultPingQuietEnd = '07:00';
  static const int defaultDailyTarget = 3;

  // Gamification
  static const int pointsEasy = 10;
  static const int pointsMedium = 20;
  static const int pointsHard = 40;
  static const int streakBonusPercent = 25;
  static const int maxMonthlyFreezes = 2;

  // Pity system (guaranteed drop every N completions without one)
  static const int pityThreshold = 50;
}
