// Razorpay Configuration
// Replace these with your actual Razorpay credentials from dashboard.razorpay.com
class RazorpayConfig {
  // ========== SETUP INSTRUCTIONS ==========
  // 1. Go to https://dashboard.razorpay.com/app/keys
  // 2. Copy your Key ID from the API Keys section
  // 3. Paste below in KEY_ID
  // 4. The Key Secret should NOT be stored in app (server-side only)

  static const String keyId =
      'rzp_test_1DP5MMOk78sJbb'; // Test mode key - replace with live key

  // For production, use your live key:
  // static const String keyId = 'YOUR_LIVE_KEY_ID';

  // Razorpay Test Cards for Development:
  // =====================================
  // Visa Success: 4111 1111 1111 1111 | CVV: Any 3 digits | Exp: Any future date
  // MasterCard Success: 5555 5555 5555 4444 | CVV: Any 3 digits | Exp: Any future date
  // UPI Success Test: success@razorpay
  // All test payments will succeed

  // Production Notes:
  // 1. Get live credentials from Razorpay dashboard
  // 2. Update keyId above
  // 3. Update package name in Android manifest to match your app
  // 4. Ensure INTERNET permission is in AndroidManifest.xml
  // 5. Test with test mode first before going live
}
