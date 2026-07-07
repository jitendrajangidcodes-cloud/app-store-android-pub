// Single source of truth for where the store reads from. The catalog and
// manifest come from the live site, so adding an app to apps.json makes it
// appear here with no store rebuild.
class Config {
  static const siteBase =
      "https://jitendrajangidcodes-cloud.github.io/app-store-web";
  static const appsUrl = "$siteBase/apps.json";
  static const manifestUrl = "$siteBase/releases.json";

  // The store's own build lives in the same hub repo as every other APK, under
  // the stable "store" release tag. Self-update reads that tag; safe if absent:
  // the check simply finds no newer release and stays quiet.
  static const storeRepo = "jitendrajangidcodes-cloud/app-store-web";
  static const storeTag = "store";
  static const storePackageId = "com.pnsjy.store";

  // Feedback/suggestions/bug reports POST here; the Worker holds the token and
  // files the GitHub issue so users never need a GitHub account. No secrets in
  // the app. feedbackRepo stays only for the "open on GitHub" fallback link.
  static const feedbackEndpoint =
      "https://app-store-feedback.jitendrajangid-codes.workers.dev/submit";
  static const feedbackRepo = "jitendrajangidcodes-cloud/app-store-web";
}
