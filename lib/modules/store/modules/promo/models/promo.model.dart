import 'package:intl/intl.dart';
import 'package:project_dsh/modules/store/modules/brand/models/brand.model.dart';
import 'package:project_dsh/modules/store/modules/store_category/models/store_category.model.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';
import '../../../models/store.model.dart';

class Promo extends BaseModel {
  @override
  String get modelIdentifier => title;

  String id;
  String title;
  String code;
  String description;
  String ruleText;
  Store store;
  int qty;
  DateTime startingAt;
  DateTime endingAt;
  int qtyPerUser;
  String imageUrl;
  PromoStatus status;
  bool isHighlighted;



  Promo._internal({
    required this.id,
    required this.title,
    required this.ruleText,
    required this.code,
    required this.description,
    required this.store,
    required this.qty,
    required this.qtyPerUser,
    required this.startingAt,
    required this.endingAt,
    required this.imageUrl,
    required this.status,
    required this.isHighlighted,


  });

  factory Promo({
    String id = "",
    String title = "",
    String ruleText = "",
    String code = "",
    String description = "",
    int qty = 0,
    int qtyPerUser = 0,
    DateTime? startingAt,
    DateTime? endingAt,
    required Store store,
    String imageUrl = "",
    PromoStatus status = PromoStatus.pending,
    bool isHighlighted = false,
  }) {
    return Promo._internal(
      id: id,
      title: title,
      ruleText: ruleText,
      code: code,
      description: description,
      store: store,
      qty: qty,
      qtyPerUser: qtyPerUser,
      startingAt: startingAt ?? DateTime.now(),
      endingAt: endingAt ?? DateTime.now(),
      imageUrl: imageUrl,
      status: status,
      isHighlighted: isHighlighted,

    );
  }

  String get startingAtDate => DateFormat('dd/MM/yyyy', 'it').format(startingAt);
  String get endingAtDate => DateFormat('dd/MM/yyyy', 'it').format(endingAt);


  factory Promo.fromJson({
    required dynamic jsonObject,
  }) {
    return Promo(
      id: jsonObject["id"]?.toString() ?? "",
      title: jsonObject["title"] ?? "",
      code: jsonObject["code"] ?? "",
      description: jsonObject["description"] ?? "",
      qty: jsonObject["qty"] ?? 0,
      ruleText: jsonObject["ruleText"] ?? "",
      imageUrl: jsonObject["imageUrl"] ?? "",
      qtyPerUser: jsonObject["qtyPerUser"] ?? 0,
      status: PromoStatusExtension.fromValue(jsonObject["status"] ?? 0),
      startingAt: jsonObject["startingAt"] != null ? DateTime.parse(jsonObject["startingAt"]) : DateTime.now(),
      endingAt: jsonObject["endingAt"] != null ? DateTime.parse(jsonObject["endingAt"]) : DateTime.now(),
      store: jsonObject["store"] != null ? Store.fromJson(jsonObject: jsonObject["store"]) : Store(id: "", name: "", email: "",brand: Brand(),phone: "",piva: "", storeCategory: StoreCategory()),
      isHighlighted: bool.tryParse(jsonObject["isHighlighted"].toString()) ?? false,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'description': description,
      'ruleText': ruleText,
      'qty': qty,
      'imageUrl': imageUrl,
      'qtyPerUser': qtyPerUser,
      'store': store.toMap(),
      'isHighlighted': isHighlighted,
    };
  }
}
enum PromoStatus {
  pending,    // 0  "In attesa"
  approved,   // 1 "Approvato"
  notApproved // 2 "Non approvato"
}

extension PromoStatusExtension on PromoStatus {
  int get value {
    switch (this) {
      case PromoStatus.pending:
        return 0;
      case PromoStatus.approved:
        return 1;
      case PromoStatus.notApproved:
        return 2;
    }
  }

  static PromoStatus fromValue(int value) {
    switch (value) {
      case 0:
        return PromoStatus.pending;
      case 1:
        return PromoStatus.approved;
      case 2:
        return PromoStatus.notApproved;
      default:
        throw ArgumentError('Valore non valido per PromoStatus: $value');
    }
  }
}