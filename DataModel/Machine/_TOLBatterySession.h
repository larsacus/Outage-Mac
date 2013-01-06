// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TOLBatterySession.h instead.

#import <CoreData/CoreData.h>


extern const struct TOLBatterySessionAttributes {
	__unsafe_unretained NSString *beginCapacity;
	__unsafe_unretained NSString *beginTime;
	__unsafe_unretained NSString *endCapacity;
	__unsafe_unretained NSString *endTime;
	__unsafe_unretained NSString *wasInturrupted;
} TOLBatterySessionAttributes;

extern const struct TOLBatterySessionRelationships {
	__unsafe_unretained NSString *powerSource;
} TOLBatterySessionRelationships;

extern const struct TOLBatterySessionFetchedProperties {
} TOLBatterySessionFetchedProperties;

@class TOLUserPowerSource;







@interface TOLBatterySessionID : NSManagedObjectID {}
@end

@interface _TOLBatterySession : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TOLBatterySessionID*)objectID;




@property (nonatomic, strong) NSNumber* beginCapacity;


@property float beginCapacityValue;
- (float)beginCapacityValue;
- (void)setBeginCapacityValue:(float)value_;

//- (BOOL)validateBeginCapacity:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate* beginTime;


//- (BOOL)validateBeginTime:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* endCapacity;


@property float endCapacityValue;
- (float)endCapacityValue;
- (void)setEndCapacityValue:(float)value_;

//- (BOOL)validateEndCapacity:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate* endTime;


//- (BOOL)validateEndTime:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* wasInturrupted;


@property BOOL wasInturruptedValue;
- (BOOL)wasInturruptedValue;
- (void)setWasInturruptedValue:(BOOL)value_;

//- (BOOL)validateWasInturrupted:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TOLUserPowerSource* powerSource;

//- (BOOL)validatePowerSource:(id*)value_ error:(NSError**)error_;





@end

@interface _TOLBatterySession (CoreDataGeneratedAccessors)

@end

@interface _TOLBatterySession (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveBeginCapacity;
- (void)setPrimitiveBeginCapacity:(NSNumber*)value;

- (float)primitiveBeginCapacityValue;
- (void)setPrimitiveBeginCapacityValue:(float)value_;




- (NSDate*)primitiveBeginTime;
- (void)setPrimitiveBeginTime:(NSDate*)value;




- (NSNumber*)primitiveEndCapacity;
- (void)setPrimitiveEndCapacity:(NSNumber*)value;

- (float)primitiveEndCapacityValue;
- (void)setPrimitiveEndCapacityValue:(float)value_;




- (NSDate*)primitiveEndTime;
- (void)setPrimitiveEndTime:(NSDate*)value;




- (NSNumber*)primitiveWasInturrupted;
- (void)setPrimitiveWasInturrupted:(NSNumber*)value;

- (BOOL)primitiveWasInturruptedValue;
- (void)setPrimitiveWasInturruptedValue:(BOOL)value_;





- (TOLUserPowerSource*)primitivePowerSource;
- (void)setPrimitivePowerSource:(TOLUserPowerSource*)value;


@end
