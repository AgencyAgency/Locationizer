//
//  NSArray+PDCUtils.m
//  Locationizer
//
//  Created by Kyle Oba on 5/7/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "NSArray+PDCUtils.h"

@implementation NSArray (PDCUtils)

- (id)nthObject:(NSUInteger)n default:(id)marker {
    return (self.count > n)? self[n] : marker;
}

- (id)nthObject:(NSUInteger)n {
    return [self nthObject:n default:nil];
}

- (id)firstObject {
    return [self nthObject:0];
}

@end
