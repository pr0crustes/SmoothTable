#include "pr0_smthRootListController.h"

@implementation pr0_smthRootListController

	-(id)init {
		if ((self = [super init]) != nil)
			_settings = [NSMutableDictionary dictionaryWithContentsOfFile:_plistfile] ?: [NSMutableDictionary dictionary];
		return self;
	}

	- (id)specifiers {
		if (_specifiers == nil)
			_specifiers = [self loadSpecifiersFromPlistName:@"Root.plist" target:self];
		return _specifiers;
	}

@end
