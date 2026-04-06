import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // ---- Authentication ----

  User? get currentUser => auth.currentUser;

  Future<bool> signOut() async {
    await auth.signOut();
    return true;
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithCredential(
      PhoneAuthCredential credential) async {
    return auth.signInWithCredential(credential);
  }

  // ---- Firestore helpers ----

  Future<List<Map<String, dynamic>>> fetchProducts({int limit = 100}) async {
    final querySnapshot =
        await firestore.collection('products').limit(limit).get();

    return querySnapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  Future<DocumentReference> createOrder(Map<String, dynamic> orderData) async {
    return firestore.collection('orders').add(orderData);
  }

  Future<DocumentSnapshot> getOrder(String orderId) async {
    return firestore.collection('orders').doc(orderId).get();
  }

  Future<List<Map<String, dynamic>>> fetchUserOrders(String userId) async {
    final querySnapshot = await firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  Future<Map<String, dynamic>> validateCoupon(String couponCode) async {
    final doc = await firestore.collection('coupons').doc(couponCode).get();
    if (!doc.exists) {
      return {
        'valid': false,
        'message': 'Invalid coupon code',
        'discountPercent': 0,
        'maxDiscount': 0,
      };
    }
    return {'valid': true, ...doc.data() as Map<String, dynamic>};
  }

  // ---- Cloud Functions ----

  Future<Map<String, dynamic>> createRazorpayOrder({
    required int amount,
    required String currency,
    required String description,
  }) async {
    final callable = functions.httpsCallable('createRazorpayOrder');
    final result = await callable.call(<String, dynamic>{
      'amount': amount,
      'currency': currency,
      'description': description,
    });
    return Map<String, dynamic>.from(result.data as Map);
  }

  Future<bool> verifyRazorpaySignature({
    required String paymentId,
    required String signature,
    required String orderId,
  }) async {
    final callable = functions.httpsCallable('verifyRazorpaySignature');
    final result = await callable.call(<String, dynamic>{
      'paymentId': paymentId,
      'signature': signature,
      'orderId': orderId,
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    return data['verified'] == true;
  }
}
