#import "UserLocationPlugin.h"
#if __has_include(<user_location/user_location-Swift.h>)
#import <user_location/user_location-Swift.h>
#else
#import "user_location-Swift.h"
#endif

@implementation UserLocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUserLocationPlugin registerWithRegistrar:registrar];
}
@end
