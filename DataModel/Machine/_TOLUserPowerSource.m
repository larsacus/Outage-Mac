// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TOLUserPowerSource.m instead.

#import "_TOLUserPowerSource.h"

const struct TOLUserPowerSourceAttributes TOLUserPowerSourceAttributes = {
	.serialNumber = @"serialNumber",
	.timeOnBattery = @"timeOnBattery",
	.transportType = @"transportType",
	.type = @"type",
};

const struct TOLUserPowerSourceRelationships TOLUserPowerSourceRelationships = {
};

const struct TOLUserPowerSourceFetchedProperties TOLUserPowerSourceFetchedProperties = {
};

@implementation TOLUserPowerSourceID
@end

@implementation _TOLUserPowerSource

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PowerSource" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PowerSource";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PowerSource" inManagedObjectContext:moc_];
}

- (TOLUserPowerSourceID*)objectID {
	return (TOLUserPowerSourceID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"timeOnBatteryValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"timeOnBattery"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"transportTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"transportType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic serialNumber;






@dynamic timeOnBattery;



- (int32_t)timeOnBatteryValue {
	NSNumber *result = [self timeOnBattery];
	return [result intValue];
}

- (void)setTimeOnBatteryValue:(int32_t)value_ {
	[self setTimeOnBattery:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTimeOnBatteryValue {
	NSNumber *result = [self primitiveTimeOnBattery];
	return [result intValue];
}

- (void)setPrimitiveTimeOnBatteryValue:(int32_t)value_ {
	[self setPrimitiveTimeOnBattery:[NSNumber numberWithInt:value_]];
}





@dynamic transportType;



- (int32_t)transportTypeValue {
	NSNumber *result = [self transportType];
	return [result intValue];
}

- (void)setTransportTypeValue:(int32_t)value_ {
	[self setTransportType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTransportTypeValue {
	NSNumber *result = [self primitiveTransportType];
	return [result intValue];
}

- (void)setPrimitiveTransportTypeValue:(int32_t)value_ {
	[self setPrimitiveTransportType:[NSNumber numberWithInt:value_]];
}





@dynamic type;



- (int32_t)typeValue {
	NSNumber *result = [self type];
	return [result intValue];
}

- (void)setTypeValue:(int32_t)value_ {
	[self setType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTypeValue {
	NSNumber *result = [self primitiveType];
	return [result intValue];
}

- (void)setPrimitiveTypeValue:(int32_t)value_ {
	[self setPrimitiveType:[NSNumber numberWithInt:value_]];
}










@end
