#import "headers/UITableView-pr0crustes.h"


#define _PLIST @"/var/mobile/Library/Preferences/me.pr0crustes.smoothtable_prefs.plist"
#define pref_getValue(key) [[NSDictionary dictionaryWithContentsOfFile:_PLIST] valueForKey:key]
#define pref_getBool(key) [pref_getValue(key) boolValue]


CGFloat global_inset = 25.0;
CGFloat global_radius = 25.0;


%group GROUP_CELL_ROUNDING

	%hook UITableViewCell

		-(void)layoutSubviews {
			%orig;
			[self pr0crustes_roundCell];
		}

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

		%new
		-(void)pr0crustes_roundCorners:(UIRectCorner) corners {
			UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(global_radius, global_radius)];
			CAShapeLayer *layer = [CAShapeLayer layer];
			layer.frame = self.bounds;
			layer.path = path.CGPath;
			self.layer.mask = layer;
		}

	%end

%end



%group GROUP_TABLE_INSET

	%hook UITableView

		-(UIEdgeInsets)_sectionContentInset {
			UIEdgeInsets orig = %orig;
			return UIEdgeInsetsMake(orig.top, global_inset, orig.bottom, global_inset);
		}

		-(void)_setSectionContentInset:(UIEdgeInsets)insets {
			return %orig(UIEdgeInsetsMake(insets.top, global_inset, insets.bottom, global_inset));
		}

	%end

%end


static void loadPrefs() {
	global_inset = [pref_getValue(@"pref_inset") floatValue] ?: global_inset;
	global_radius = [pref_getValue(@"pref_radius") floatValue] ?: global_radius;
}


%ctor {

	loadPrefs();

	if (pref_getBool([@"EnabledApps-" stringByAppendingString:[NSBundle mainBundle].bundleIdentifier])) {

		NSLog(@"[SmoothTable] -> Enabling");

		if (pref_getBool(@"pref_enable_inset")) {
			%init(GROUP_TABLE_INSET);
		}
		if (pref_getBool(@"pref_enable_rounding")) {
			%init(GROUP_CELL_ROUNDING);
		}
	}
	
}
