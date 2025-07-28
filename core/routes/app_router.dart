import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookme/auth/screens/auth_gate_screen.dart';
import 'package:bookme/auth/screens/login_screen.dart';
import 'package:bookme/auth/screens/signup_screen.dart';
import 'package:bookme/auth/screens/otp_verification_screen.dart';
import 'package:bookme/auth/screens/user_reason_screen.dart';
import 'package:bookme/auth/screens/forgot_password_screen.dart';
import 'package:bookme/auth/screens/reset_password_screen.dart';
import 'package:bookme/auth/screens/email_login_screen.dart';
import 'package:bookme/auth/screens/phone_login_screen.dart';
import 'package:bookme/features/home/screens/home_screen.dart';
import 'package:bookme/features/category/screens/category_screen.dart';
import 'package:bookme/features/category/screens/category_results_screen.dart';
import 'package:bookme/features/livechat/components/ephemeral_chat_window.dart';
import 'package:bookme/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:bookme/features/chat/presentation/screens/chat_screen.dart';
import 'package:bookme/features/chat/presentation/screens/new_chat_screen.dart';
import 'package:bookme/features/livechat/components/video_call_screen.dart';
import 'package:bookme/features/livechat/screens/call_ended_screen.dart';
import 'package:bookme/features/profile/screens/profile_screen.dart';
import 'package:bookme/core/routes/route_names.dart';
import 'package:bookme/core/screens/splash_screen.dart';
import 'package:bookme/features/main_nav/main_nav.dart';
import 'package:bookme/auth/models/user_model.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final protectedRoutes = [
      RouteNames.mainNav,
      RouteNames.home,
      RouteNames.category,
      RouteNames.categoryResults,
      RouteNames.liveChat,
      RouteNames.chatList,
      RouteNames.chat,
      RouteNames.profile,
      RouteNames.videoCall,
      RouteNames.callEnded
    ];

    // Route guard for protected routes
    if (protectedRoutes.contains(settings.name)) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return MaterialPageRoute(
          builder: (_) => const AuthGateScreen(),
          settings: const RouteSettings(name: RouteNames.authGate),
        );
      }
    }

    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.authGate:
        return MaterialPageRoute(builder: (_) => const AuthGateScreen());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.emailLogin:
        return MaterialPageRoute(builder: (_) => const EmailLoginScreen());

      case RouteNames.phoneLogin:
        return MaterialPageRoute(builder: (_) => const PhoneLoginScreen());

      case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case RouteNames.otpVerification:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(
            phone: args['phone'] as String,
            username: args['username'] as String?,
            dob: DateTime.parse(args['dob'] as String),
            password: args['password'] as String?,
            isLogin: args['isLogin'] as bool? ?? false,
          ),
        );

      case RouteNames.userReason:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(builder: (_) => UserReasonScreen(user: user));

      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case RouteNames.resetPassword:
        final oobCode = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen(oobCode: oobCode));

      case RouteNames.mainNav:
        return MaterialPageRoute(builder: (_) => const MainNav());

      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteNames.category:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());

      case RouteNames.categoryResults:
        return MaterialPageRoute(builder: (_) => const CategoryResultsScreen());

      case RouteNames.liveChat:
        return MaterialPageRoute(builder: (_) => EphemeralChatWindow(onClose: () {}));

      case RouteNames.chatList:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());

      case RouteNames.chat:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            conversationId: args['conversationId'] as String,
            receiverId: args['receiverId'] as String,
            receiverName: args['receiverName'] as String,
          ),
        );

      case RouteNames.newChat:
        return MaterialPageRoute(builder: (_) => const NewChatScreen());

      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case RouteNames.videoCall:
        return MaterialPageRoute(builder: (_) => const VideoCallScreen());

      case RouteNames.callEnded:
        return MaterialPageRoute(builder: (_) => const CallEndedScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}