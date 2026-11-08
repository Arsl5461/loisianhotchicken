import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

// ------------------------------------------------------------
// FIRESTORE SERVICE
// ------------------------------------------------------------
FirebaseFirestore backupDb() {
  return FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: "backupdb",
  );
}

FirebaseFirestore getActiveDb() {
  return FirebaseFirestore.instance;
}

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  WriteBatch batch() => _db.batch();

  Future<QuerySnapshot<Map<String, dynamic>>> getSubCollectionSnapshot(
    String parentCollectionPath,
    String parentDocId,
    String subCollectionPath, {
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)? builder,
  }) {
    Query<Map<String, dynamic>> query = _db
        .collection(parentCollectionPath)
        .doc(parentDocId)
        .collection(subCollectionPath);

    if (builder != null) {
      query = builder(query);
    }

    return query.get();
  }

  String generateId([String collectionPath = 'dummy']) {
    return _db.collection(collectionPath).doc().id;
  }

  WriteBatch getBatch() {
    return _db.batch();
  }

  /// Add a document to [collection] – Firestore will generate the ID.
  Future<DocumentReference<Map<String, dynamic>>> addDocument(
    String collectionPath,
    Map<String, dynamic> data, {
    String? docId,
  }) async {
    final collection = _db.collection(collectionPath);

    if (docId == null || docId.isEmpty) {
      // Firestore generates the ID
      return collection.add(data);
    } else {
      final ref = collection.doc(docId);
      await ref.set(data); // overwrite if it already exists
      return ref;
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> addOrMergeDocument(
    String collectionPath,
    Map<String, dynamic> data, {
    String? docId,
  }) async {
    final collection = _db.collection(collectionPath);

    if (docId == null || docId.isEmpty) {
      // Firestore generates a new ID
      return collection.add(data);
    } else {
      final docRef = collection.doc(docId);
      await docRef.set(data, SetOptions(merge: true)); // merge if exists
      return docRef;
    }
  }

  Future<List<T>> queryByArrayContains<T>({
    required String collectionPath,
    required String arrayField,
    required dynamic value,
    required T Function(Map<String, dynamic>, String) fromJson,
    Query<Object?> Function(Query<Object?>)? builder,
  }) async {
    Query<Object?> query = FirebaseFirestore.instance
        .collection(collectionPath)
        .where(arrayField, arrayContains: value);

    if (builder != null) {
      query = builder(query);
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => fromJson(doc.data()! as Map<String, dynamic>, doc.id))
        .toList();
  }

  Stream<List<T>> watchByArrayContains<T>({
    required String collectionPath,
    required String arrayField,
    required dynamic value,
    required T Function(Map<String, dynamic> json, String docId) fromJson,
  }) {
    return _db
        .collection(collectionPath)
        .where(arrayField, arrayContains: value)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => fromJson(doc.data(), doc.id)).toList(),
        );
  }

  Future<bool> documentExistsByField(
    String collectionPath,
    String fieldName,
    dynamic value,
  ) async {
    try {
      final querySnapshot = await _db
          .collection(collectionPath)
          .where(fieldName, isEqualTo: value)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking existence: $e');
      return false; // Or rethrow if needed
    }
  }

  /// Set a document inside a subcollection
  Future<void> setSubDocument(
    String parentCollectionPath,
    String parentDocId,
    String subCollectionPath,
    String subDocId,
    Map<String, dynamic> data, {
    bool merge = false, // optional parameter
  }) async {
    await _db
        .collection(parentCollectionPath)
        .doc(parentDocId)
        .collection(subCollectionPath)
        .doc(subDocId)
        .set(
          data,
          SetOptions(merge: merge), // merge if true
        );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSubDocument(
    String parentCollectionPath,
    String parentDocId,
    String subCollectionPath,
    String subDocId,
  ) async {
    return await _db
        .collection(parentCollectionPath)
        .doc(parentDocId)
        .collection(subCollectionPath)
        .doc(subDocId)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSubSubDocument(
    String parentCollectionPath,
    String parentDocId,
    String subCollectionPath,
    String subDocId,
    String subSubCollectionPath,
    String subSubDocId,
  ) async {
    return await _db
        .collection(parentCollectionPath)
        .doc(parentDocId)
        .collection(subCollectionPath)
        .doc(subDocId)
        .collection(subSubCollectionPath)
        .doc(subSubDocId)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchSubSubCollection(
    String parentCollectionPath,
    String parentDocId,
    String subCollectionPath,
    String subDocId,
    String subSubCollectionPath,
  ) {
    return _db
        .collection(parentCollectionPath)
        .doc(parentDocId)
        .collection(subCollectionPath)
        .doc(subDocId)
        .collection(subSubCollectionPath)
        .snapshots();
  }

  Future<(List<Map<String, dynamic>>, DocumentSnapshot?)>
  getSubCollectionDocuments(
    String parentCollectionPath,
    String parentDocId,
    String subCollectionPath, {
    String? orderByField,
    bool descending = false,
    int? limit,
    DocumentSnapshot? lastDoc,
  }) async {
    CollectionReference subCollection = _db
        .collection(parentCollectionPath)
        .doc(parentDocId)
        .collection(subCollectionPath);

    Query query = subCollection;

    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();

    List<Map<String, dynamic>> dataList = snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    DocumentSnapshot? lastSnapshot = snapshot.docs.isNotEmpty
        ? snapshot.docs.last
        : null;

    return (dataList, lastSnapshot);
  }

  Future<void> deleteSubDocument(
    String parentCollectionPath,
    String parentDocId,
    String subCollectionPath,
    String subDocId,
  ) async {
    await _db
        .collection(parentCollectionPath)
        .doc(parentDocId)
        .collection(subCollectionPath)
        .doc(subDocId)
        .delete();
  }

  Future<void> deleteSubCollection({
    required String parentCollectionPath,
    required String parentDocId,
    required String subCollectionPath,
    int batchSize = 50,
  }) async {
    final collectionRef = _db
        .collection(parentCollectionPath)
        .doc(parentDocId)
        .collection(subCollectionPath);

    // delete in batches
    while (true) {
      final querySnapshot = await collectionRef.limit(batchSize).get();

      if (querySnapshot.docs.isEmpty) {
        break; // ✅ finished deleting all
      }

      final batch = _db.batch();

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    }
  }

  Future<void> deleteCollection({
    required String collectionPath,
    int batchSize = 50,
  }) async {
    final collectionRef = _db.collection(collectionPath);

    while (true) {
      final querySnapshot = await collectionRef.limit(batchSize).get();

      if (querySnapshot.docs.isEmpty) {
        break; // ✅ all documents deleted
      }

      final batch = _db.batch();

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> queryCollection(
    String collectionPath, {
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)? builder,
  }) {
    Query<Map<String, dynamic>> query = _db.collection(collectionPath);
    if (builder != null) {
      query = builder(query);
    }
    return query.get();
  }

  Future<void> setOrUpdateDocument(
    String collectionPath,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await _db
        .collection(collectionPath)
        .doc(docId)
        .set(data, SetOptions(merge: true));
  }

  /// Create / overwrite a document with an explicit [docId].
  Future<void> setDocument(
    String collectionPath,
    String docId,
    Map<String, dynamic> data, {
    bool merge = false, // optional parameter (default = true)
  }) => _db
      .collection(collectionPath)
      .doc(docId)
      .set(data, SetOptions(merge: merge));

  /// Update an existing document (fails if it does not exist).
  Future<void> updateDocument(
    String collectionPath,
    String docId,
    Map<String, dynamic> data,
  ) => _db.collection(collectionPath).doc(docId).update(data);

  Future<void> setOrUpdateDataDocument(
    String rootCollectionPath, // "updates"
    String subCollection, // "users" or "cars"
    String docId, // userId or carId
    Map<String, dynamic> data,
  ) async {
    await _db
        .collection(rootCollectionPath) // "updates"
        .doc(subCollection) // "users" or "cars"
        .collection(
          subCollection,
        ) // Create subcollection "users" or "cars" under doc
        .doc(docId) // document ID inside subcollection
        .set(data);
  }

  /// Delete a document.
  Future<void> deleteDocument(String collectionPath, String docId) =>
      _db.collection(collectionPath).doc(docId).delete();

  /// Get a single document once.
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collectionPath,
    String docId,
  ) => _db.collection(collectionPath).doc(docId).get();

  /// Listen to live changes of a document.
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDocument(
    String collectionPath,
    String docId,
  ) => _db.collection(collectionPath).doc(docId).snapshots();
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    return _db.collection(collectionPath);
  }

  /// Get a whole collection once.
  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String collectionPath,
  ) => _db.collection(collectionPath).get();
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentById(
    String collectionPath,
    String docId,
  ) => _db.collection(collectionPath).doc(docId).get();

  /// Live query of a collection with optional query builder.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchCollection(
    String collectionPath, [
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
    queryBuilder,
  ]) {
    Query<Map<String, dynamic>> query = _db.collection(collectionPath);
    if (queryBuilder != null) query = queryBuilder(query);
    return query.snapshots();
  }
}
