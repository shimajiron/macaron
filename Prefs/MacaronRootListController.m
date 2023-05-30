#import "MacaronRootListController.h"

@implementation MacaronRootListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

- (void)viewDidLoad {
	[super viewDidLoad];

    HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
	UIColor *defaultColor = [UIColor colorWithRed:109/255.0 green:174/255.0 blue:255/255.0 alpha:1.0];
	appearanceSettings.tintColor = defaultColor;
	appearanceSettings.navigationBarBackgroundColor = [UIColor clearColor];
	appearanceSettings.tableViewCellSeparatorColor = [UIColor clearColor];
	self.hb_appearanceSettings = appearanceSettings;

    self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
    self.respringButton.tintColor = [UIColor secondaryLabelColor];
    self.navigationItem.rightBarButtonItem = self.respringButton;

	self.navigationItem.titleView = [UIView new];

    self.iconView = [[UIImageView alloc] init];
	self.iconView.image = [UIImage imageWithContentsOfFile:ROOT_PATH_NS(@"/Library/PreferenceBundles/Macaron.bundle/icon.png")];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
	self.iconView.alpha = 0.0;
    [self.navigationItem.titleView addSubview:self.iconView];

	[self.iconView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.iconView.centerXAnchor constraintEqualToAnchor:self.navigationItem.titleView.centerXAnchor].active = YES;
	[self.iconView.centerYAnchor constraintEqualToAnchor:self.navigationItem.titleView.centerYAnchor].active = YES;

	[self.iconView sizeToFit];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat const offsetY = scrollView.contentOffset.y;
  if (offsetY > 100) {
    [UIView animateWithDuration:0.2 animations:^{
		self.iconView.alpha = 1.0;
	}];
  } else {
    [UIView animateWithDuration:0.2 animations:^{
		self.iconView.alpha = 0.0;
	}];
  }
}

- (void)respring:(id)sender {
	// Rootlessだとkillallのディレクトリが違うので注意が必要。
    pid_t pid;
    const char* args[] = {"killall", "SpringBoard", NULL};
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/killall"]) posix_spawn(&pid, "usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    else posix_spawn(&pid, "/var/jb/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (UITableViewStyle)tableViewStyle {
	return UITableViewStyleInsetGrouped;
}

@end
