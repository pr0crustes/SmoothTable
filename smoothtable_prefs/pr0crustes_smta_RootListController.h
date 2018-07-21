#import <Preferences/PSListController.h>

@interface pr0crustes_smta_RootListController : PSListController
    -(id)getPrefValue:(PSSpecifier *)spec;
    -(void)setPrefValue:(PSSpecifier *)spec value:(id)value;
@end
