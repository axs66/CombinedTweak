#include <Preferences/PSTableCell.h>
#include <CoreMotion/CoreMotion.h>
#include <QuartzCore/QuartzCore.h>

@interface PSGravityLinkCell : PSTableCell

@property (nonatomic, strong) CMMotionManager *gravitation_motionManager;
@property (nonatomic, retain) UIDynamicAnimator *gravitation_gravitationAnimator;
@property (nonatomic, retain) UIGravityBehavior *gravitation_gravitationBehavior;
@property (nonatomic, retain) UIFieldBehavior *gravitation_fingerGravBehavior;
@property (nonatomic, retain) UICollisionBehavior *gravitation_gravitationCollisionBehavior;

// 自有容器与元素，避免向系统子视图注册物理行为导致崩溃
@property (nonatomic, strong) UIView *gravitation_effectContainer;
@property (nonatomic, strong) NSArray<UIView *> *gravitation_effectItems;
@property (nonatomic, assign) BOOL gravitation_didSetup;

@end

@implementation PSGravityLinkCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier 
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		self.gravitation_didSetup = NO;
	}

	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	if (self.gravitation_didSetup)
		return;
	self.gravitation_didSetup = YES;

	// 构建自有容器，避免操作系统子视图
	self.gravitation_effectContainer = [[UIView alloc] initWithFrame:self.contentView.bounds];
	self.gravitation_effectContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.gravitation_effectContainer.userInteractionEnabled = NO;
	self.gravitation_effectContainer.clipsToBounds = YES;
	[self.contentView insertSubview:self.gravitation_effectContainer atIndex:0];

	// 提前返回以禁用下方的6个灰色圆点与物理效果
	// return;
	
	// 创建少量自有元素参与物理效果（7 个彩虹色小圆点）
	NSMutableArray<UIView *> *items = [NSMutableArray array];
	NSArray<UIColor *> *palette = @[
		[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.9],        // 红
		[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.9],        // 橙
		[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.9],        // 黄
		[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.9],        // 绿
		[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.9],        // 蓝
		[UIColor colorWithRed:0.294 green:0.0 blue:0.510 alpha:0.9],    // 靛（#4B0082）
		[UIColor colorWithRed:0.560 green:0.0 blue:1.0 alpha:0.9]       // 紫（#8F00FF）
	];
	for (NSInteger i = 0; i < 7; i++) {
		CGFloat size = 10.0;
		CGFloat x = 16.0 + (CGFloat)(arc4random_uniform(60));
		CGFloat y = 10.0 + (CGFloat)(arc4random_uniform(20));
		UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(x, y, size, size)];
		dot.layer.cornerRadius = size / 2.0;
		dot.backgroundColor = palette[i % palette.count];
		[self.gravitation_effectContainer addSubview:dot];
		[items addObject:dot];
	}
	self.gravitation_effectItems = items;

	self.gravitation_gravitationAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gravitation_effectContainer];
	self.gravitation_gravitationBehavior = [[UIGravityBehavior alloc] initWithItems:self.gravitation_effectItems];
	self.gravitation_gravitationCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.gravitation_effectItems];
	self.gravitation_gravitationCollisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
	self.gravitation_gravitationCollisionBehavior.collisionMode = UICollisionBehaviorModeEverything;

	[self.gravitation_gravitationAnimator addBehavior:self.gravitation_gravitationCollisionBehavior];
	[self.gravitation_gravitationAnimator addBehavior:self.gravitation_gravitationBehavior];

	self.gravitation_motionManager = [[CMMotionManager alloc] init];
	if (self.gravitation_motionManager.deviceMotionAvailable) {
		__weak PSGravityLinkCell *weakSelf = self;
		[self.gravitation_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
			if (error != nil) { return; }
			weakSelf.gravitation_gravitationBehavior.gravityDirection = CGVectorMake(motion.gravity.x * 3, -motion.gravity.y * 3);
		}];
	}
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	self.gravitation_didSetup = NO;
}

- (void)dealloc
{
	[self.gravitation_motionManager stopDeviceMotionUpdates];
}

@end
