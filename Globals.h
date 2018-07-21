#define _PLIST "/var/mobile/Library/Preferences/me.pr0crustes.smoothtable.plist"

#define pref_getValue(key) [[NSDictionary dictionaryWithContentsOfFile:@(_PLIST)] valueForKey:key]
#define pref_getBool(key) [pref_getValue(key) boolValue]
