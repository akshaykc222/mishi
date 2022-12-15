// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter_inapp_purchase/modules.dart';
//
// class PaymentService {
//   /// We want singelton object of ``PaymentService`` so create private constructor
//   ///
//   /// Use PaymentService as ``PaymentService.instance``
//   PaymentService._internal();
//
//   static final PaymentService instance = PaymentService._internal();
//
//   /// To listen the status of connection between app and the billing server
//   StreamSubscription<ConnectionResult>? _connectionSubscription;
//
//   /// To listen the status of the purchase made inside or outside of the app (App Store / Play Store)
//   ///
//   /// If status is not error then app will be notied by this stream
//   StreamSubscription<PurchasedItem>? _purchaseUpdatedSubscription;
//
//   /// To listen the errors of the purchase
//   StreamSubscription<PurchaseResult>? _purchaseErrorSubscription;
//
//   /// List of product ids you want to fetch
//   final List<String> _productIds = ['monthly_subscription'];
//
//   /// All available products will be store in this list
//   List<IAPItem>? _products;
//
//   /// All past purchases will be store in this list
//   List<PurchasedItem>? _pastPurchases;
//
//   /// view of the app will subscribe to this to get notified
//   /// when premium status of the user changes
//   final ObserverList<Function> _proStatusChangedListeners =
//       ObserverList<Function>();
//
//   /// view of the app will subscribe to this to get errors of the purchase
//   final ObserverList<Function(String)> _errorListeners =
//       ObserverList<Function(String)>();
//
//   /// logged in user's premium status
//   bool _isProUser = false;
//
//   bool get isProUser => _isProUser;
// }
