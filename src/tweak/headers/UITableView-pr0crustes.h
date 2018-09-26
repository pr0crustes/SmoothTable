@interface UITableViewCell (pr0crustes)
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
