// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TOLBatterySession.m instead.

#import "_TOLBatterySession.h"

const struct TOLBatterySessionAttributes TOLBatterySessionAttributes = {
	.beginCapacity = @"beginCapacity",
	.beginTime = @"beginTime",
	.endCapacity = @"endCapacity",
	.endTime = @"endTime",
	.wasInturrupted = @"wasInturrupted",
};

const struct TOLBatterySessionRelationships TOLBatterySessionRelationships = {
	.powerSource = @"powerSource",
};

const struct TOLBatterySessionFetchedProperties TOLBatterySessionFetchedProperties = {
};

@implementation TOLBatterySessionID
@end

@implementation _TOLBatterySession

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BatterySession" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BatterySession";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BatterySession" inManagedObjectContext:moc_];
}

- (TOLBatterySessionID*)objectID {
	return (TOLBatterySessionID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"beginCapacityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"beginCapacity"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"endCapacityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"endCapacity"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"wasInturruptedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"wasInturrupted"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic beginCapacity;



- (float)beginCapacityValue {
	NSNumber *result = [self beginCapacity];
	return [result floatValue];
}

- (void)setBeginCapacityValue:(float)value_ {
	[self setBeginCapacity:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveBeginCapacityValue {
	NSNumber *result = [self primitiveBeginCapacity];
	return [result floatValue];
}

- (void)setPrimitiveBeginCapacityValue:(float)value_ {
	[self setPrimitiveBeginCapacity:[NSNumber numberWithFloat:value_]];
}





@dynamic beginTime;






@dynamic endCapacity;



- (float)endCapacityValue {
	NSNumber *result = [self endCapacity];
	return [result floatValue];
}

- (void)setEndCapacityValue:(float)value_ {
	[self setEndCapacity:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveEndCapacityValue {
	NSNumber *result = [self primitiveEndCapacity];
	return [result floatValue];
}

- (void)setPrimitiveEndCapacityValue:(float)value_ {
	[self setPrimitiveEndCapacity:[NSNumber numberWithFloat:value_]];
}





@dynamic endTime;






@dynamic wasInturrupted;



- (BOOL)wasInturruptedValue {
	NSNumber *result = [self wasInturrupted];
	return [result boolValue];
}

- (void)setWasInturruptedValue:(BOOL)value_ {
	[self setWasInturrupted:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveWasInturruptedValue {
	NSNumber *result = [self primitiveWasInturrupted];
	return [result boolValue];
}

- (void)setPrimitiveWasInturruptedValue:(BOOL)value_ {
	[self setPrimitiveWasInturrupted:[NSNumber numberWithBool:value_]];
}





@dynamic powerSource;

	






@end
