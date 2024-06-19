abstract class SplashStates {}

class SplashInitState extends SplashStates {}

class GetVersionLoadingState extends SplashStates {}

class GetVersionSuccessState extends SplashStates {
  final String version;

  GetVersionSuccessState({required this.version});
}

class GetVersionErrorState extends SplashStates {}
