import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/appuser.dart';
import '../models/product.dart';
import '../models/purchase.dart';

class FirestoreService {
  final log = getLogger('FirestoreApi');
  final _authenticationService = locator<FirebaseAuthenticationService>();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('user');

  Future<bool> createUser({required AppUser user, required keyword}) async {
    log.i('user:$user');
    try {
      final userDocument = _usersCollection.doc(user.id);
      await userDocument.set(user.toJson(keyword), SetOptions(merge: true));
      log.v('UserCreated at ${userDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  Future<AppUser?> getUser({required String userId}) async {
    log.i('userId:$userId');

    if (userId.isNotEmpty) {
      final userDoc = await _usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        log.v('We have no user with id $userId in our database');
        return null;
      }

      final userData = userDoc.data();
      log.v('User found. Data: $userData');

      return AppUser.fromMap(userData! as Map<String, dynamic>);
    } else {
      log.e("Error no user");
      return null;
    }
  }

  ///==================================================
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection("products");

  Future<bool> addProduct(Product product) async {
    log.i('vehicle:$product');
    try {
      final userDocument = _productCollection.doc(product.rfid);
      await userDocument.set(product.toJson(), SetOptions(merge: true));
      log.v('vehicle created at ${userDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  Stream<List<Product>> getAllProducts() {
    try {
      // Query to get all products
      Query query = _productCollection;

      // Snapshot of the query result as a stream
      Stream<QuerySnapshot> snapshots = query.snapshots();

      // Map the snapshots to a list of Product objects
      Stream<List<Product>> productStream =
          snapshots.map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot document) {
          return Product.fromMap(document.data() as Map<String, dynamic>);
        }).toList();
      });

      return productStream;
    } catch (e) {
      // Handle any errors here
      log.e("Error getting products: $e");
      // You might want to handle errors more gracefully
      return Stream.value([]); // Return an empty list on error
    }
  }

  ///======================================================
  final CollectionReference _purchaseCollection =
      FirebaseFirestore.instance.collection("purchases");

  Future<String?> generatePurchaseDocumentId() async {
    try {
      // Add a document with an auto-generated ID
      DocumentReference documentReference = _purchaseCollection.doc();

      // Retrieve the auto-generated ID from the document reference
      String documentId = documentReference.id;

      // Return the generated document ID
      return documentId;
    } catch (e) {
      // Handle any errors here
      log.e("Error generating document ID: $e");
      return null; // You might want to handle errors more gracefully
    }
  }

  Future<bool> addPurchase(Purchase purchase) async {
    try {
      // Convert the Purchase object to a Map using toJson method
      Map<String, dynamic> purchaseData = purchase.toJson();

      // Add the purchase document to the "purchases" collection
      await _purchaseCollection.add(purchaseData);

      log.i('Purchase added successfully');
      return true;
    } catch (error) {
      log.e('Error adding purchase: $error');
      // You might want to handle errors more gracefully
      return false;
    }
  }

  Stream<List<Purchase>> getAllPurchases() {
    try {
      // Query to get all products
      Query query = _purchaseCollection;

      // Snapshot of the query result as a stream
      Stream<QuerySnapshot> snapshots = query.snapshots();

      // Map the snapshots to a list of Product objects
      Stream<List<Purchase>> productStream =
          snapshots.map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot document) {
          return Purchase.fromMap(document.data() as Map<String, dynamic>);
        }).toList();
      });

      return productStream;
    } catch (e) {
      // Handle any errors here
      log.e("Error getting products: $e");
      // You might want to handle errors more gracefully
      return Stream.value([]); // Return an empty list on error
    }
  }
}
