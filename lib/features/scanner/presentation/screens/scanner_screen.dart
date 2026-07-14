import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/providers/database_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/product_category.dart';
import '../../../../shared/widgets/voice_input_button.dart';
import '../../../../core/utils/scan_feedback.dart';
import '../../../pantry/presentation/widgets/add_pantry_item_sheet.dart';
import '../../../products/data/datasources/firestore_community_product_datasource.dart';
import '../../../products/data/datasources/product_mapper.dart';
import '../../../products/domain/models/product.dart';
import '../../data/datasources/plu_database.dart';
import '../../domain/models/scan_mode.dart';
import '../providers/scanner_providers.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  MobileScannerController? _controller;
  ScanMode _scanMode = ScanMode.barcode;
  bool _isProcessing = false;
  String _statusText = 'Scanning...';
  Product? _foundProduct;

  // Not-found overlay state
  bool _showNotFoundOverlay = false;
  String? _notFoundBarcode;
  bool _showingAddForm = false;
  bool _isSubmitting = false;
  final _communityNameController = TextEditingController();
  final _communityBrandController = TextEditingController();
  ProductCategory _selectedCategory = ProductCategory.other;
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  bool _reduceMotion = false;
  bool _reduceMotionChecked = false;

  // PLU mode
  final _pluController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    // Pulse animation is started in didChangeDependencies after reduce-motion check.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_reduceMotionChecked) {
      _reduceMotionChecked = true;
      _reduceMotion = MediaQuery.of(context).disableAnimations;
      if (!_reduceMotion) {
        _pulseController.repeat(reverse: true);
      }
    }
  }

  void _initCamera() {
    _controller?.dispose();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_scanMode != ScanMode.barcode) return;
    switch (state) {
      case AppLifecycleState.resumed:
        _controller?.start();
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _controller?.stop();
      default:
        break;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _pluController.dispose();
    _communityNameController.dispose();
    _communityBrandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen camera feed
          if (_scanMode == ScanMode.barcode && _controller != null)
            Positioned.fill(
              child: MobileScanner(
                controller: _controller!,
                onDetect: _onDetect,
              ),
            )
          else
            Positioned.fill(
              child: Container(color: Colors.black),
            ),

          // Dark overlay gradient for readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                  stops: const [0.0, 0.2, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // Scanning frame (just below mode picker)
          if (_scanMode == ScanMode.barcode)
            Positioned(
              top: MediaQuery.of(context).padding.top + 124,
              left: 0,
              right: 0,
              child: Center(
                child: _reduceMotion
                  ? Opacity(
                      opacity: 1.0,
                      child: SizedBox(
                        width: 296,
                        height: 176,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              left: 8,
                              top: 8,
                              right: 8,
                              bottom: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _isProcessing
                                        ? Colors.yellowAccent
                                        : AppColors.success,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            ..._buildCornerAccents(),
                          ],
                        ),
                      ),
                    )
                  : FadeTransition(
                      opacity: _pulseAnimation,
                      child: SizedBox(
                        width: 296,
                        height: 176,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              left: 8,
                              top: 8,
                              right: 8,
                              bottom: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _isProcessing
                                        ? Colors.yellowAccent
                                        : AppColors.success,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            ..._buildCornerAccents(),
                          ],
                        ),
                      ),
                    ),
              ),
            ),

          // Status pill (just below scan frame)
          if (_scanMode == ScanMode.barcode)
            Positioned(
              top: MediaQuery.of(context).padding.top + 124 + 176 + 4,
              left: 0,
              right: 0,
              child: Center(child: _buildStatusPill()),
            ),

          // Toolbar buttons
          if (_scanMode == ScanMode.barcode)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: _buildToolbar(),
            ),

          // PLU mode content
          if (_scanMode == ScanMode.plu)
            Positioned(
              top: MediaQuery.of(context).padding.top + 120,
              left: 16,
              right: 16,
              bottom: 20,
              child: _buildPluContent(),
            ),

          // Manual entry mode
          if (_scanMode == ScanMode.manual)
            Positioned(
              top: MediaQuery.of(context).padding.top + 120,
              left: 16,
              right: 16,
              bottom: 20,
              child: _buildManualContent(),
            ),

          // Scan mode selector (frosted glass pill)
          Positioned(
            top: MediaQuery.of(context).padding.top + 56,
            left: 24,
            right: 24,
            child: _buildModePicker(),
          ),

          // Top bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: _buildTopBar(),
          ),

          // Product found overlay
          if (_foundProduct != null) _buildProductFoundOverlay(),

          // Product not found overlay
          if (_showNotFoundOverlay) _buildProductNotFoundOverlay(),
        ],
      ),
    );
  }

  // ─── Top bar ─────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCircleButton(
          icon: Icons.arrow_back,
          onPressed: () => context.pop(),
        ),
        const Text(
          'Scanner',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 48), // balance the back button
      ],
    );
  }

  // ─── Mode picker (frosted glass segmented control) ───────────────────

  Widget _buildModePicker() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: ScanMode.values.map((mode) {
              final isSelected = mode == _scanMode;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _switchMode(mode),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.25)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      mode.displayName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ─── Status pill ─────────────────────────────────────────────────────

  Widget _buildStatusPill() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isProcessing)
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else if (_reduceMotion)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                )
              else
                FadeTransition(
                  opacity: _pulseAnimation,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                _statusText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Toolbar ─────────────────────────────────────────────────────────

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircleButton(
            icon: Icons.flashlight_on,
            onPressed: () => _controller?.toggleTorch(),
            tooltip: 'Flashlight',
          ),
          _buildCircleButton(
            icon: Icons.eco,
            onPressed: () => _switchMode(ScanMode.plu),
            tooltip: 'Produce',
          ),
          _buildCircleButton(
            icon: Icons.kitchen,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => const AddPantryItemSheet(),
              );
            },
            tooltip: 'Add to Pantry',
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
    bool isActive = false,
  }) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: isActive
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.15),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }

  // ─── PLU content ─────────────────────────────────────────────────────

  Widget _buildPluContent() {
    final pluResults = ref.watch(pluSearchResultsProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _pluController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Enter PLU code or search...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    prefixIcon:
                        const Icon(Icons.dialpad, color: Colors.white70),
                    suffixIcon: VoiceInputButton(
                      controller: _pluController,
                      color: Colors.white70,
                      activeColor: AppColors.coral,
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    ref.read(pluSearchQueryProvider.notifier).state = value;
                  },
                  onSubmitted: _lookupPlu,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: pluResults.length,
                  itemBuilder: (context, index) {
                    final entry = pluResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.15),
                        child: Text(
                          entry.code,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      title: Text(
                        entry.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: entry.isOrganic
                          ? const Text(
                              'Organic',
                              style: TextStyle(color: AppColors.success),
                            )
                          : null,
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: AppColors.success,
                        ),
                        onPressed: () => _addPluToPantry(entry),
                      ),
                      onTap: () => _addPluToPantry(entry),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Manual entry content ────────────────────────────────────────────

  Widget _buildManualContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Manual Entry',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add items directly to your pantry.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAction(
                    icon: Icons.qr_code,
                    label: 'Scan\nBarcode',
                    onTap: () => _switchMode(ScanMode.barcode),
                  ),
                  _buildQuickAction(
                    icon: Icons.kitchen,
                    label: 'Add to\nPantry',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (_) => const AddPantryItemSheet(),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.eco,
                    label: 'Produce\n(PLU)',
                    onTap: () => _switchMode(ScanMode.plu),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Corner accents for scan frame ───────────────────────────────────

  List<Widget> _buildCornerAccents() {
    const color = AppColors.success;
    const length = 24.0;
    const thickness = 4.0;

    return [
      // Top-left
      Positioned(
        top: 0,
        left: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: length, height: thickness, color: color),
            Container(
                width: thickness, height: length - thickness, color: color),
          ],
        ),
      ),
      // Top-right
      Positioned(
        top: 0,
        right: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(width: length, height: thickness, color: color),
            Container(
                width: thickness, height: length - thickness, color: color),
          ],
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: 0,
        left: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: thickness, height: length - thickness, color: color),
            Container(width: length, height: thickness, color: color),
          ],
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: 0,
        right: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                width: thickness, height: length - thickness, color: color),
            Container(width: length, height: thickness, color: color),
          ],
        ),
      ),
    ];
  }

  // ─── Product found overlay ───────────────────────────────────────────

  Widget _buildProductFoundOverlay() {
    final product = _foundProduct!;

    return Positioned.fill(
      child: GestureDetector(
        onTap: _dismissProductOverlay,
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // absorb taps on the card itself
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Close button
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: _dismissProductOverlay,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                            // Product image or category icon
                            if (product.imageUrl != null &&
                                product.imageUrl!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: product.imageUrl!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  placeholder: (_, _) => Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.white38,
                                      size: 32,
                                    ),
                                  ),
                                  errorWidget: (_, _, _) =>
                                      _buildCategoryAvatar(product),
                                ),
                              )
                            else
                              _buildCategoryAvatar(product),
                            const SizedBox(height: 14),

                            // Product name
                            Text(
                              product.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // Brand subtitle
                            if (product.brand != null &&
                                product.brand!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                product.brand!,
                                style: TextStyle(
                                  color:
                                      Colors.white.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],

                            const SizedBox(height: 10),

                            // Category chip + price
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                        .withValues(alpha: 0.12),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    product.category.displayName,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (product.price != null) ...[
                                  const SizedBox(width: 10),
                                  Text(
                                    '\$${product.price!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: AppColors.success,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _OverlayIconAction(
                                  icon: product.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  label: 'Favorite',
                                  color: product.isFavorite
                                      ? Colors.red
                                      : Colors.white70,
                                  onTap: () =>
                                      _toggleFavorite(product),
                                ),
                                const SizedBox(width: 24),
                                _OverlayIconAction(
                                  icon: Icons.info_outline,
                                  label: 'Details',
                                  color: Colors.white70,
                                  onTap: () =>
                                      _viewProductDetails(product),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Primary action: Add to Pantry
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _showAddToPantrySheet(product),
                                icon: const Icon(Icons.kitchen,
                                    size: 18),
                                label: const Text(
                                  'Add to Pantry',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.coral,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Product not found overlay ─────────────────────────────────────

  Widget _buildProductNotFoundOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _dismissNotFoundOverlay,
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // absorb taps on the card
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: _showingAddForm
                            ? _buildAddProductForm()
                            : _buildNotFoundPrompt(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotFoundPrompt() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Close button
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: _dismissNotFoundOverlay,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white70,
                size: 16,
              ),
            ),
          ),
        ),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.search_off,
            color: Colors.white70,
            size: 32,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Product Not Found',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Barcode $_notFoundBarcode wasn\'t found in any database. '
          'You can help by adding its info for future scans.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showingAddForm = true;
                _communityNameController.clear();
                _communityBrandController.clear();
                _selectedCategory = ProductCategory.other;
              });
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text(
              'Add Product Info',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: _dismissNotFoundOverlay,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddProductForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _notFoundBarcode ?? '',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _communityNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Product Name *',
              labelStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Product name is required';
              }
              if (value.trim().length > 200) {
                return 'Name must be 200 characters or less';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _communityBrandController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Brand (optional)',
              labelStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ProductCategory>(
            value: _selectedCategory,
            dropdownColor: const Color(0xFF2A2A2A),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: ProductCategory.values.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text('${cat.emoji} ${cat.displayName}'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitCommunityProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coral,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _isSubmitting
                ? null
                : () => setState(() => _showingAddForm = false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitCommunityProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final barcode = _notFoundBarcode!;
      final name = _communityNameController.text.trim();
      final brand = _communityBrandController.text.trim();
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

      // Write to Firestore (transaction prevents duplicates)
      final datasource = ref.read(firestoreCommunityProductDatasourceProvider);
      final existing = await datasource.addProduct(
        barcode: barcode,
        name: name,
        brand: brand.isNotEmpty ? brand : null,
        category: _selectedCategory.name,
        contributedBy: uid,
      );

      // Use existing product if the barcode was already contributed
      final communityProduct = existing ??
          CommunityProduct(
            barcode: barcode,
            name: name,
            brand: brand.isNotEmpty ? brand : null,
            category: _selectedCategory.name,
            contributedBy: uid,
          );

      // Create domain Product and save locally
      final product =
          ProductMapper.fromCommunityProduct(communityProduct);
      final repo = ref.read(productRepositoryProvider);
      await repo.saveProduct(product);

      if (!mounted) return;

      // Transition to the product-found overlay
      setState(() {
        _showNotFoundOverlay = false;
        _notFoundBarcode = null;
        _showingAddForm = false;
        _isSubmitting = false;
        _foundProduct = product;
        _statusText = '${product.name} added';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save product: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _dismissNotFoundOverlay() {
    setState(() {
      _showNotFoundOverlay = false;
      _notFoundBarcode = null;
      _showingAddForm = false;
    });
    _controller?.start();
    _resetScanning();
  }

  Widget _buildCategoryAvatar(Product product) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _categoryIcon(product.category.name),
        color: Colors.white70,
        size: 36,
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'produce':
        return Icons.eco;
      case 'dairy':
        return Icons.water_drop;
      case 'meat':
        return Icons.restaurant;
      case 'bakery':
        return Icons.bakery_dining;
      case 'frozen':
        return Icons.ac_unit;
      case 'beverages':
        return Icons.local_drink;
      case 'snacks':
        return Icons.cookie;
      case 'household':
        return Icons.cleaning_services;
      case 'healthBeauty':
        return Icons.spa;
      default:
        return Icons.shopping_bag;
    }
  }

  // ─── Actions ─────────────────────────────────────────────────────────

  void _switchMode(ScanMode mode) {
    setState(() {
      _scanMode = mode;
      if (mode == ScanMode.barcode) {
        _statusText = 'Scanning...';
      }
    });
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null) return;

    playScanFeedback(sound: true, haptic: true);

    if (!_reduceMotion) _pulseController.stop();
    setState(() {
      _isProcessing = true;
      _statusText = 'Looking up ${barcode.rawValue}...';
    });

    try {
      final repo = ref.read(productRepositoryProvider);
      final result = await repo.lookupProduct(barcode.rawValue!);

      if (!mounted) return;

      result.when(
        success: (product) {
          // Record scan to history
          ref.read(scanHistoryDaoProvider).insertEntry(
                db.ScanHistoryEntriesCompanion(
                  id: drift.Value(
                      '${barcode.rawValue}_${DateTime.now().millisecondsSinceEpoch}'),
                  barcode: drift.Value(barcode.rawValue!),
                  scanType: const drift.Value('barcode'),
                  timestamp: drift.Value(DateTime.now()),
                  productId: drift.Value(product.id),
                ),
              );

          _controller?.stop();
          if (!_reduceMotion) _pulseController.repeat(reverse: true);

          setState(() {
            _isProcessing = false;
            _statusText = '${product.name} found';
            _foundProduct = product;
          });
        },
        failure: (msg, _) {
          // Record failed scan
          ref.read(scanHistoryDaoProvider).insertEntry(
                db.ScanHistoryEntriesCompanion(
                  id: drift.Value(
                      '${barcode.rawValue}_${DateTime.now().millisecondsSinceEpoch}'),
                  barcode: drift.Value(barcode.rawValue!),
                  scanType: const drift.Value('barcode'),
                  timestamp: drift.Value(DateTime.now()),
                  errorMessage: drift.Value(msg),
                ),
              );

          _controller?.stop();
          if (!_reduceMotion) _pulseController.repeat(reverse: true);
          setState(() {
            _isProcessing = false;
            _statusText = 'Not found';
            _showNotFoundOverlay = true;
            _notFoundBarcode = barcode.rawValue;
            _showingAddForm = false;
          });
        },
      );
    } catch (e) {
      if (mounted) {
        if (!_reduceMotion) _pulseController.repeat(reverse: true);
        setState(() {
          _isProcessing = false;
          _statusText = 'Error — try again';
        });
        _scheduleScanReset();
      }
    }
  }

  void _dismissProductOverlay() {
    setState(() {
      _foundProduct = null;
    });
    _controller?.start();
    _resetScanning();
  }

  void _resetScanning() {
    if (!_reduceMotion) _pulseController.repeat(reverse: true);
    setState(() {
      _isProcessing = false;
      _statusText = 'Scanning...';
    });
  }

  void _scheduleScanReset() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _resetScanning();
    });
  }

  void _toggleFavorite(Product product) {
    final newValue = !product.isFavorite;
    ref.read(productDaoProvider).toggleFavorite(product.id, newValue);
    setState(() {
      _foundProduct = product.copyWith(isFavorite: newValue);
    });
  }

  void _viewProductDetails(Product product) {
    setState(() => _foundProduct = null);
    _controller?.stop();
    context.push('/products/${product.id}').then((_) {
      if (mounted) {
        _controller?.start();
        _resetScanning();
      }
    });
  }

  void _showAddToPantrySheet(Product product) {
    _dismissProductOverlay();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => AddPantryItemSheet(
        initialName: product.name,
        initialCategory: product.category.name,
        initialProductId: product.id,
        initialPrice: product.price,
      ),
    );
  }

  void _lookupPlu(String code) {
    final pluDb = ref.read(pluDatabaseProvider);
    final entry = pluDb.lookup(code.trim());
    if (entry != null) {
      pluDb.trackRecent(entry.code);
      _addPluToPantry(entry);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PLU code "$code" not found'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _addPluToPantry(PluEntry entry) {
    final pluDb = ref.read(pluDatabaseProvider);
    pluDb.trackRecent(entry.code);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AddPantryItemSheet(
        initialName: entry.name,
        initialCategory: entry.inferredCategory.name,
      ),
    );
  }
}

/// Compact icon + label button used in the product overlay.
class _OverlayIconAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OverlayIconAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
