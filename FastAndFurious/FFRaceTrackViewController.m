#import "FFRaceTrackViewController.h"
#import "FFRaceCar.h"
#import "FastAndFurious-Swift.h"

float const trackLength = 200;
float const carLength = 50;
float const laneSpacer = 10;
float const startingYValue = 100;
float const finishLineWidth = 20;
float const startingLineWidth = 2;

@interface FFRaceTrackViewController () <RaceTrackObservable>

@property (nonatomic, strong) RaceTrack *raceTrack;
@property (nonatomic, strong) NSDictionary<NSString *, FFRacecar *> *racecarsForIdentifiers;
@property (nonatomic, strong) NSDictionary<NSString *, UIView *> *viewsForIdentifiers;

@end

@implementation FFRaceTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRaceTrack];
    [self setUpStartingLine];
    [self setUpFinishLine];
    [self setUpRacecarViews];
    [self.raceTrack startRace];
}

- (void)setUpRaceTrack {
    NSArray <FFRacecar *> *raceCars = @[
                                       [[FFRacecar alloc] initWithTopSpeed:130 durability:75],
                                       [[FFRacecar alloc] initWithTopSpeed:150 durability:60],
                                       [[FFRacecar alloc] initWithTopSpeed:140 durability:80]
                                       ];
    [self setUpRacecarsForIdentifiersWithCars:raceCars];
    self.raceTrack = [[RaceTrack alloc] initWithRaceCars:raceCars
                                             trackLength:trackLength
                                                observer:self];
}

- (void)setUpRacecarsForIdentifiersWithCars:(NSArray <FFRacecar *> *)cars {
    NSMutableDictionary<NSString *, FFRacecar *> *carsForId = [NSMutableDictionary new];
    for (FFRacecar *car in cars) {
        carsForId[car.racecarID] = car;
    }
    self.racecarsForIdentifiers = carsForId.copy;
}

// set up race track


// set up race cars for identifiers with: (FFRacecars)

- (void)setUpStartingLine {
    NSInteger numberOfCars = self.racecarsForIdentifiers.count;
    float lineLength = carLength * numberOfCars + (numberOfCars - 1) * laneSpacer;
    UIView *line = [[UIView alloc] initWithFrame:
                    CGRectMake(carLength, startingYValue, startingLineWidth, lineLength)];
    [line setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:line];
}

// Set Up Finish line

- (void)setUpRacecarViews {
    float currentY = startingYValue;
    NSMutableDictionary<NSString *, UIView *> *viewsForIdentifiers = [NSMutableDictionary new];

    for (NSString *identifier in self.racecarsForIdentifiers.allKeys) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, carLength, carLength)];
        [view setBackgroundColor:[UIColor redColor]];
        viewsForIdentifiers[identifier] = view;
        [self.view addSubview:view];

        currentY += (carLength + laneSpacer);
    }

    self.viewsForIdentifiers = viewsForIdentifiers.copy;
}

- (void)removeRacecarViews {
    for (UIView *view in self.viewsForIdentifiers.allValues) {
        [view removeFromSuperview];
    }
    self.viewsForIdentifiers = nil;
}

// MARK: RaceTrackObservable

- (void)racecarsDidMoveWithDistancesForIdentifiers:(NSDictionary<NSString *,NSNumber *> *)distancesForIdentifiers {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        for (NSString *identification in distancesForIdentifiers.allKeys) {
            UIView *view = self.viewsForIdentifiers[identification];
    
            float distanceTraveled = distancesForIdentifiers[identification].floatValue;
            float newX = distanceTraveled / trackLength * CGRectGetWidth(view.frame);
            
            CGPoint newOrigin = CGPointMake(newX, view.frame.origin.y);
            
            view.frame = CGRectMake(newOrigin.x,
                                    newOrigin.y,
                                    carLength,
                                    carLength);
        }
    }];
}

@end
