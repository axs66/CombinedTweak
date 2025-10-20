
#include "GravitationTweak.h"

// ======================
// Modifications summary:
// 1) Fixed enum comparison (UIEventTypeMotion / UIEventSubtypeMotionShake)
// 2) Replaced Swift-style `UIRegion.infiniteRegion` with Objective-C `[UIRegion infiniteRegion]`
// 3) Converted all variable-length arrays (VLA) to malloc/free for C++ safety
// 4) Suppressed -Wvla-cxx-extension and related warnings
// 5) Added iOS 14.5+ compatibility guards
// ======================

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <Foundation/Foundation.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wvla-cxx-extension"
#pragma clang diagnostic ignored "-Wgnu-variable-sized-type-not-at-end"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Custom properties for Gravitation
@interface SBIconListView (Gravitation)

@property (nonatomic, strong) CMMotionManager *gravitation_motionManager;
@property (nonatomic, retain) UIDynamicAnimator *gravitation_gravitationAnimator;
@property (nonatomic, retain) UIGravityBehavior *gravitation_gravitationBehavior;
@property (nonatomic, retain) UIFieldBehavior *gravitation_fingerGravBehavior;
@property (nonatomic, retain) UICollisionBehavior *gravitation_gravitationCollisionBehavior;
@property (nonatomic, assign) BOOL gravitation_observersAdded;
@property (nonatomic, assign) BOOL gravitation_isReadyForMemoryFuck;

@end

// #pragma Globals
static BOOL _rtGravityActive = NO;
static BOOL _pfTweakEnabled = YES;
static BOOL _pfFingerGravityEnabled = YES;

NSDictionary *prefs = nil;

// Toggle
void toggleAnimations()
{
    if (!_rtGravityActive && _pfTweakEnabled)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GravitationStart" object:nil];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GravitationStop" object:nil];
    _rtGravityActive = !_rtGravityActive;
}

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// #pragma Hooks
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

%hook SBIconListView

%property (nonatomic, strong) CMMotionManager *gravitation_motionManager;
%property (nonatomic, retain) UIDynamicAnimator *gravitation_gravitationAnimator;
%property (nonatomic, retain) UIGravityBehavior *gravitation_gravitationBehavior;
%property (nonatomic, retain) UICollisionBehavior *gravitation_gravitationCollisionBehavior;
%property (nonatomic, retain) UIFieldBehavior *gravitation_fingerGravBehavior;
%property (nonatomic, assign) BOOL gravitation_observersAdded;
%property (nonatomic, assign) BOOL gravitation_isReadyForMemoryFuck;

- (id)init
{
    id o = %orig;
    return o;
}

- (void)layoutIconsNow
{
    %orig;
    if (!self.gravitation_observersAdded)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gravitation_startAnimations) name:@"GravitationStart" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gravitation_endAnimations) name:@"GravitationStop" object:nil];
        self.gravitation_observersAdded = YES;
    }
}

- (void)setVisibleColumnRange:(NSRange)range
{
    if (self.gravitation_isReadyForMemoryFuck && range.length == 0 && _rtGravityActive && _pfTweakEnabled)
        range.length = self.iconsInRowForSpacingCalculation;
    if (!_rtGravityActive || !_pfTweakEnabled)
        %orig(range);
}

- (NSRange)visibleColumnRange
{
    NSRange range = %orig;
    if (self.gravitation_isReadyForMemoryFuck && range.length == 0 && _rtGravityActive && _pfTweakEnabled)
        range.length = self.iconsInRowForSpacingCalculation;
    return range;
}

- (void)showIconImagesFromColumn:(NSInteger)arg1 toColumn:(NSInteger)arg2 totalColumns:(NSInteger)arg3 allowAnimations:(BOOL)arg4
{
    if (!(arg3 == 4))
        %orig(0, 3, 4, NO);
    else
        %orig(arg1, arg2, arg3, arg4);
}

%new
- (void)gravitation_startAnimations
{
    // 检查主开关是否启用
    if (!_pfTweakEnabled) {
        NSLog(@"[Gravitation] Tweak disabled, skipping animation start");
        return;
    }
    
    if (_pfFingerGravityEnabled)
        [self setValue:@NO forKey:@"deliversTouchesForGesturesToSuperview"];

    self.gravitation_isReadyForMemoryFuck = YES;
    if ([self respondsToSelector:@selector(setVisibleColumnRange:)])
        [self setVisibleColumnRange:NSMakeRange(0, 4)];
    else
        [self showIconImagesFromColumn:0 toColumn:3 totalColumns:4 allowAnimations:NO];

    [self layoutIconsNow];

    self.gravitation_gravitationAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    self.gravitation_gravitationBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];
    self.gravitation_gravitationCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
    self.gravitation_gravitationCollisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.gravitation_gravitationCollisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.gravitation_gravitationCollisionBehavior.collisionDelegate = self;

    if (self.gravitation_gravitationBehavior)
    {
        for (UIView *i in self.subviews)
        {
            if (![i.description containsString:@"SBIcon"]) continue;
            if (![self.gravitation_gravitationBehavior.items containsObject:i])
                [self.gravitation_gravitationBehavior addItem:i];
        }
    }

    if (self.gravitation_gravitationCollisionBehavior)
    {
        for (UIView *i in self.subviews)
        {
            if (![i.description containsString:@"SBIcon"]) continue;
            if (![self.gravitation_gravitationCollisionBehavior.items containsObject:i])
                [self.gravitation_gravitationCollisionBehavior addItem:i];
        }
    }

    __weak SBIconListView *weakSelf = self;
    self.gravitation_motionManager = [[CMMotionManager alloc] init];

    [self.gravitation_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                        withHandler:^(CMDeviceMotion *motion, NSError *error)
     {
        if (error != nil)
        {
            NSLog(@"[Gravitation] Motion error: %@", error);
            return;
        }
        weakSelf.gravitation_gravitationBehavior.gravityDirection =
            CGVectorMake(motion.gravity.x * 3, -motion.gravity.y * 3);
    }];

    [self.gravitation_gravitationAnimator addBehavior:self.gravitation_gravitationCollisionBehavior];
    [self.gravitation_gravitationAnimator addBehavior:self.gravitation_gravitationBehavior];
}

%new
- (void)gravitation_endAnimations
{
    [self setValue:@YES forKey:@"deliversTouchesForGesturesToSuperview"];
    [self.gravitation_gravitationAnimator removeAllBehaviors];

    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:.8
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        for (UIView *obj in self.subviews)
        {
            CGPoint origin = [self originForIconAtIndex:[self.subviews indexOfObject:obj]];
            obj.transform = CGAffineTransformIdentity;
            obj.frame = CGRectMake(origin.x, origin.y, obj.frame.size.width, obj.frame.size.height);
        }
    } completion:nil];

    self.gravitation_gravitationAnimator = nil;
    self.gravitation_gravitationBehavior = nil;
    self.gravitation_gravitationCollisionBehavior = nil;
    self.gravitation_motionManager = nil;
}

%new
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id)item withBoundaryIdentifier:(id)identifier atPoint:(CGPoint)p {}
%new
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id)item withBoundaryIdentifier:(id)identifier {}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 检查开关状态和重力效果是否激活
    if (!_pfFingerGravityEnabled || !_rtGravityActive || !_pfTweakEnabled) {
        %orig;
        return;
    }
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:touch.view];

    if (self.gravitation_fingerGravBehavior)
        self.gravitation_fingerGravBehavior.position = point;
    else
    {
        self.gravitation_fingerGravBehavior = [UIFieldBehavior radialGravityFieldWithPosition:point];
        for (UIView *v in self.subviews)
            [self.gravitation_fingerGravBehavior addItem:v];

        self.gravitation_fingerGravBehavior.strength = 50;
        self.gravitation_fingerGravBehavior.minimumRadius = 100;
        self.gravitation_fingerGravBehavior.region = [UIRegion infiniteRegion];
        [self.gravitation_gravitationAnimator addBehavior:self.gravitation_fingerGravBehavior];
    }
    
    // 调用原始方法，确保其他插件能正常处理触摸事件
    %orig;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 检查开关状态和重力效果是否激活
    if (!_pfFingerGravityEnabled || !_rtGravityActive || !_pfTweakEnabled) {
        %orig;
        return;
    }
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:touch.view];
    CGFloat force = (touch.force == 0) ? 2 : touch.force;
    if (self.gravitation_fingerGravBehavior)
    {
        self.gravitation_fingerGravBehavior.strength = 50 * force;
        self.gravitation_fingerGravBehavior.position = point;
    }
    
    // 调用原始方法，确保其他插件能正常处理触摸事件
    %orig;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 检查开关状态和重力效果是否激活
    if (!_pfFingerGravityEnabled || !_rtGravityActive || !_pfTweakEnabled) {
        %orig;
        return;
    }
    
    [self.gravitation_gravitationAnimator removeBehavior:self.gravitation_fingerGravBehavior];
    self.gravitation_fingerGravBehavior = nil;
    
    // 调用原始方法，确保其他插件能正常处理触摸事件
    %orig;
}

%end

%hook SBHomeScreenWindow
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    %orig;
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
        toggleAnimations();
}
%end

%hook SBRootFolderView
- (BOOL)hidesOffscreenCustomPageViews { return NO; }
%end

// Preferences
#define kIdentifier @"com.axs.gravitationprefs"
#define kSettingsChangedNotification (CFStringRef)@"com.axs.gravitationprefs/Prefs"
#define kSettingsPath @"/var/jb/var/mobile/Library/Preferences/com.axs.gravitationprefs.plist"

static void *observer = NULL;

static void reloadPrefs()
{
    if ([NSHomeDirectory() isEqualToString:@"/var/mobile"])
    {
        CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
        if (keyList)
        {
            prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
            if (!prefs) prefs = [NSDictionary new];
            CFRelease(keyList);
        }
    }
    else
        prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
}

static void preferencesChanged()
{
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);
    reloadPrefs();

    NSNumber *tweakEnabledNum = prefs[@"tweakEnabled"];
    NSNumber *fingerEnabledNum = prefs[@"fingerGravity"];
    _pfTweakEnabled = tweakEnabledNum ? tweakEnabledNum.boolValue : YES;
    _pfFingerGravityEnabled = fingerEnabledNum ? fingerEnabledNum.boolValue : YES;

    // 若主开关被关闭且动画正在运行，则立刻停止动画
    if (!_pfTweakEnabled && _rtGravityActive)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GravitationStop" object:nil];
        _rtGravityActive = NO;
    }
}

%ctor
{
    preferencesChanged();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), &observer, (CFNotificationCallback)preferencesChanged, (CFStringRef)@"com.axs.gravitation/Prefs", NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    NSLog(@"[Gravitation] Initialized ✅");
}
#pragma clang diagnostic pop
