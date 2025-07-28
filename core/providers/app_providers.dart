// lib/core/providers/app_providers.dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:bookme/features/home/providers/home_provider.dart';
import 'package:bookme/features/category/providers/category_provider.dart';
import 'package:bookme/features/chat/presentation/providers/chat_provider.dart';
import 'package:bookme/features/profile/providers/profile_provider.dart';
import 'package:bookme/features/livechat/providers/live_chat_provider.dart';
import 'package:bookme/features/chat/services/firebase_service.dart';
import 'package:bookme/features/chat/data/repositories/chat_repository.dart';
import 'package:bookme/features/livechat/services/geolocation_service.dart';
import 'package:bookme/features/livechat/services/matching_service.dart';
import 'package:bookme/features/livechat/services/signaling_service.dart';
import 'package:bookme/features/livechat/services/webrtc_service.dart';
import 'package:bookme/features/livechat/services/booking_service.dart';
import 'package:bookme/features/livechat/services/chat_service.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    // Core services
    Provider(create: (context) => FirebaseService()),
    ProxyProvider<FirebaseService, ChatRepository>(
      update: (context, firebaseService, previous) =>
          ChatRepository(firebaseService),
    ),

    // Live Chat Services
    Provider(create: (context) => GeolocationService()),
    Provider(create: (context) => MatchingService()),
    Provider(create: (context) => BookingService()),
    Provider(create: (context) => ChatService()),
    Provider(
      create: (context) => SignalingService(serverUrl: 'wss://yoursignaling.server'),
    ),
    Provider(
      create: (context) => WebRTCService(),
      dispose: (_, service) => service.dispose(),
    ),

    // Feature providers
    ChangeNotifierProvider(create: (context) => HomeProvider()),
    ChangeNotifierProvider(create: (context) => CategoryProvider()),
    ChangeNotifierProvider(create: (context) => ProfileProvider()),
    ChangeNotifierProvider(create: (context) => LiveChatProvider()),

    // Chat provider with dependencies
    ChangeNotifierProxyProvider2<FirebaseService, ChatRepository, ChatProvider>(
      create: (context) => ChatProvider(
        context.read<ChatRepository>(),
        context.read<FirebaseService>(),
      ),
      update: (context, firebaseService, chatRepository, chatProvider) =>
      chatProvider ?? ChatProvider(chatRepository, firebaseService),
    ),
  ];
}