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
                  _tile(Icons.person, _safe(lead["customer"]?["userId"]?["name"])),
                  _tile(Icons.email, _safe(lead["customer"]?["userId"]?["email"])),
                  _tile(Icons.phone, _safe(lead["customer"]?["userId"]?["phone"])),
                ],
              ),

              /// 🏢 VENDOR
              _infoCard(
                title: "Vendor Details",
                icon: Icons.business_outlined,
                children: [
                  _tile(Icons.store, _safe(lead["vendorId"]?["businessName"])),
                  _tile(Icons.location_on, _safe(lead["vendorId"]?["city"])),
                ],
              ),

              /// 📅 EVENT
              _infoCard(
                title: "Event Information",
                icon: Icons.event,
                children: [
                  _tile(Icons.celebration, _safe(lead["eventDetails"]?["eventType"])),
                  _tile(Icons.calendar_today,
                      _formatDate(lead["eventDetails"]?["eventDate"])),
                  _tile(Icons.groups,
                      "${lead["eventDetails"]?["guestCount"] ?? 0} Guests"),
                  _tile(Icons.currency_rupee,
                      _safe(lead["eventDetails"]?["budget"])),
                  _tile(Icons.location_city,
                      _safe(lead["eventDetails"]?["city"])),
                ],
              ),

              /// 💬 MESSAGE
 /*             _infoCard(
                title: "Customer Message",
                icon: Icons.message_outlined,
                children: [
                  Text(
                    _safe(lead["message"], fallback: "No message provided"),
                    style: const TextStyle(height: 1.5),
                  ),
                ],
              ),*/

              /// 📝 NOTES
              _infoCard(
                title: "Lead Notes",
                icon: Icons.note_alt_outlined,
                children: [

                  /// 🔥 ADD NOTE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showAddNoteDialog(context, controller);
                      },
                      icon: const Icon(Icons.add,color: Colors.white,),
                      label: const Text("Add Note"),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔥 NOTES LIST
                  Obx(() {
                    if (controller.notes.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text("No notes added yet"),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: controller.notes.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final note = controller.notes[index];

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                note["note"] ?? "",
                                style: const TextStyle(
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.grey,
                                  ),

                                  const SizedBox(width: 5),

                                  Text(
                                    _formatDate(note["createdAt"]),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),

              /// 🔄 STATUS
              _infoCard(
                title: "Update Status",
                icon: Icons.sync,
                children: [
                  DropdownButtonFormField<String>(
                    value: lead["status"] ?? "new",
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
                      child: Text(e.toUpperCase()),
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

  /// 🔥 SAFE VALUE HANDLER
  String _safe(dynamic value, {String fallback = "-"}) {
    if (value == null) return fallback;
    if (value.toString().trim().isEmpty) return fallback;
    return value.toString();
  }

  /// 🔥 DATE FORMATTER
  static String _formatDate(dynamic date) {
    if (date == null || date.toString().isEmpty) return "-";

    try {
      final d = DateTime.parse(date.toString());
      return "${d.day}/${d.month}/${d.year}";
    } catch (e) {
      return "-";
    }
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
                  _safe(lead["service"]?["title"]),
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

          Text(
            "${_safe(lead["eventDetails"]?["eventType"])} • ${_formatDate(lead["eventDetails"]?["eventDate"])}",
            style: const TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 6),

          Text(
            _safe(lead["eventDetails"]?["city"]),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(
      BuildContext context,
      LeadDetailsController controller,
      ) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Add Note",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: controller.noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write note here...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.addNote,
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
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
                style: const TextStyle(fontWeight: FontWeight.w600),
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
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _statusChip(String? status) {
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
        (status ?? "unknown").toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}