// Macros that will be used for loading prefs
#define _PLIST "/var/mobile/Library/Preferences/me.pr0crustes.smoothtable_prefs.plist"
#define pref_getValue(key) [[NSDictionary dictionaryWithContentsOfFile:@(_PLIST)] valueForKey:key]
#define pref_getBool(key) [pref_getValue(key) boolValue]

// Globals vars
BOOL global_enabled_inset = false;
BOOL global_force_inset = false;
BOOL global_enabled_round = false;
CGFloat global_inset = 25.0;
CGFloat global_radius = 25.0;

// Static function (pure C) that will be used to load the prefs (using macros)
static void loadPrefs() {
	global_enabled_inset = pref_getBool(@"pref_enable_inset");
	global_force_inset = pref_getBool(@"pref_force_inset");
	global_enabled_round = pref_getBool(@"pref_enable_rounding");
	global_inset = [pref_getValue(@"pref_inset") floatValue] ?: global_inset;
	global_radius = [pref_getValue(@"pref_radius") floatValue] ?: global_radius;
}

// Definition of PSTableCell, will be used later
@interface PSTableCell : UITableViewCell
	-(void)layoutSubviews;
	-(int)sectionLocation;  // Location is an int in range [1, 4]: 
							// 1 - is in the middle of 2 cells 
							// 2 - is the top cell 
							// 3 - is the bottom cell 
							// 4 - is a isolated cell 
	// New methods
	-(void)pr0crustes_roundCell;
	-(void)pr0crustes_roundCorners:(UIRectCorner) corners;
@end

%group CELL  // Creates a group called `CELL` that will hook everything related to the cell rounding

	%hook PSTableCell  // Hooks the class PSTableCell

		// layoutSubviews is a method inherit from UIView
		// called when sub or parent views changes
		-(void)layoutSubviews {
			%orig;
			[self pr0crustes_roundCell];
		}

		// Custom method that checks the cell sectionLocation
		// and calls `pr0crustes_roundCorners` accordingly
		%new
		-(void)pr0crustes_roundCell {
			[self pr0crustes_roundCorners:nil]; // Reset just to be sure
			switch ([self sectionLocation]) {
				case 4:  // Isolated
					[self pr0crustes_roundCorners:UIRectCornerAllCorners];
					break;
				case 3:  // Bottom
					[self pr0crustes_roundCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
					break;
				case 2:  // Top
					[self pr0crustes_roundCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
					break;
			}
		}

		// Custom method that rounds the cell (can be used to any UIView)
		// accordingly to the UIRectCorner received
		%new
		-(void)pr0crustes_roundCorners:(UIRectCorner) corners {
			UIBezierPath *path = [UIBezierPath 
						bezierPathWithRoundedRect:self.bounds 
						byRoundingCorners:corners 
						cornerRadii:CGSizeMake(global_radius, global_radius)];
			CAShapeLayer *layer = [CAShapeLayer layer];
			layer.frame = self.bounds;
			layer.path = path.CGPath;
			self.layer.mask = layer;
		}

	%end  // End of PSTableCell hook

%end  // End of `CELL` group

%group TABLE  // Creates a group called `TABLE` that will hook everything related to table inset

	%hook UITableView  // Hooks the class UITableView

		// One of the methods used to add inset to the table
		-(UIEdgeInsets)_sectionContentInset {
			UIEdgeInsets orig = %orig;
			return UIEdgeInsetsMake(orig.top, global_inset, orig.bottom, global_inset);
		}

		// One of the methods used to add inset to the table
		-(void)_setSectionContentInset:(UIEdgeInsets)insets {
			return %orig(UIEdgeInsetsMake(insets.top, global_inset, insets.bottom, global_inset));
		}

	%end  // End of UITableView hook

%end  // End of `TABLE` group

// Static function (pure C) that checks if any string in `substrings` is inside `mainstring`
static BOOL containsAny(NSString *mainstring, NSArray *substrings) {
	for (NSString *sub in substrings) {
		if ([mainstring rangeOfString:sub].location != NSNotFound)
			return true;
	}
	return false;
}

// Static function (pure C) that checks if the tweak should or not launch
static BOOL shouldLaunch() {
	NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
	if (args.count > 0) {
		NSString *exec = args[0];
		if (exec) {
			NSString *process = [exec lastPathComponent];
			return containsAny(process, [NSArray arrayWithObjects:@"SpringBoard", @"Preferences", nil]);
		}
	}
	return false;
}

// Logos contructor (the code execution starts here)
%ctor { 

	loadPrefs();  // Updates the global values

	// Starts the tweak accordingly to the `shouldLaunch` and to the prefs
	if (global_enabled_inset && (global_force_inset || shouldLaunch())) {
		%init(TABLE);  // Inits the group `TABLE` (hooking the classes inside)
		if (global_enabled_round)
			%init(CELL);  // Inits the group `CELL` (hooking the classes inside)
	}
}
