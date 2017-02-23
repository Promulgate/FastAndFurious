#import <Foundation/Foundation.h>

// protocol here.. please.. i'm begging you

@protocol FFRaceable <NSObject>

@property (nonatomic, readonly) float topSpeed;
@property (nonatomic, readonly) float durability;
@property (nonatomic, readonly) NSString *racecarID;

@end
