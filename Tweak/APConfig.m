#include "APConfig.h"

@implementation APConfig

-(APConfig *)init {
    if ((self = [super init])) {
        NSMutableDictionary *colors = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.boo.airport-colors.plist"];

        HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.boo.airport"];

        self.enabled = [([prefs objectForKey:@"Enabled"] ?: @(YES)) boolValue];
        
        self.style = [([prefs objectForKey:@"AppearanceStyle"] ?: @(0)) intValue];

        //AirPods Pro
        self.proLegacy = [([prefs   objectForKey:@"ProLegacy"] ?: @(NO)) boolValue];
        self.proCustomAnim = [([prefs objectForKey:@"UseProAnim"] ?: @(YES)) boolValue];
        self.proAnimName = [([prefs objectForKey:@"ProAnimName"] ?: @"Default") stringValue];
        self.proAnimPath = [([prefs objectForKey:@"ProAnimPath"] ?: @"/Library/AirPortAnims/AirPodPro/Default/") stringValue];

        //AirPods Wireless
        self.apwCustomAnim = [([prefs objectForKey:@"UseApwAnim"] ?: @(YES)) boolValue];
        self.apwAnimName = [([prefs objectForKey:@"ApwAnimName"] ?: @"Default") stringValue];
        self.apwAnimPath = [([prefs objectForKey:@"ApwAnimPath"] ?: @"/Library/AirPortAnims/AirPod2/Default/") stringValue];

        //AirPods
        self.apCustomAnim = [([prefs objectForKey:@"useApAnim"] ?: @(YES)) boolValue];
        self.apAnimName = [([prefs objectForKey:@"ApAnimName"] ?: @"Default") stringValue];
        self.apAnimPath = [([prefs objectForKey:@"ApAnimPath"] ?: @"/Library/AirPortAnims/AirPod/Default/") stringValue];

        //Haptics
        self.hapticFeedback = [([prefs objectForKey:@"HapticFeedback"] ?: @(YES)) boolValue];
        self.hapticForce = [([prefs objectForKey:@"HapticForce"] ?: @(1)) intValue];

        // BG Style
        self.useCustomBGColor = [([prefs objectForKey:@"EnableBGColor"] ?: @(NO)) boolValue];
        self.customBGColor = LCPParseColorString([colors objectForKey:@"CustomBGColor"], @"#4CA3DD:1.0");

        // Outline Style
        self.useOutline = [([prefs objectForKey:@"UseOutline"] ?: @(NO)) boolValue];
        self.outlineThickness = [([prefs objectForKey:@"OutlineThickness"] ?: @(1.0)) doubleValue];
        self.outlineColor = LCPParseColorString([colors objectForKey:@"CustomOutlineColor"], @"#81BEE7:1.0");

        // BG Blur
        self.backgroundBlurMode = [([prefs objectForKey:@"BackgroundBlurMode"] ?: @(1)) intValue];
        self.backgroundBlurColorAlpha = [([prefs objectForKey:@"BackgroundBlurColorAlpha"] ?: @(0.4)) doubleValue];
        self.backgroundBlurAlpha = [([prefs objectForKey:@"BackgroundBlurAlpha"] ?: @(1.0)) doubleValue];

        self.useLabelColor = [([prefs objectForKey:@"UseLabelColor"] ?: @(NO)) boolValue];
        self.labelColor = LCPParseColorString([colors objectForKey:@"CustomLabelColor"], @"#FFFFFF:1.0");

    }
    return self;
}
@end