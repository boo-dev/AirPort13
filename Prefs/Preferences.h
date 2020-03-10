#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSwitchTableCell.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import "NSTask.h"
#import <dlfcn.h>

#define kBundlePath @"/Library/PreferenceBundles/AirPortPrefs.bundle"
#define COLORS_PATH @"/var/mobile/Library/Preferences/com.boo.airport-colors.plist"
#define BUNDLE_ID @"com.boo.airport"

@interface ARPPrefsListController : HBRootListController {
            UITableView * _table;

}
    @property (nonatomic, retain) UIBarButtonItem *respringButton;
    @property (nonatomic, retain) UIView *headerView;
    @property (nonatomic, retain) UIView *headerCoverView;
    @property (nonatomic, retain) UILabel *bannerAuthorLabel;
    @property (nonatomic, retain) UILabel *bannerTitleLabel;
    @property (nonatomic, retain) UILabel *titleLabel;
    @property (nonatomic, retain) UIImageView *iconView;
//@property (nonatomic, retain) UIBarButtonItem *respringButton;
-(void)respring:(id)sender;
-(void)resetPrefs:(id)sender;
-(void)setAnimName:(NSString *)name withDevice:(int)device;
@end

/*
@interface APTSwitchCell : PSSwitchTableCell
@end
*/