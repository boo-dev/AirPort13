#import <Cephei/HBPreferences.h>
#import <libcolorpicker.h>

@interface APConfig : NSObject
@property (nonatomic,assign) bool enabled;

@property (nonatomic, assign) int style;

//AP Pro
@property (nonatomic,assign) bool proLegacy;
@property (nonatomic,assign) bool proCustomAnim;
@property (nonatomic,retain) NSString *proAnimPath;
@property (nonatomic,retain) NSString *proAnimName;

//APW
@property (nonatomic,assign) bool apwCustomAnim;
@property (nonatomic,retain) NSString *apwAnimPath;
@property (nonatomic,retain) NSString *apwAnimName;

//AP
@property (nonatomic,assign) bool apCustomAnim;
@property (nonatomic,retain) NSString *apAnimPath;
@property (nonatomic,retain) NSString *apAnimName;

// Haptics
@property (nonatomic, assign) bool hapticFeedback;
@property (nonatomic, assign) int hapticForce;

// BG Style
@property (nonatomic, assign) bool useCustomBGColor;
@property (nonatomic, retain) UIColor *customBGColor;

// Outline Style
@property (nonatomic, assign) bool useOutline;
@property (nonatomic, assign) double outlineThickness;
@property (nonatomic, retain) UIColor *outlineColor;

@property (nonatomic, assign) bool useLabelColor;
@property (nonatomic, retain) UIColor *labelColor;

// BG Blur
@property (nonatomic, assign) double backgroundBlurColorAlpha;
@property (nonatomic, assign) int backgroundBlurMode;
@property (nonatomic, assign) double backgroundBlurAlpha;
//@property (nonatomic, retain) UIColor *blurColor;

-(APConfig *)init;
@end