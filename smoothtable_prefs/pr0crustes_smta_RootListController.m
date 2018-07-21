#include "pr0crustes_smta_RootListController.h"

@implementation pr0crustes_smta_RootListController

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
		}
		return _specifiers;
	}

	-(id)getPrefValue:(PSSpecifier *)spec {
		NSMutableDictionary *dict = [self dictionaryFromSpecifierFile:spec];
		id prop = [spec properties];
		return dict[prop[@"key"]] ?: prop[@"default"];
	}
	
	-(void)setPrefValue:(PSSpecifier *)spec value:(id)value {
		NSMutableDictionary *dict = [self dictionaryFromSpecifierFile:spec];
		[dict setObject:value forKey:[spec properties][@"key"]];
		NSString *file_path = [self getFileFromSpecifier:spec];
		[dict writeToFile:file_path atomically:YES];
	}

	-(NSString *)getFileFromSpecifier:(PSSpecifier *)spec {
		return [NSString stringWithFormat:@"/private/var/mobile/Library/Preferences/%@.plist", [spec properties][@"defaults"]];
	}

	-(NSMutableDictionary *)dictionaryFromSpecifierFile:(PSSpecifier *)spec {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		NSString *file_path = [self getFileFromSpecifier:spec];
		NSDictionary *file_content = [NSDictionary dictionaryWithContentsOfFile:file_path];
		[dict addEntriesFromDictionary:file_content];
		return dict;
	}

@end
