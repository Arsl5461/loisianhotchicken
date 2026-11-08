import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;

bool get appleSignInSupported =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.macOS;
