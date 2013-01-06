// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TOLUserPowerSource.h instead.

#import <CoreData/CoreData.h>


extern const struct TOLUserPowerSourceAttributes {
	__unsafe_unretained NSString *serialNumber;
	__unsafe_unretained NSString *timeOnBattery;
	__unsafe_unretained NSString *transportType;
	__unsafe_unretained NSString *type;
} TOLUserPowerSourceAttributes;

extern const struct TOLUserPowerSourceRelationships {
} TOLUserPowerSourceRelationships;

extern const struct TOLUserPowerSourceFetchedProperties {
} TOLUserPowerSourceFetchedProperties;







@interface TOLUserPowerSourceID : NSManagedObjectID {}
@end

@interface _TOLUserPowerSource : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TOLUserPowerSourceID*)objectID;




@property (nonatomic, strong) NSString* serialNumber;


//- (BOOL)validateSerialNumber:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* timeOnBattery;


@property int32_t timeOnBatteryValue;
- (int32_t)timeOnBatteryValue;
- (void)setTimeOnBatteryValue:(int32_t)value_;

//- (BOOL)validateTimeOnBattery:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* transportType;


@property int32_t transportTypeValue;
- (int32_t)transportTypeValue;
- (void)setTransportTypeValue:(int32_t)value_;

//- (BOOL)validateTransportType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* type;


@property int32_t typeValue;
- (int32_t)typeValue;
- (void)setTypeValue:(int32_t)value_;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;






@end

@interface _TOLUserPowerSource (CoreDataGeneratedAccessors)

@end

@interface _TOLUserPowerSource (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveSerialNumber;
- (void)setPrimitiveSerialNumber:(NSString*)value;




- (NSNumber*)primitiveTimeOnBattery;
- (void)setPrimitiveTimeOnBattery:(NSNumber*)value;

- (int32_t)primitiveTimeOnBatteryValue;
- (void)setPrimitiveTimeOnBatteryValue:(int32_t)value_;




- (NSNumber*)primitiveTransportType;
- (void)setPrimitiveTransportType:(NSNumber*)value;

- (int32_t)primitiveTransportTypeValue;
- (void)setPrimitiveTransportTypeValue:(int32_t)value_;




- (NSNumber*)primitiveType;
- (void)setPrimitiveType:(NSNumber*)value;

- (int32_t)primitiveTypeValue;
- (void)setPrimitiveTypeValue:(int32_t)value_;




@end
