import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import 'lead_details_controller.dart';

class LeadDetailsScreen extends StatelessWidget {
  final String leadId;

  const LeadDetailsScreen({super.key, required this.leadId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeadDetailsController(leadId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lead Details"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final lead = controller.lead.value;

        if (lead == null) {
          return const Center(child: Text("No Data Found"));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            14,
            14,
            14,
            30 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 HEADER
              _heroHeader(lead),

              const SizedBox(height: 18),

              /// 👤 CUSTOMER
              _infoCard(
                title: "Customer Details",
                icon: Icons.person_outline,
                children: [
                  _tile(Icons.person, lead["customer"]["userId"]["name"]),
                  _tile(Icons.email, lead["customer"]["userId"]["email"]),
                  _tile(Icons.phone, lead["customer"]["userId"]["phone"] ?? "-"),
                ],
              ),

              /// 🏢 VENDOR
              _infoCard(
                title: "Vendor Details",
                icon: Icons.business_outlined,
                children: [
                  _tile(Icons.store, lead["vendorId"]["businessName"]),
                  _tile(Icons.location_on, lead["vendorId"]["city"]),
                ],
              ),

              /// 📅 EVENT
              _infoCard(
                title: "Event Information",
                icon: Icons.event,
                children: [
                  _tile(Icons.celebration, lead["eventDetails"]["eventType"]),
                  _tile(Icons.calendar_today,
                      _formatDate(lead["eventDetails"]["eventDate"])),
                  _tile(Icons.groups,
                      "${lead["eventDetails"]["guestCount"]} Guests"),
                  _tile(Icons.currency_rupee,
                      lead["eventDetails"]["budget"]),
                  _tile(Icons.location_city,
                      lead["eventDetails"]["city"]),
                ],
              ),

              /// 💬 MESSAGE
              _infoCard(
                title: "Customer Message",
                icon: Icons.message_outlined,
                children: [
                  Text(
                    lead["message"] ?? "No message provided",
                    style: TextStyle(
                      color: AppColors.textPrimary, // ✅ BLACK
                      height: 1.5,
                    ),
                  ),
                ],
              ),

              /// 🔄 STATUS
              _infoCard(
                title: "Update Status",
                icon: Icons.sync,
                children: [
                  DropdownButtonFormField<String>(
                    value: lead["status"],
                    style: TextStyle(
                      color: AppColors.textPrimary, // ✅ BLACK TEXT
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.flag),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: ["new", "contacted", "converted", "closed"]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.textPrimary, // ✅ BLACK
                        ),
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateStatus(value);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  /// 🔥 HEADER
  Widget _heroHeader(dynamic lead) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Expanded(
                child: Text(
                  lead["service"]["title"] ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _statusChip(lead["status"]),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.event, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                "${lead["eventDetails"]["eventType"]} • ${_formatDate(lead["eventDetails"]["eventDate"])}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                lead["eventDetails"]["city"],
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 CARD
  Widget _infoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary, // ✅ BLACK
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  /// 🔹 TILE
  Widget _tile(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textPrimary, // ✅ BLACK
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;

    switch (status) {
      case "new":
        color = Colors.blue;
        break;
      case "contacted":
        color = Colors.orange;
        break;
      case "converted":
        color = Colors.green;
        break;
      case "closed":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      return "${d.day}/${d.month}/${d.year}";
    } catch (e) {
      return date;
    }
  }
}