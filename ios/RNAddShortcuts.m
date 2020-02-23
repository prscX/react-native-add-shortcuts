
#import "RNAddShortcuts.h"

#import "RCTUtils.h"

@implementation RNAddShortcuts

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(AddDynamicShortcut:(nonnull NSDictionary *)props onDone:(RCTResponseSenderBlock)onDone onCancel:(RCTResponseSenderBlock)onCancel) {

    if (![self isSupported]) {
        onCancel(@[]);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *label = [props objectForKey: @"label"];
        NSString *description = [props objectForKey: @"description"];
        NSDictionary *icon = [props objectForKey: @"icon"];

        NSMutableArray *shortcutItem = [NSMutableArray new];
        [shortcutItem addObject:[[UIApplicationShortcutItem alloc] initWithType: label
                                                                  localizedTitle:label
                                                               localizedSubtitle:description
                                                                            icon:[UIApplicationShortcutIcon iconWithTemplateImageName: [icon objectForKey: @"name"]]
                                                                        userInfo:nil]];

        
      [UIApplication sharedApplication].shortcutItems = shortcutItem;
    
        onDone(@[]);
    });
}


RCT_EXPORT_METHOD(GetDynamicShortcuts:(RCTResponseSenderBlock)onDone onCancel:(RCTResponseSenderBlock)onCancel) {
    if (![self isSupported]) {
        onCancel(@[]);
        return;
    }

    NSArray<UIApplicationShortcutItem *> *shortcuts = [UIApplication sharedApplication].shortcutItems;
    NSMutableArray<NSString *> *shareShortcuts = [[NSMutableArray alloc] init];
    
    for (UIApplicationShortcutItem *shortcut in shortcuts) {
        [shareShortcuts addObject: [shortcut type]];
    }

    onDone(@[shareShortcuts]);
}


RCT_EXPORT_METHOD(RemoveAllDynamicShortcuts:(RCTResponseSenderBlock)onDone onCancel:(RCTResponseSenderBlock)onCancel) {
    if (![self isSupported]) {
        onCancel(@[]);
        return;
    }

    [UIApplication sharedApplication].shortcutItems = nil;

    onDone(@[]);
}


RCT_EXPORT_METHOD(PopDynamicShortcuts:(nonnull NSDictionary *)props onDone:(RCTResponseSenderBlock)onDone onCancel:(RCTResponseSenderBlock)onCancel) {
    if (![self isSupported]) {
        onCancel(@[]);
        return;
    }

    NSArray *popShortcuts = [props objectForKey: @"shortcuts"];
    
    NSArray<UIApplicationShortcutItem *> *shortcuts = [UIApplication sharedApplication].shortcutItems;
    NSMutableArray<UIApplicationShortcutItem *> *updateShortcuts = [[NSMutableArray alloc] init];
    
    for (NSString *popShortcut in popShortcuts) {
        for (UIApplicationShortcutItem *shortcutItem in shortcuts) {
            if (![shortcutItem.type isEqualToString: popShortcut]) {
                [updateShortcuts addObject: shortcutItem];
            }
        }
    }

    [UIApplication sharedApplication].shortcutItems = updateShortcuts;

    onDone(@[]);
}


- (BOOL) isSupported {
    BOOL supported = [[UIApplication sharedApplication].delegate.window.rootViewController.traitCollection forceTouchCapability] == UIForceTouchCapabilityAvailable;

    return supported;
}

@end
  
