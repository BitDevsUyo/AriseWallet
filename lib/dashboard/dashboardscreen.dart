import 'dart:convert';
import 'dart:math';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:bitdevs_project/core/networktoast.dart';
import 'package:bitdevs_project/core/reusable.dart';
import 'package:bitdevs_project/customutils/customitems.dart';
import 'package:bitdevs_project/onboarding/statemanagement/wallet_controller.dart';
import 'package:bitdevs_project/services/network_services.dart';
import 'package:bitdevs_project/theme/colors.dart';
import 'package:bitdevs_project/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double? _btcPriceUsd;
  bool _loadingPrice = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _fetchBtcPrice();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletProvider = Provider.of<WalletProvider>(
        context,
        listen: false,
      );
      if (walletProvider.walletData == null) {
        walletProvider.syncWallet(network: Network.testnet);
      }
    });
  }

  Future<void> _fetchBtcPrice() async {
    setState(() => _loadingPrice = true);
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _btcPriceUsd = (data['bitcoin']['usd'] as num).toDouble();
          _loadingPrice = false;
        });
      }
    } catch (e) {
      setState(() {
        _loadingPrice = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    final networkStatus = await NetworkService().checkNetworkStrength();
    if (networkStatus == NetworkStatus.noConnection) {
      showNetworkToast(context, NetworkToastType.noConnection);
      return;
    }
    if (networkStatus == NetworkStatus.weak) {
      showNetworkToast(context, NetworkToastType.weakConnection);
    }
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    await walletProvider.syncWallet(network: Network.testnet);
    await _fetchBtcPrice();
  }

  String _satsToBtc(String sats) {
    final value = BigInt.tryParse(sats) ?? BigInt.zero;
    final btc = value / BigInt.from(100000000);
    return btc.toStringAsFixed(8);
  }

  String _satsToUsd(String sats) {
    if (_btcPriceUsd == null) return '...';
    final value = BigInt.tryParse(sats) ?? BigInt.zero;
    final btc = value.toDouble() / 100000000;
    final usd = btc * _btcPriceUsd!;
    return usd.toStringAsFixed(2);
  }

  Future<void> _switchAndSync(String walletId) async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    setState(() => _isSyncing = true);
    try {
      await walletProvider.switchWallet(walletId: walletId);
      await walletProvider.syncWallet(network: Network.testnet);
      await _fetchBtcPrice();
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  void _showWalletSwitcher(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: kdarkgraycolor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: kgraycolor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'My Wallets',
                  style: TextStyle(
                    color: kwhitecolors,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Aeonik",
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: walletProvider.walletList.length,
                  itemBuilder: (context, index) {
                    final wallet = walletProvider.walletList[index];
                    final walletName = wallet['name'] as String? ?? 'Wallet';
                    final walletId = wallet['id'] as String;
                    final isActive = walletId == walletProvider.walletData?.Id;
                    final parts = walletName.trim().split(' ');
                    final initials = parts.length >= 2
                        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
                        : walletName
                              .substring(0, min(2, walletName.length))
                              .toUpperCase();

                    return ListTile(
                      onTap: () async {
                        if (!isActive) {
                          Navigator.pop(sheetContext);
                          await _switchAndSync(walletId);
                        }
                      },
                      leading: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? korangeColor : kgraycolor,
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: kwhitecolors,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: "Aeonik",
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        walletName,
                        style: TextStyle(
                          color: kwhitecolors,
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontFamily: "Aeonik",
                        ),
                      ),
                      trailing: isActive
                          ? Icon(Icons.check_circle, color: korangeColor)
                          : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final walletProvider = Provider.of<WalletProvider>(context);
    final walletData = walletProvider.walletData;

    String initials = '';
    if (walletData?.walletName != null && walletData!.walletName.isNotEmpty) {
      final parts = walletData.walletName.trim().split(' ');
      initials = parts.length >= 2
          ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
          : walletData.walletName.substring(0, 2).toUpperCase();
    }
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            color: korangeColor,
            backgroundColor: theme.colorScheme.background,
            onRefresh: _onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      customContainer(
                        70,
                        size.width,
                        BoxDecoration(color: theme.colorScheme.background),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: korangeColor,
                                ),
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: TextStyle(
                                      color: kwhitecolors,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: "Aeonik",
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _showWalletSwitcher(context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        walletData?.walletName ?? 'Main Wallet',
                                        style: TextStyle(
                                          color: theme
                                              .colorScheme
                                              .primaryContainer,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Aeonik",
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color:
                                            theme.colorScheme.primaryContainer,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.more_vert,
                                  color: theme.colorScheme.primaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          '₿${_satsToBtc(walletData?.total_balance ?? '0')}',
                          style: TextStyle(
                            color: theme.colorScheme.primaryContainer,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Aeonik",
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Center(
                        child: _loadingPrice
                            ? ShimmerBox(height: 45, width: 200)
                            : Text(
                                '≈ \$${_satsToUsd(walletData?.total_balance ?? '0')} USD',
                                style: TextStyle(
                                  color: kgraycolor,
                                  fontSize: 16,
                                  fontFamily: "Aeonik",
                                ),
                              ),
                      ),
                      const SizedBox(height: 32),
                      QuickActionBar(
                        actions: [
                          {
                            'icon': AppImages().sendBitcoin,
                            'label': 'Send',
                            'onTap': () {},
                          },
                          {
                            'icon': AppImages().receiveBitcoin,
                            'label': 'Receive',
                            'onTap': () {},
                          },
                          {
                            'icon': AppImages().buyBitcoin,
                            'label': 'Buy',
                            'onTap': () {},
                          },
                          {
                            'icon': AppImages().swapBitcoin,
                            'label': 'Swap',
                            'onTap': () {},
                          },
                        ],
                      ),

                      const SizedBox(height: 60),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transaction History:',
                              style: TextStyle(
                                color: theme.colorScheme.primaryContainer,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Aeonik",
                              ),
                            ),
                            Text(
                              'View all',
                              style: TextStyle(
                                color: korangeColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Aeonik",
                              ),
                            ),
                          ],
                        ),
                      ),

                      (walletData?.all_transactions ?? []).isEmpty
                          ? Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(AppImages().emptyImage),
                                      fit: BoxFit.fitHeight,
                                    ),
                                    color: ktransparentcolor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'No Transaction History Yet',
                                  style: TextStyle(
                                    color: theme.colorScheme.primaryContainer,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Aeonik",
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(height: 10),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: walletData!.all_transactions.length,
                        itemBuilder: (context, index) {
                          final tx = walletData.all_transactions[index];
                          final bool isConfirmed =
                              tx['confirmationTime'] != null;
                          final BigInt received =
                              BigInt.tryParse(tx['received'].toString()) ??
                              BigInt.zero;
                          final BigInt sent =
                              BigInt.tryParse(tx['sent'].toString()) ??
                              BigInt.zero;
                          final bool isReceived = received > sent;
                          final BigInt amount = isReceived ? received : sent;
                          final String btcAmount = _satsToBtc(
                            amount.toString(),
                          );
                          final String walletType =
                              (tx['wallet_type'] as String? ?? '')
                                  .replaceAll('WalletType.', '')
                                  .toUpperCase();

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isReceived
                                          ? kgreencolor.withOpacity(0.15)
                                          : kredcolor.withOpacity(0.15),
                                    ),
                                    child: Icon(
                                      isReceived
                                          ? Icons.arrow_downward_rounded
                                          : Icons.arrow_upward_rounded,
                                      color: isReceived
                                          ? kgreencolor
                                          : kredcolor,
                                      size: 20,
                                    ),
                                  ),

                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              isReceived ? 'Received' : 'Sent',
                                              style: TextStyle(
                                                color: theme
                                                    .colorScheme
                                                    .primaryContainer,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Aeonik",
                                              ),
                                            ),
                                            Text(
                                              '${isReceived ? '+' : '-'}₿$btcAmount',
                                              style: TextStyle(
                                                color: isReceived
                                                    ? kgreencolor
                                                    : kredcolor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Aeonik",
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 4),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              walletType,
                                              style: TextStyle(
                                                color: kgraycolor,
                                                fontSize: 12,
                                                fontFamily: "Aeonik",
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 8,
                                                  width: 8,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: isConfirmed
                                                        ? kgreencolor
                                                        : kredcolor,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  isConfirmed
                                                      ? 'Confirmed'
                                                      : 'Unconfirmed',
                                                  style: TextStyle(
                                                    color: isConfirmed
                                                        ? kgreencolor
                                                        : kredcolor,
                                                    fontSize: 12,
                                                    fontFamily: "Aeonik",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          isReceived
                                              ? 'Incoming transaction'
                                              : "outgoing transaction",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isSyncing)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoActivityIndicator(radius: 20, color: korangeColor),
                    const SizedBox(height: 16),
                    Text(
                      'Switching wallet...',
                      style: TextStyle(
                        color: kwhitecolors,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Aeonik",
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
