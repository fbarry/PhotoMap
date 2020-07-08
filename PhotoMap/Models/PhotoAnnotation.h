//
//  PhotoAnnotation.h
//  PhotoMap
//
//  Created by Fiona Barry on 7/8/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) UIImage *photo;

@end

NS_ASSUME_NONNULL_END
