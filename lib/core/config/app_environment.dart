class AppEnvironment {
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String contactEmailAddress = String.fromEnvironment(
    'CONTACT_EMAIL_ADDRESS',
    defaultValue: 'ayandamhlongo@gmail.com',
  );

  static const String cloudFunctionsRegion = String.fromEnvironment(
    'CLOUD_FUNCTIONS_REGION',
    defaultValue: 'us-central1',
  );
}
