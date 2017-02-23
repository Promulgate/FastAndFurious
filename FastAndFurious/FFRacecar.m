#import "FFRacecar.h"

@implementation FFRacecar

@synthesize topSpeed = _topSpeed;
@synthesize durability = _durability;
@synthesize racecarID = _racecarID;

- (instancetype)initWithTopSpeed:(float)topSpeed
                      durability:(float)durability {
    self = [super init];
    if (self) {
        _topSpeed = topSpeed;
        _durability = durability;
        _racecarID = [NSUUID UUID]. UUIDString;
    }
    return self;
}

@end
