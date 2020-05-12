
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import "RNImageHelper.h"

@interface RNAddShortcuts : NSObject <RCTBridgeModule>

+(void) onShortcutItemPress:(UIApplicationShortcutItem *) shortcutItem completionHandler:(void (^)(BOOL succeeded)) completionHandler;

@end
