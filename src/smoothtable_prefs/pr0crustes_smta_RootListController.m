#include "pr0crustes_smta_RootListController.h"

@implementation pr0crustes_smta_RootListController

	-(NSArray *)specifiers {
		if (!_specifiers)
			_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
		return _specifiers;
	}

	-(void)onClickSourceCode:(id)arg1 {
		NSURL *url = [NSURL URLWithString:@"https://github.com/pr0crustes/SmoothTable"];
		[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
	}

@end
