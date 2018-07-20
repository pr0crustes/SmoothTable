BOOL global_enabled_round = true;
BOOL global_enabled_inset = true;
BOOL global_force_round = true;

CGFloat global_inset = 15.0;
CGFloat global_radius = 25.0;


void roundViewCorners(UIView *view, UIRectCorner corners) {
	UIBezierPath *path = [UIBezierPath 
							bezierPathWithRoundedRect:view.bounds 
							byRoundingCorners:corners 
							cornerRadii:CGSizeMake(global_radius, global_radius)];
	CAShapeLayer *layer = [CAShapeLayer layer];
	layer.frame = view.bounds;
	layer.path = path.CGPath;
	view.layer.mask = layer;
}

void willDisplayCell(id instance, SEL selector, UITableView *table, UITableViewCell *cell, NSIndexPath* indexPath) {
	BOOL isAtTop = indexPath.row == 0;
	BOOL isAtBottom = indexPath.row == [table numberOfRowsInSection:indexPath.section] - 1;

	if (isAtTop && isAtBottom) {
		roundViewCorners(cell, UIRectCornerAllCorners);
	} else if (isAtTop) {
		roundViewCorners(cell, UIRectCornerTopLeft|UIRectCornerTopRight);
	} else if (isAtBottom) {
		roundViewCorners(cell, UIRectCornerBottomLeft|UIRectCornerBottomRight);
	}
}


%group CIRCULAR_TABLE

	%hook UITableView

		-(UIEdgeInsets)_sectionContentInset {
			UIEdgeInsets orig = %orig;
			if (global_enabled_inset)
				return UIEdgeInsetsMake(orig.top, global_inset, orig.bottom, global_inset);
			return orig;
		}

		-(void)_setSectionContentInset:(UIEdgeInsets)insets {
			if (global_enabled_inset)
				return %orig(UIEdgeInsetsMake(insets.top, global_inset, insets.bottom, global_inset));
			return %orig;
		}

		-(void)setDelegate:(id)arg1 {
			class_addMethod([arg1 class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)willDisplayCell, "@@:@@");
			%orig;
		}
		
	%end

%end


BOOL containsAny(NSString *string, NSArray *substrings) {
	for (NSString *sub in substrings) {
		if ([string rangeOfString:sub].location != NSNotFound) {
			return true;
		}
	}
	return false;
}

%ctor {

	NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
	if (global_force_round || args.count > 0) {
		NSString *exec = args[0];
		if (global_force_round || exec) {
			NSString *process = [exec lastPathComponent];
			if (global_force_round || containsAny(process, [NSArray arrayWithObjects:@"SpringBoard", @"/Application", nil])) {
				%init(CIRCULAR_TABLE);
			}
		}
	}
}
