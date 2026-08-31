import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:utsavadmin/views/vendors/add_vendor_service_screen.dart';
import '../../utils/app_colors.dart';
import 'edit_vendor_screen.dart';
import 'vendor_details_controller.dart';

class VendorDetailsScreen extends StatelessWidget {
  VendorDetailsScreen({super.key});

  final controller = Get.put(
    VendorDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        title: Obx(
              () => Text(
            controller.vendor["businessName"] ?? "Vendor Details",
          ),
        ),
        centerTitle: true,

        actions: [
          // =================================================
          // EDIT VENDOR
          // =================================================

          IconButton(
            tooltip: "Edit Vendor",
            icon: const Icon(
              Icons.edit_outlined,
            ),
            onPressed: () async {
              final result = await Get.to(
                    () => EditVendorScreen(),
                arguments: Map<String, dynamic>.from(
                  controller.vendor,
                ),
              );

              if (result != null && result is Map) {
                controller.updateVendorData(
                  Map<String, dynamic>.from(
                    result,
                  ),
                );
              }
            },
          ),
        ],
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: Obx(
            () {
          // =================================================
          // LOADING
          // =================================================

          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // =================================================
          // CONTENT
          // =================================================

          return RefreshIndicator(
            onRefresh: controller.refreshServices,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              // Bottom padding is kept so the last service
              // has comfortable spacing above bottom button.
              padding: const EdgeInsets.fromLTRB(
                14,
                14,
                14,
                20,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================================
                  // VENDOR HEADER
                  // =========================================

                  _vendorHeader(
                    controller.vendor,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // =========================================
                  // SERVICES HEADER
                  // =========================================

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Services",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium,
                      ),

                      Text(
                        "${controller.services.length} items",
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // =========================================
                  // SERVICES LIST
                  // =========================================

                  controller.services.isEmpty
                      ? _emptyServices()
                      : Column(
                    children: controller.services
                        .map(
                          (service) => _serviceCard(
                        service,
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // =====================================================
      // ADD SERVICE BUTTON
      //
      // Using bottomNavigationBar instead of FAB prevents
      // the button from overlapping the last service card.
      // =====================================================

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            14,
            10,
            14,
            10,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(
                  0,
                  -2,
                ),
              ),
            ],
          ),
          child: SizedBox(
            height: 54,
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              // ===========================================
              // ADD SERVICE ACTION
              // ===========================================

              onPressed: () async {
                await Get.to(
                      () => AddVendorServiceScreen(),
                  arguments: {
                    "vendor": controller.vendor,
                    "service": null,
                  },
                );

                // =========================================
                // REFRESH AFTER ADDING SERVICE
                // =========================================

                controller.fetchVendorServices();
              },

              icon: const Icon(
                Icons.add,
                size: 24,
              ),

              label: const Text(
                "Add Service",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =======================================================
  // VENDOR HEADER
  // =======================================================

  Widget _vendorHeader(
      dynamic vendor,
      ) {
    final bool isActive = vendor["isActive"] == true;

    return Container(
      padding: const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.gradientStart,
            AppColors.gradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(
          16,
        ),
      ),
      child: Column(
        children: [
          // ===============================================
          // VENDOR INFORMATION
          // ===============================================

          Row(
            children: [
              // =========================================
              // AVATAR
              // =========================================

              Container(
                padding: const EdgeInsets.all(
                  14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.store,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // =========================================
              // VENDOR INFO
              // =========================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // ===================================
                    // BUSINESS NAME
                    // ===================================

                    Text(
                      vendor["businessName"] ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    // ===================================
                    // DESCRIPTION
                    // ===================================

                    if (vendor["description"] != null &&
                        vendor["description"]
                            .toString()
                            .isNotEmpty)
                      Text(
                        vendor["description"].toString(),
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),

                    const SizedBox(
                      height: 8,
                    ),

                    // ===================================
                    // LOCATION
                    // ===================================

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.white,
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        Expanded(
                          child: Text(
                            "${vendor["city"] ?? ""}, "
                                "${vendor["state"] ?? ""}",
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          // ===============================================
          // DIVIDER
          // ===============================================

          Container(
            height: 1,
            color: Colors.white.withOpacity(
              0.2,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // ===============================================
          // VENDOR STATUS
          // ===============================================

          Row(
            children: [
              // =========================================
              // STATUS ICON
              // =========================================

              Container(
                padding: const EdgeInsets.all(
                  7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.15,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isActive
                      ? Icons.check_circle
                      : Icons.cancel,
                  size: 18,
                  color: isActive
                      ? Colors.greenAccent
                      : Colors.redAccent,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              // =========================================
              // STATUS TEXT
              // =========================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      isActive
                          ? "Vendor Active"
                          : "Vendor Inactive",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      isActive
                          ? "Vendor is visible and active"
                          : "All vendor services are inactive",
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(
                          0.75,
                        ),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // =========================================
              // VENDOR STATUS LOADING
              // =========================================

              if (controller
                  .isUpdatingVendorStatus
                  .value)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else

              // =======================================
              // VENDOR SWITCH
              // =======================================

                Switch(
                  value: isActive,
                  activeColor: Colors.white,
                  activeTrackColor:
                  Colors.green,
                  inactiveThumbColor:
                  Colors.white,
                  inactiveTrackColor:
                  Colors.red.withOpacity(
                    0.7,
                  ),
                  onChanged: (value) {
                    _showVendorStatusConfirmation(
                      value,
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  // =======================================================
  // VENDOR STATUS CONFIRMATION
  // =======================================================

// =======================================================
// VENDOR STATUS CONFIRMATION
//
// Professional custom confirmation dialog
// =======================================================

  void _showVendorStatusConfirmation(
      bool newStatus,
      ) {
    final bool isActivating = newStatus;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 28,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              24,
              24,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =================================================
                // STATUS ICON
                // =================================================

                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isActivating
                        ? Colors.green.withOpacity(0.10)
                        : Colors.red.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isActivating
                        ? Icons.store_mall_directory_outlined
                        : Icons.store_mall_directory_outlined,
                    size: 32,
                    color: isActivating
                        ? Colors.green
                        : Colors.red,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                // =================================================
                // TITLE
                // =================================================

                Text(
                  isActivating
                      ? "Activate Vendor"
                      : "Deactivate Vendor",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // =================================================
                // DESCRIPTION
                // =================================================

                Text(
                  isActivating
                      ? "The vendor will become visible and active. "
                      "All services will remain inactive until you "
                      "activate them individually."
                      : "This will make the vendor inactive and "
                      "automatically deactivate all of its services.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                // =================================================
                // WARNING / INFORMATION BOX
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isActivating
                        ? Colors.green.withOpacity(0.06)
                        : Colors.red.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActivating
                          ? Colors.green.withOpacity(0.15)
                          : Colors.red.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isActivating
                            ? Icons.info_outline
                            : Icons.warning_amber_rounded,
                        size: 20,
                        color: isActivating
                            ? Colors.green
                            : Colors.red,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: Text(
                          isActivating
                              ? "You can activate individual services "
                              "after activating the vendor."
                              : "All currently active services will "
                              "also be deactivated.",
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                            color: isActivating
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 22,
                ),

                // =================================================
                // ACTION BUTTONS
                // =================================================

                Row(
                  children: [
                    // =============================================
                    // CANCEL
                    // =============================================

                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                            const Color(0xFF4B5563),
                            side: const BorderSide(
                              color: Color(0xFFD1D5DB),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    // =============================================
                    // CONFIRM
                    // =============================================

                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isActivating
                                ? Colors.green
                                : Colors.red,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.back();

                            controller.updateVendorStatus(
                              newStatus,
                            );
                          },
                          child: Text(
                            isActivating
                                ? "Activate"
                                : "Deactivate",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  // =======================================================
  // EMPTY SERVICES
  // =======================================================

  Widget _emptyServices() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 70,
              color: Colors.grey.shade400,
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              "No Services Added",
            ),

            const SizedBox(
              height: 4,
            ),

            const Text(
              "This vendor has no services yet",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =======================================================
  // SERVICE CARD
  // =======================================================

  Widget _serviceCard(
      dynamic service,
      ) {
    final bool isActive =
        service["isActive"] == true;

    final bool isUpdating =
    controller.isUpdatingService(
      service,
    );

    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          18,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          18,
        ),

        // ===============================================
        // EDIT SERVICE
        // ===============================================

        onTap: isUpdating
            ? null
            : () async {
          await Get.to(
                () => AddVendorServiceScreen(),
            arguments: {
              "vendor":
              controller.vendor,
              "service": service,
            },
          );

          // =====================================
          // REFRESH AFTER EDIT
          // =====================================

          controller.fetchVendorServices();
        },

        child: Padding(
          padding: const EdgeInsets.all(
            14,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =========================================
              // TITLE + PRICE
              // =========================================

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // ===================================
                  // SERVICE ICON
                  // ===================================

                  Icon(
                    Icons.miscellaneous_services,
                    size: 22,
                    color: isActive
                        ? AppColors.primary
                        : Colors.grey,
                  ),

                  const SizedBox(
                    width: 7,
                  ),

                  // ===================================
                  // TITLE
                  // ===================================

                  Expanded(
                    child: Text(
                      service["title"] ??
                          "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w600,
                        color: isActive
                            ? AppColors
                            .textPrimary
                            : Colors
                            .grey
                            .shade600,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  // ===================================
                  // PRICE
                  // ===================================

                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration:
                    BoxDecoration(
                      color: isActive
                          ? AppColors
                          .primary
                          .withOpacity(
                        0.1,
                      )
                          : Colors.grey
                          .withOpacity(
                        0.1,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Text(
                      "₹${service["price"] ?? 0}",
                      style: TextStyle(
                        color: isActive
                            ? AppColors
                            .primary
                            : Colors
                            .grey
                            .shade600,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              // =========================================
              // DESCRIPTION
              // =========================================

              Text(
                service["description"] ??
                    "",
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: isActive
                      ? AppColors
                      .textPrimary
                      : Colors.grey
                      .shade500,
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              // =========================================
              // STATUS + SWITCH
              // =========================================

              Row(
                children: [
                  // ===================================
                  // STATUS ICON
                  // ===================================

                  Icon(
                    isActive
                        ? Icons.check_circle
                        : Icons.cancel,
                    size: 18,
                    color: isActive
                        ? Colors.green
                        : Colors.red,
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  // ===================================
                  // STATUS TEXT
                  // ===================================

                  Expanded(
                    child: Text(
                      isActive
                          ? "Active"
                          : "Inactive",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w600,
                        color: isActive
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),

                  // ===================================
                  // SERVICE LOADING
                  // ===================================

                  if (isUpdating)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  else

                  // =================================
                  // SERVICE SWITCH
                  // =================================

                    Switch(
                      value: isActive,
                      onChanged: (value) {
                        controller
                            .updateServiceStatus(
                          service,
                          value,
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}