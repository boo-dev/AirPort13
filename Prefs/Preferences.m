#import "Preferences.h"
#import <objc/runtime.h>

@implementation ARPPrefsListController
@synthesize respringButton;

- (instancetype)init {
    NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];
    NSString *applyString = [bundle localizedStringForKey:@"APPLY" value:@"APPLY" table:@"Prefs"];
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        self.respringButton = [[UIBarButtonItem alloc] initWithTitle:applyString
                                    style:UIBarButtonItemStylePlain
                                    target:self 
                                    action:@selector(respring:)];
        self.respringButton.tintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        self.navigationItem.rightBarButtonItem = self.respringButton;
        appearanceSettings.largeTitleStyle = HBAppearanceSettingsLargeTitleStyleNever;
        appearanceSettings.tintColor = [UIColor colorWithRed:76/255.0 green:163/255.0 blue:221/255.0 alpha:1.0f];
        appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0];
        appearanceSettings.statusBarTintColor = [UIColor whiteColor];
        appearanceSettings.navigationBarTitleColor = [UIColor whiteColor];
        appearanceSettings.navigationBarTintColor = [UIColor whiteColor];
        appearanceSettings.navigationBarBackgroundColor = [UIColor colorWithRed:76/255.0 green:163/255.0 blue:221/255.0 alpha:1.0f];
        appearanceSettings.translucentNavigationBar = NO;
        self.hb_appearanceSettings = appearanceSettings;

        self.navigationItem.titleView = [UIView new];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"AirPort"];
        [text addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightMedium],
            NSForegroundColorAttributeName:[UIColor whiteColor]}
        range:NSMakeRange(0, 7)];
        [self.titleLabel setAttributedText:text];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.alpha = 0.0f;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        [self.navigationItem.titleView addSubview:self.titleLabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AirPortPrefs.bundle/Icon@2x.png"];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.alpha = 1.0;
        [self.navigationItem.titleView addSubview:self.iconView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];
    }
    return self;
}

- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Prefs" target:self];
    }
    return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];


    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;
	
    self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:76/255.0 green:163/255.0 blue:221/255.0 alpha:1.0];
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 100) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 0.0;
            self.titleLabel.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 1.0;
            self.titleLabel.alpha = 0.0;
        }];
    }
    
    if (offsetY > 0) offsetY = 0;
    self.headerCoverView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 180 - offsetY);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (@available(iOS 11, *))
    {
        self.navigationController.navigationBar.prefersLargeTitles = false;
        self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 180)];
    self.headerCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 180)];
    self.headerCoverView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerCoverView.backgroundColor = [UIColor colorWithRed:76/255.0 green:163/255.0 blue:221/255.0 alpha:1.0f];
    self.headerCoverView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.headerView addSubview:self.headerCoverView];

    self.bannerAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 100, 20)];
    self.bannerAuthorLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.bannerAuthorLabel.text = @"BooDev";
    self.bannerAuthorLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.headerView addSubview:self.bannerAuthorLabel];

    self.bannerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 300, 40)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"AirPort"];
    [text addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:36 weight:UIFontWeightMedium],
        NSForegroundColorAttributeName:[UIColor whiteColor]}
    range:NSMakeRange(0, 7)];
    [self.bannerTitleLabel setAttributedText:text];
    [self.headerView addSubview:self.bannerTitleLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.headerCoverView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerCoverView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerCoverView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.headerCoverView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    _table.tableHeaderView = self.headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)respring:(id)sender {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:[NSArray arrayWithObjects:@"SpringBoard", @"SharingViewService", @"sharingd", nil]];
    [task launch];
}
- (void)resetPrefs:(id)sender {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:BUNDLE_ID];
    [prefs removeAllObjects];

    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:COLORS_PATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:COLORS_PATH error:&error];
    }

    [self respring:sender];
}
- (void)setAnimName:(NSString *)name withDevice:(int)device {
    UITableViewCell *cell;
    if (device == 0) cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
    else if (device == 1) cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    else cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
	cell.detailTextLabel.text = name;
}
@end