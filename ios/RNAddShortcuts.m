
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

    if (![self isSupported]) {
        onCancel(@[]);
        return;
    }
    
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

- (BOOL) isSupported {
    BOOL supported = [[UIApplication sharedApplication].delegate.window.rootViewController.traitCollection forceTouchCapability] == UIForceTouchCapabilityAvailable;

    return supported;
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

- (UIImage *) generateVectorIcon: (NSDictionary *) icon {
    NSString *family = [icon objectForKey: @"family"];
    NSString *name = [icon objectForKey: @"name"];
    NSString *glyph = [icon objectForKey: @"glyph"];
    NSNumber *size = [icon objectForKey: @"size"];
    NSString *color = [icon objectForKey: @"color"];
    
    if (name != nil && [name length] > 0 && [name containsString: @"."]) {
        return [UIImage imageNamed: name];
    }
    
    UIColor *uiColor = [RNAddShortcuts colorFromHexCode: color];
    CGFloat screenScale = RCTScreenScale();
    
    UIFont *font = [UIFont fontWithName:family size:[size floatValue]];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:glyph attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: uiColor}];
    
    CGSize iconSize = [attributedString size];
    UIGraphicsBeginImageContextWithOptions(iconSize, NO, 0.0);
    [attributedString drawAtPoint:CGPointMake(0, 0)];
    
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return iconImage;
}

+ (UIColor *) colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
