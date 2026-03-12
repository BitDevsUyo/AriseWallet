import 'package:bitdevs_project/theme/colors.dart';
import 'package:flutter/material.dart';

void showNetworkToast(BuildContext context, NetworkToastType type) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _NetworkToast(
      type: type,
      onDismiss: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
  Future.delayed(const Duration(seconds: 3), () {
    if (entry.mounted) entry.remove();
  });
}

enum NetworkToastType { noConnection, weakConnection }
class _NetworkToast extends StatefulWidget {
  final NetworkToastType type;
  final VoidCallback onDismiss;

  const _NetworkToast({required this.type, required this.onDismiss});

  @override
  State<_NetworkToast> createState() => _NetworkToastState();
}

class _NetworkToastState extends State<_NetworkToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNoConnection = widget.type == NetworkToastType.noConnection;
    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isNoConnection
                    ? const Color(0xFF1C1C1C)
                    : const Color(0xFF2C2000),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isNoConnection ? kredcolor : korangeColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isNoConnection
                          ?kredcolor.withOpacity(0.15)
                          : korangeColor.withOpacity(0.15),
                    ),
                    child: Icon(
                      isNoConnection ? Icons.wifi_off_rounded : Icons.wifi_rounded,
                      color: isNoConnection ? kredcolor : korangeColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isNoConnection
                              ? 'No Internet Connection'
                              : 'Weak Connection',
                          style: TextStyle(
                            color: kwhitecolors,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Aeonik",
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isNoConnection
                              ? 'Please check your network and try again'
                              : 'Your connection is slow, sync may take longer',
                          style: TextStyle(
                            color:kgraycolor.withOpacity(0.5),
                            fontSize: 12,
                            fontFamily: "Aeonik",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}