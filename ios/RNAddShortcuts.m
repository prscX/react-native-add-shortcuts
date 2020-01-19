
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
  
