import 'package:event_bus/event_bus.dart';

EventBus appEventBus = EventBus();

const double windowWidth = 1200;
const double windowHeight = 800;
const String appTitle = 'Swing';

/// Selector for production or sandbox API
///
/// 'IEX' = production
///
/// 'IEX_SB' = sandbox
const String serviceEndPoint = 'IEX';
