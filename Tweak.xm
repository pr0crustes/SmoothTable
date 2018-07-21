

BOOL global_enabled_round = true;
BOOL global_enabled_inset = true;
BOOL global_force_inset = false;

CGFloat global_inset = 25.0;
CGFloat global_radius = 25.0;

@interface PSTableCell : UITableViewCell
	-(void)layoutSubviews;
	-(int)sectionLocation;  // Location is an int in range [1, 4]: // 1 - is in the middle of 2 cells // 2 - is the top cell // 3 - is the bottom cell // 4 - is a isolated cell 
	// News
	-(void)pr0crustes_roundCell;
	-(void)pr0crustes_roundCorners:(UIRectCorner) corners;
@end

%group CELL
	%hook PSTableCell
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
			UIBezierPath *path = [UIBezierPath 
						bezierPathWithRoundedRect:self.bounds 
						byRoundingCorners:corners 
						cornerRadii:CGSizeMake(global_radius, global_radius)];
			CAShapeLayer *layer = [CAShapeLayer layer];
			layer.frame = self.bounds;
			layer.path = path.CGPath;
			self.layer.mask = layer;
		}
	%end
%end

%group TABLE
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

BOOL containsAny(NSString *string, NSArray *substrings) {
	for (NSString *sub in substrings) {
		if ([string rangeOfString:sub].location != NSNotFound)
			return true;
	}
	return false;
}

BOOL shouldLaunch() {
	NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
	if (args.count > 0) {
		NSString *exec = args[0];
		if (exec) {
			NSString *process = [exec lastPathComponent];
			NSLog(@"LOGGING exec %@, process %@", exec, process);
			return containsAny(process, [NSArray arrayWithObjects:@"SpringBoard", @"Preferences", nil]);
		}
	}
	return false;
}

%ctor { 

	if (global_enabled_inset && (global_force_inset || shouldLaunch())) {
		%init(TABLE);
		if (global_enabled_round)
			%init(CELL);
	}
}
