#import "CustomAnimController.h"
#import "Preferences.h"

@implementation ARPAnim
+(ARPAnim *)animWithPath:(NSString *)path {
    return [[ARPAnim alloc] initWithPath:path];
}
-(NSString *)getPath:(NSString *)filename {
    return [self.path stringByAppendingPathComponent:filename];
}
-(id)initWithPath:(NSString *)path {
    BOOL isDir = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    if (!exists || !isDir) {
        return nil;
    }
    
    if ((self = [super init])) {
        self.path = path;
        self.name = [[path lastPathComponent] stringByDeletingPathExtension];
    }
    return self;
}

@end

@implementation ARPThemeListController

@synthesize anims = _anims;

- (id)initForContentSize:(CGSize)size {
    self = [super init];

    if (self) {
        _prefs = [[HBPreferences alloc] initWithIdentifier:@"com.boo.airport"];
        self.anims = [[NSMutableArray alloc] initWithCapacity:100];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setEditing:NO];
        [_tableView setAllowsSelection:YES];
        [_tableView setAllowsMultipleSelection:NO];
        
        if ([self respondsToSelector:@selector(setView:)])
            [self performSelectorOnMainThread:@selector(setView:) withObject:_tableView waitUntilDone:YES];        
    }

    return self;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    NSString *title = [specifier name];
    [self setTitle:title];

    if ([specifier.identifier isEqualToString:@"CUSTOM_ANIM"]) {
        device = 2;
        _apDirectory = [ARPThemesDirectory stringByAppendingString:@"AirPodPro"];
    } else if ([specifier.identifier isEqualToString:@"CUSTOM_ANIM.0"]) {
        device = 1;
        _apDirectory = [ARPThemesDirectory stringByAppendingString:@"AirPod2"];
    } else { 
        device = 0;
        _apDirectory = [ARPThemesDirectory stringByAppendingString:@"AirPod"];
    }

    [self.navigationItem setTitle:title];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (void)addAnimsFromDirectory:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *installedAnims = [fileManager contentsOfDirectoryAtPath:directory error:nil];
    NSArray *customAnims = [fileManager contentsOfDirectoryAtPath:ARPCustomDirectory error:nil];

    for (NSString *animName in installedAnims) {
        NSString *path = [_apDirectory stringByAppendingPathComponent:animName];
        ARPAnim *anim = [ARPAnim animWithPath:path];
        
        if (anim) {
            [self.anims addObject:anim];
        }
    }

    for (NSString *animName in customAnims) {
        NSString *path = [ARPCustomDirectory stringByAppendingPathComponent:animName];
        ARPAnim *anim = [ARPAnim animWithPath:path];
        
        if (anim) {
            [self.anims addObject:anim];
        }
    }
}

- (void)refreshList {
    self.anims = [[NSMutableArray alloc] initWithCapacity:50];
    [self addAnimsFromDirectory: _apDirectory];
            
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [self.anims sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    if (device == 0)
        selectedAnim = [([_prefs objectForKey:@"ApAnimName"] ?: @"Default") stringValue];
    else if (device == 1)
        selectedAnim = [([_prefs objectForKey:@"ApwAnimName"] ?: @"Default") stringValue];
    else
        selectedAnim = [([_prefs objectForKey:@"ProAnimName"] ?: @"Default") stringValue];
}

- (id)view {
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshList];
}

- (NSArray *)currentAnims {
    return self.anims;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentAnims.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnimCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AnimCell"];
    }
    
    ARPAnim *anim = [self.currentAnims objectAtIndex:indexPath.row];
    cell.textLabel.text = anim.name;    
    cell.selected = NO;

    if ([anim.name isEqualToString: selectedAnim] && !tableView.isEditing) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (!tableView.isEditing) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *old = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow: [[self.currentAnims valueForKey:@"name"] indexOfObject: selectedAnim] inSection: 0]];
    if (old) old.accessoryType = UITableViewCellAccessoryNone;

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    ARPAnim *anim = (ARPAnim*)[self.currentAnims objectAtIndex:indexPath.row];
    selectedAnim = anim.name;
    //NSString* oldAnim = [[self.currentAnims objectAtIndex:indexPath.row] name];

    ARPPrefsListController *parent = (ARPPrefsListController *)self.parentController;
    NSString *deviceAnimPath;
    NSString *deviceAnimName;

    if (device == 0) {
        deviceAnimName = @"ApAnimName";
        deviceAnimPath = @"ApAnimPath";
    } else if (device == 1) {
       deviceAnimName = @"ApwAnimName";
        deviceAnimPath = @"ApwAnimPath";
    } else {
        deviceAnimName = @"ProAnimName";
        deviceAnimPath = @"ProAnimPath";
    }

    [parent setAnimName:selectedAnim withDevice:device];
    [_prefs setObject:selectedAnim forKey:deviceAnimName];
    [_prefs setObject:anim.path forKey:deviceAnimPath];
}
@end