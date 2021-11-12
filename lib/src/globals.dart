import 'package:event_bus/event_bus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:stocks/src/controllers/backfill_complete.dart';
import 'package:stocks/src/controllers/current_position.dart';
import 'package:stocks/src/controllers/market_info.dart';
import 'package:stocks/src/controllers/max_value.dart';
import 'package:stocks/src/services/cash_balance.dart';
import 'package:timezone/standalone.dart';

import 'controllers/app_root.dart';
import 'controllers/navigation.dart';
import 'controllers/new_price_indicator.dart';
import 'controllers/pop_sound.dart';
import 'controllers/portfolio_updated.dart';
import 'controllers/price_change.dart';
import 'controllers/selected_item.dart';
import 'controllers/sound_enable.dart';

EventBus appEventBus = EventBus();

const double windowWidth = 1200;
const double windowHeight = 800;
const String appTitle = 'Swing';

bool soundEnabled = false;
const String pop = 'pop.mp3';
const String siren1 = 'siren1.mp3';

/// Selector for production or sandbox API
///
/// 'IEX' = production
///
/// 'IEX_SB' = sandbox
const String serviceEndPoint = 'IEX';

Location eastern = getLocation('US/Eastern');
Location central = getLocation('US/Central');

List<SingleChildWidget> providers = [
  ListenableProvider<NavigationController>(
    create: (_) => NavigationController(),
  ),
  ListenableProvider<AppRootController>(
    create: (_) => AppRootController(),
  ),
  ListenableProvider<PriceChangeController>(
    create: (_) => PriceChangeController(),
  ),
  ListenableProvider<PortfolioUpdateController>(
    create: (_) => PortfolioUpdateController(),
  ),
  ListenableProvider<SelectedItemController>(
    create: (_) => SelectedItemController(),
  ),
  ListenableProvider<PopSoundController>(
    create: (_) => PopSoundController(),
  ),
  ListenableProvider<SoundController>(
    create: (_) => SoundController(),
  ),
  ListenableProvider<NewPriceIndicatorController>(
    create: (_) => NewPriceIndicatorController(),
  ),
  ListenableProvider<CashBalance>(
    create: (_) => CashBalance(),
    lazy: false,
  ),
  ListenableProvider<BackfillCompleteController>(
    create: (_) => BackfillCompleteController(),
    lazy: false,
  ),
  ListenableProvider<CurrentPositionController>(
    create: (_) => CurrentPositionController(),
    lazy: false,
  ),
  ListenableProvider<MaxValueController>(
    create: (_) => MaxValueController(),
    lazy: false,
  ),
  ListenableProvider<MarketInfoController>(
    create: (_) => MarketInfoController(),
    lazy: false,
  ),
];
