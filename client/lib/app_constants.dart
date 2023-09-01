class AppConstants {
  static const String realmName = "mydata.tools";
  static const String appName = "com.familydam.client";
  static const String configFileName = "config.json";
  static const String dbFileName = "metadata.realm";

  //DB Constants
  static const int schemaVersion = 1;
  static const bool shouldDeleteIfMigrationNeeded = true;

  /// Secure Storage Keys
  static const String securePassword = "password";
  static const String securePrivateKey = "private-key";
  static const String securePublicKey = "public-key";
  static const String secureStorageLocation = "storage-location";

  /// Scanner props
  static const String scannerEmailGmail = "email.gmail";
  static const String scannerFileLocal = "file.local";
}
