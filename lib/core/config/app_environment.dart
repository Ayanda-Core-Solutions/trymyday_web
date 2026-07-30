class AppEnvironment {
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String contactEmailAddress = String.fromEnvironment(
    'CONTACT_EMAIL_ADDRESS',
    defaultValue: 'ayandamhlongof@gmail.com',
  );

  static const String cloudFunctionsRegion = String.fromEnvironment(
    'CLOUD_FUNCTIONS_REGION',
    defaultValue: 'us-central1',
  );

  static const String publicFunctionsProjectId = String.fromEnvironment(
    'PUBLIC_FUNCTIONS_PROJECT_ID',
    defaultValue: appEnv == 'prod' ? 'trymyday-1d798' : 'trymyday-nonprod',
  );

  static const bool launchGateEnabled = bool.fromEnvironment(
    'LAUNCH_GATE_ENABLED',
  );

  static const String launchGateEndAt = String.fromEnvironment(
    'LAUNCH_GATE_END_AT',
    defaultValue: '2026-06-01T00:00:00+02:00',
  );

  static const String launchGateAdminToken = String.fromEnvironment(
    'LAUNCH_GATE_ADMIN_TOKEN',
    defaultValue: '',
  );
}
