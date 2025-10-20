//
//  CombinedTweakRootListController.m
//  CombinedTweak Preferences
//

#import "CombinedTweakRootListController.h"

@implementation CombinedTweakRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add respring button to navigation bar
    UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
    self.navigationItem.rightBarButtonItem = respringButton;
}

- (void)respring {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Respring" message:@"Are you sure you want to respring?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *respringAction = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        pid_t pid;
        const char* args[] = {"killall", "-9", "SpringBoard", NULL};
        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:respringAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cataloguePrompt {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Browse Catalogue" message:@"This will open the Eneko wallpaper catalogue in your browser." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Open" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Traurige/Eneko"] options:@{} completionHandler:nil];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:openAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)resetPrompt {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset Preferences" message:@"Are you sure you want to reset all preferences to default values? This action cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *path = @"/var/mobile/Library/Preferences/com.axs.combinedtweakprefs.plist";
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Preferences have been reset. Please respring to apply changes." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [successAlert addAction:okAction];
        [self presentViewController:successAlert animated:YES completion:nil];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:resetAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
