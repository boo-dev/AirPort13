#import "Sub.h"

@implementation ARPSubPrefsListController

- (id)specifiers {
    _specifiers = [super specifiers];
    return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    NSString *sub = [specifier propertyForKey:@"ARPSub"];
    NSString *title = [specifier name];

    _specifiers = [self loadSpecifiersFromPlistName:sub target:self];

    // if appearance style is paint show the paint settings

    [self setTitle:title];
    [self.navigationItem setTitle:title];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
    [self loadFromSpecifier:specifier];
    [super setSpecifier:specifier];
}

- (bool)shouldReloadSpecifiersOnResume {
    return false;
}

@end