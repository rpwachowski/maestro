#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

// TODO: Use a non-private API for Bezier interpolation
@interface CAMediaTimingFunction (Solving)
- (float)_solveForInput:(float)value;
@end

NS_ASSUME_NONNULL_END
