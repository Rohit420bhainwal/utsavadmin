class LeadModel {
  final String id;
  final String serviceTitle;
  final String category;
  final String customerName;
  final String vendorName;
  final String eventType;
  final String eventDate;
  final int guestCount;
  final String budget;
  final String city;
  final String status;

  LeadModel({
    required this.id,
    required this.serviceTitle,
    required this.category,
    required this.customerName,
    required this.vendorName,
    required this.eventType,
    required this.eventDate,
    required this.guestCount,
    required this.budget,
    required this.city,
    required this.status,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json["_id"] ?? "",

      serviceTitle: json["service"]?["title"] ?? "",
      category: json["service"]?["categoryName"] ?? "",

      /// 🔥 FIX HERE
      customerName: json["customer"]?["userId"]?["name"] ?? "Unknown",

      /// 🔥 FIX HERE
      vendorName: json["vendorId"]?["businessName"] ?? "",

      eventType: json["eventDetails"]?["eventType"] ?? "",
      eventDate: json["eventDetails"]?["eventDate"] ?? "",

      guestCount: json["eventDetails"]?["guestCount"] ?? 0,
      budget: json["eventDetails"]?["budget"] ?? "",

      /// 🔥 CITY FIX (take from eventDetails first)
      city: json["eventDetails"]?["city"] ??
          json["service"]?["city"] ??
          "",

      status: json["status"] ?? "new",
    );
  }
}