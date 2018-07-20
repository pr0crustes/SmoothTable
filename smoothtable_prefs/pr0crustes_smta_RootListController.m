#include "pr0crustes_smta_RootListController.h"

@implementation pr0crustes_smta_RootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

@end
