import 'package:event_bus/event_bus.dart';

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
