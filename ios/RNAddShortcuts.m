
#import "RNAddShortcuts.h"

#import "RCTUtils.h"

#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>

NSString *const RCTShortcutItemClicked = @"ShortcutItemClicked";

NSDictionary *RNShortcutItem(UIApplicationShortcutItem *item) {
    if (!item) return nil;
    return @{
        @"type": item.type,
        @"title": item.localizedTitle,
        @"link": item.userInfo ?: @{}
    };
}

@implementation RNAddShortcuts
{
    UIApplicationShortcutItem *_initialShortcut;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

- (instancetype)init
{
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleShortcutItemPress:)
                                                     name:RCTShortcutItemClicked
                                                   object:nil];
    }
    return self;
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setBridge:(RCTBridge *)bridge
{
    _bridge = bridge;
    _initialShortcut = [bridge.launchOptions[UIApplicationLaunchOptionsShortcutItemKey] copy];
}

RCT_EXPORT_METHOD(AddDynamicShortcut:(nonnull NSDictionary *)props onDone:(RCTResponseSenderBlock)onDone onCancel:(RCTResponseSenderBlock)onCancel) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *label = [props objectForKey: @"label"];
        NSString *description = [props objectForKey: @"description"];
        NSDictionary *icon = [props objectForKey: @"icon"];
        NSDictionary *info = [props objectForKey:@"link"];
        
        UIApplicationShortcutItem *shortcutItem = [[UIApplicationShortcutItem alloc] initWithType: label
                                                                  localizedTitle:label
                                                               localizedSubtitle:description
                                                                            icon:[UIApplicationShortcutIcon iconWithTemplateImageName: [icon objectForKey: @"name"]]
                                                                                         userInfo:info];
        
        NSMutableArray<UIApplicationShortcutItem *> *shortcuts = [UIApplication sharedApplication].shortcutItems;
        [shortcuts addObject:shortcutItem];

        
      [UIApplication sharedApplication].shortcutItems = shortcuts;
    
        onDone(@[]);
    });
}


RCT_EXPORT_METHOD(GetDynamicShortcuts:(RCTResponseSenderBlock)onDone onCancel:(RCTResponseSenderBlock)onCancel) {
    NSArray<UIApplicationShortcutItem *> *shortcuts = [UIApplication sharedApplication].shortcutItems;
    NSMutableArray<NSString *> *shareShortcuts = [[NSMutableArray alloc] init];
    
    for (UIApplicationShortcutItem *shortcut in shortcuts) {
        [shareShortcuts addObject: [shortcut type]];
    }

    onDone(@[shareShortcuts]);
}


RCT_EXPORT_METHOD(RemoveAllDynamicShortcuts:(RCTResponseSenderBlock)onDone onCancel:(RCTResponseSenderBlock)onCancel) {
    [UIApplication sharedApplication].shortcutItems = nil;

    onDone(@[]);
}

RCT_EXPORT_METHOD(PopDynamicShortcuts:(nonnull NSDictionary *)props onDone:(RCTResponseSenderBlock)onDone onCancel:(RCTResponseSenderBlock)onCancel) {
    NSArray *popShortcuts = [props objectForKey: @"shortcuts"];
    
    NSArray<UIApplicationShortcutItem *> *shortcuts = [UIApplication sharedApplication].shortcutItems;
    NSMutableArray<UIApplicationShortcutItem *> *updateShortcuts = [[NSMutableArray alloc] initWithArray:shortcuts];
    
    for (NSString *popShortcut in popShortcuts) {
        for (UIApplicationShortcutItem *shortcutItem in shortcuts) {
            if ([shortcutItem.type isEqualToString: popShortcut]) {
                [updateShortcuts removeObject: shortcutItem];
            }
        }
    }

    [UIApplication sharedApplication].shortcutItems = updateShortcuts;

    onDone(@[]);
}

+ (void)onShortcutItemPress:(UIApplicationShortcutItem *) shortcutItem completionHandler:(void (^)(BOOL succeeded)) completionHandler
{
    RCTLogInfo(@"[RNShortcutItem] shortcut item pressed: %@", [shortcutItem type]);

    [[NSNotificationCenter defaultCenter] postNotificationName:RCTShortcutItemClicked
                                                        object:self
                                                      userInfo:RNShortcutItem(shortcutItem)];

    completionHandler(YES);
}

- (void)handleShortcutItemPress:(NSNotification *) notification
{
    [_bridge.eventDispatcher sendDeviceEventWithName:@"shortCutPressed"
                                                body:notification.userInfo];
}

- (NSDictionary *)constantsToExport
{
    return @{
      @"initialShortcut": RCTNullIfNil(RNShortcutItem(_initialShortcut))
    };
}

@end
