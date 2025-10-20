//
// KRTwitterCell.m
// Twitter/X cell that locally loads profile images 
// based on Cephei Framework
//
// Apache 2.0 License for code used in KRPrefsLicense located in preference bundle
//

#import "KRTwitterCell.h"
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIImage+Private.h>
#import <Foundation/Foundation.h>

@interface KRLinkCell ()

- (BOOL)shouldShowAvatar;

@end

@interface KRTwitterCell () {
    NSString *_user;
}

@end

@implementation KRTwitterCell

+ (NSString *)_urlForUsername:(NSString *)user {
    // 改为抖音深链，带 Web 兜底
    NSString *douyinId = @"1935590721863150"; // 你的抖音用户 ID
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *deep = [NSURL URLWithString:[NSString stringWithFormat:@"snssdk1128://user/profile/%@", douyinId]];
    if ([app canOpenURL:deep]) {
        return deep.absoluteString;
    }
    return [NSString stringWithFormat:@"https://www.douyin.com/user/%@", douyinId];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

    if (self) {
        UIImageView *imageView = (UIImageView *)self.accessoryView;
        imageView.image = nil;
        [imageView sizeToFit];

        // 修改为你的 X 账号和显示名称
        _user = @"TrollStore";
        [specifier setName:@"Axs"];  // 设置显示名字
        specifier.properties[@"accountName"] = _user;
        specifier.properties[@"url"] = [self.class _urlForUsername:_user];

        self.detailTextLabel.text = [@"@" stringByAppendingString:_user];

        [self setCellEnabled:YES];

        [self loadAvatarIfNeeded];
    }

    return self;
}

- (void)setSelected:(BOOL)arg1 animated:(BOOL)arg2
{
    [super setSelected:arg1 animated:arg2];

    if (!arg1) return;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.class _urlForUsername:_user]] options:@{} completionHandler:nil];
}

#pragma mark - Avatar

- (BOOL)shouldShowAvatar {
    // HBLinkTableCell doesn’t want avatars by default, but we do. override its check method so that
    // if showAvatar is unset, we return YES
    return YES;
}

- (void)loadAvatarIfNeeded {
    if (self.avatarImage) {
        return;
    }

    // 优先从本地偏好包资源加载头像
    NSString *iconName = self.specifier.properties[@"icon"] ?: @"_Axs";
    NSBundle *bundle = [NSBundle bundleForClass:self.class];

    UIImage *localImage = nil;
    // 使用私有 API（已导入 UIImage+Private）按名称从 bundle 加载
    localImage = [UIImage imageNamed:iconName inBundle:bundle];
    if (!localImage) {
        // 兼容性兜底：直接通过路径加载 .png
        NSString *pngPath = [bundle pathForResource:iconName ofType:@"png"];
        if (pngPath) {
            localImage = [UIImage imageWithContentsOfFile:pngPath];
        }
    }

    if (localImage) {
        self.avatarImage = localImage;
        return;
    }

    // 本地未找到时不再进行网络兜底
    return;
}

@end
