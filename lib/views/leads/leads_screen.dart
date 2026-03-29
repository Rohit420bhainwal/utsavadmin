import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import 'leads_controller.dart';

class LeadsScreen extends StatelessWidget {
  LeadsScreen({super.key});

  final controller = Get.put(LeadsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leads"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchAllLeads(),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.leads.isEmpty) {
          return _emptyState(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.leads.length,
          itemBuilder: (context, index) {
            final lead = controller.leads[index];

            return InkWell(
              onTap: () {
                Get.toNamed(
                  AppRoutes.leadDetails,
                  arguments: lead.id,
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// 🔥 TOP ROW (TITLE + STATUS)
                      Row(
                        children: [
                          /// Service Icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.work_outline,
                                color: AppColors.primary, size: 18),
                          ),

                          const SizedBox(width: 10),

                          /// Title
                          Expanded(
                            child: Text(
                              lead.serviceTitle,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),

                          _statusChip(lead.status),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// CATEGORY
                      Row(
                        children: [
                          const Icon(Icons.category_outlined,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            lead.category,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// 👤 CUSTOMER + 🏢 VENDOR
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.person_outline, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    lead.customerName,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.business_outlined, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    lead.vendorName,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// 📅 EVENT INFO
                      Row(
                        children: [
                          const Icon(Icons.event, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            "${lead.eventType} • ${_formatDate(lead.eventDate)}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// 💰 + 👥 + 📍 (BETTER STRUCTURED)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoItem(Icons.group, "${lead.guestCount}",context),
                          _infoItem(Icons.currency_rupee, "${lead.budget}",context),
                          _infoItem(Icons.location_on_outlined, lead.city,context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// ❌ EMPTY STATE
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined,
              size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            "No Leads Found",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            "New leads will appear here",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  /// 🎯 STATUS CHIP (UPGRADED)
  Widget _statusChip(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case "new":
        color = Colors.blue;
        icon = Icons.fiber_new;
        break;
      case "contacted":
        color = Colors.orange;
        icon = Icons.call;
        break;
      case "converted":
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// ℹ️ SMALL INFO ITEM
  Widget _infoItem(IconData icon, String text, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textPrimary),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  /// 📅 FORMAT DATE
  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      return "${d.day}/${d.month}/${d.year}";
    } catch (e) {
      return date;
    }
  }
}