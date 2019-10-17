#import "UserLocationPlugin.h"
#import <user_location/user_location-Swift.h>

@implementation UserLocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUserLocationPlugin registerWithRegistrar:registrar];
}
@end
