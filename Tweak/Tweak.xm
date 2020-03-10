#include "Tweak.h"

%group AirPodProFix

%hook SFBLEScanner
- (void)_foundDevice:(id)arg1 advertisementData:(id)arg2 rssi:(long long)arg3 fields:(id)arg4 {
	NSDictionary *advertFields = arg4;
	long long pid = [[advertFields objectForKey:@"pid"] longLongValue];
	if (pid == 8206) {
		HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"com.boo.airport"];
		NSString *deviceUUID = [arg1 UUIDString];

		if (![prefs objectForKey:@"ProUUID"]) {
			[prefs setObject:deviceUUID forKey:@"ProUUID"];
		}

		NSMutableDictionary *newAdvertFields = [advertFields mutableCopy];
		[newAdvertFields setObject:@"AirPods1,1" forKey:@"model"];
		[newAdvertFields setObject:@"8194" forKey:@"pid"];
		arg4 = newAdvertFields;
	}
	
	%orig;
}
%end

%hook SFDeviceAssetTask
-(id)bundleAtURL:(id)arg1 error:(id*)arg2 {

	NSString *originalBundlePath = [arg1 lastPathComponent];
	if ([originalBundlePath isEqual:@"AirPods1_2-CL_0.devicebundle"]) {
		arg1 = [[NSURL alloc] initWithString:@"file:///Library/Application%20Support/AirPort/AirPodsPro1_1-CL_0.devicebundle" relativeToURL:nil];
	}

	return %orig;
}
%end

%hook BCBatteryDevice
+ (id)batteryDeviceWithIdentifier:(id)arg1 vendor:(long long)arg2 productIdentifier:(long long)arg3 parts:(unsigned long long)arg4 matchIdentifier:(id)arg5 {
	%orig;

	// Change PID everywhere we can (even though it's not 100% neccessary)
	if (arg3 == 8206) arg3 = 8194;
	
	// Hide the extra entry that gets added for the 2nd gen airpods (Part 0 isn't needed for airpods)
	if (arg3 == 8194 && arg4 == 0) {
		return nil;
	}

	else return %orig;
}
-(id)initWithIdentifier:(id)arg1 vendor:(long long)arg2 productIdentifier:(long long)arg3 parts:(unsigned long long)arg4 matchIdentifier:(id)arg5 {
	%orig;
	if (arg3 == 8206) arg3 = 8194;
	// Change PID everywhere we can (even though it's not 100% neccessary)

	// Hide the extra entry that gets added for the 2nd gen airpods (Part 0 isn't needed for airpods)
	if (arg3 == 8194 && arg4 == 0) {
		return nil;
	}
	else return %orig;
}
%end
%end

%group AirPortCustomAnim13

%hook AVPlayerItem
+(id)playerItemWithURL:(id)arg1 {
	NSString *itemString = [arg1 absoluteString];

	if ([itemString containsString:@"AirPods"]) {
		APConfig *config = [[APConfig alloc] init];

		NSString *pathForFile;
		NSString *fileName = [@"/" stringByAppendingString:[itemString lastPathComponent]];

		if ([itemString containsString:@"AirPods1_1-CL_0.devicebundle"]) {
			if (config.proCustomAnim) pathForFile = [config.apAnimPath stringByAppendingString:fileName];
		} else if ([itemString containsString:@"AirPods1_2-CL_0.devicebundle"]) {
			if (config.apwCustomAnim) pathForFile = [config.apAnimPath stringByAppendingString:fileName];
		} else if ([itemString containsString:@"AirPodsPro1_1-CL_0.devicebundle"]) {
			if (config.apCustomAnim) pathForFile = [config.proAnimPath stringByAppendingString:fileName];
		}

		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		if ([fileManager fileExistsAtPath:pathForFile]) arg1 = [NSURL fileURLWithPath:pathForFile];
		else if ([pathForFile containsString:@"ProxCard_loop"]) {
			NSString *animPath = [pathForFile stringByDeletingLastPathComponent];
			if ([fileManager fileExistsAtPath:[animPath stringByAppendingString:@"/ProxCard_loop.mov"]]) {
				arg1 = [NSURL fileURLWithPath:[animPath stringByAppendingString:@"/ProxCard_loop.mov"]];
			}
		}
	}

	return %orig;
}
%end

%hook ProximityStatusViewController
- (void)viewWillAppear:(bool)arg1 {	
	%orig;

	APConfig *config = [[APConfig alloc] init];

	UIView *view = MSHookIvar<UIView *>(self, "_containerView");

	if (config.hapticFeedback) {
		UIImpactFeedbackGenerator *myGen;
		if (config.hapticForce == 2) myGen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
		else if (config.hapticForce == 1) myGen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
		else myGen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    	[myGen impactOccurred];
	}

	// Background Color
	if (config.useCustomBGColor) {
		if (config.backgroundBlurMode != 0) {
			UIBlurEffect *blurEffect;

			if (config.backgroundBlurMode == 1) {
				blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			} else {
				blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			}
			UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

			blurEffectView.frame = view.bounds;
			blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			blurEffectView.layer.cornerRadius = 30.0;
			[view insertSubview:blurEffectView atIndex:0];
			blurEffectView.backgroundColor = [config.customBGColor colorWithAlphaComponent:config.backgroundBlurColorAlpha];
			blurEffectView.alpha = config.backgroundBlurAlpha;

			//view.alpha = config.backgroundBlurAlpha;

			view.backgroundColor = UIColor.clearColor;
			view.layer.cornerRadius = 30.0;
		} else {
			view.backgroundColor = config.customBGColor;
		}
	} else if (config.style == 1) {
		view.backgroundColor = UIColor.blackColor;
	}

	// Outline
	if (config.useOutline) {
		view.layer.borderWidth = config.outlineThickness;
		view.layer.borderColor = config.outlineColor.CGColor;
	}

	// Labels
	UIColor *labelColor;
	if (!config.useLabelColor) {
		if (config.style == 1) {
			labelColor = UIColor.whiteColor;
		} else {
			labelColor = UIColor.blackColor;
		}
	} else labelColor = config.labelColor;

	for (UIView *subview in view.subviews) {
		if ([subview isMemberOfClass:[UILabel class]]) {
			((UILabel *)subview).textColor = labelColor;
		}

		if ([subview.backgroundColor isEqual:UIColor.whiteColor]) {
			subview.backgroundColor = UIColor.clearColor;
		}
	}

	if (@available(iOS 13, *)) {
		MSHookIvar<UILabel *>(self, "leftBatteryLabel").textColor = labelColor;
		MSHookIvar<UILabel *>(self, "rightBatteryLabel").textColor = labelColor;
		MSHookIvar<UILabel *>(self, "bothBatteryLabel").textColor = labelColor;
		MSHookIvar<UILabel *>(self, "caseBatteryLabel").textColor = labelColor;
		MSHookIvar<UILabel *>(self, "mainBatteryLabel").textColor = labelColor;
	}
}
%end
%end

// ty @nepetadev for the ez piracy detection
%group AirPortPiracyWarning

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)arg1 {
    %orig;
	if (!dpkgInvalid) return;

	// yuck 
	UIWindow *key;
	for (UIWindow *window in ((UIApplication*)self).windows) {
    	if (window.isKeyWindow) {
			key = window;
        	break; // yuck yuck yuck
    	}
	}

    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:@"Uh-Oh!"
        message:@"This version of AirPort has been downloaded from an untrusted source.\nPlease download AirPort from:\nhttps://repo.packix.com/"
        preferredStyle:UIAlertControllerStyleAlert
    ];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [key.rootViewController dismissViewControllerAnimated:YES completion:NULL];
    }]];

    [key.rootViewController presentViewController:alertController animated:YES completion:NULL];
}

%end
%end

%ctor {
	dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.boo.airport13.list"];
	if (dpkgInvalid) %init(AirPortPiracyWarning);
	NSString *ver = [[UIDevice currentDevice] systemVersion];
	float ver_float = [ver floatValue];

  	bool enabled;
	bool proLegacy;

    NSString *processName = [NSProcessInfo processInfo].processName;
	// we have to check the process because for some reason sharingd does not play nicely with Cephei
	if ([processName isEqualToString:@"sharingd"]) {
		// as stated above, we have to 'manually' load the data into a dictionary
		NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.boo.airport.plist"];
  		enabled = [([prefs objectForKey:@"Enabled"] ?: @(YES)) boolValue];
		proLegacy = [([prefs objectForKey:@"ProLegacy"] ?: @(NO)) boolValue];
	} else {
		APConfig *config = [[APConfig alloc] init];
		enabled = config.enabled;
		proLegacy = config.proLegacy;
		if (config.enabled) {
			if ([processName isEqualToString:@"SharingViewService"]) %init(AirPortCustomAnim13);
		}
	}
	if (enabled && proLegacy && ver_float < 13.2) %init(AirPodProFix);
}