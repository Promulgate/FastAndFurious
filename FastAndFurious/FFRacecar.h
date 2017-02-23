#import <Foundation/Foundation.h>
#import "FFRaceable.h"

@interface FFRacecar : NSObject <FFRaceable>

- (instancetype)initWithTopSpeed:(float)topSpeed
                      durability:(float)durability;

@end
