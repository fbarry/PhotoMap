//
//  PhotoAnnotation.m
//  PhotoMap
//
//  Created by Fiona Barry on 7/8/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

#import "PhotoAnnotation.h"

@interface PhotoAnnotation()

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation PhotoAnnotation

- (NSString *)title {
    return [NSString stringWithFormat:@"%f", self.coordinate.latitude];
}
@end
