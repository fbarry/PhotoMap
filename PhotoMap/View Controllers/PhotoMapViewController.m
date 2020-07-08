//
//  PhotoMapViewController.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

#import "PhotoMapViewController.h"
#import "LocationsViewController.h"
#import "FullImageViewController.h"
#import <MapKit/MapKit.h>
#import "PhotoAnnotation.h"

@interface PhotoMapViewController () <MKMapViewDelegate, LocationsViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UIImage *image;

@end

@implementation PhotoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:sfRegion animated:false];
}

- (IBAction)didTapCamera:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pick Image Source" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Take New Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setPicture:CAMERA];
    }];
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"Choose Existing Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setPicture:PHOTOS];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:camera];
    [alert addAction:photos];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setPicture:(SelectionType)type {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || type == PHOTOS) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    self.image = info[UIImagePickerControllerOriginalImage];
        
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"tagSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tagSegue"]) {
        LocationsViewController *locationsViewController = [segue destinationViewController];
        locationsViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"fullImageSegue"]) {
        FullImageViewController *fullImageViewController = [segue destinationViewController];
        fullImageViewController.image = sender;
    }
}

- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    
    PhotoAnnotation *annotation = [[PhotoAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.photo = [self resizeImage:self.image withSize:CGSizeMake(50.0, 50.0)];
    [self.mapView addAnnotation:annotation];
    
    [self.navigationController popToViewController:self animated:YES];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];

    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;

    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[self resizeImage:self.image withSize:annotationView.image.size]];
        image.layer .cornerRadius = image.layer.frame.size.width / 2;
        image.layer.masksToBounds = YES;
        
        [annotationView addSubview:image];
        
        annotationView.canShowCallout = true;
        
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
        leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        leftImageView.clipsToBounds = YES;
        
        annotationView.leftCalloutAccessoryView = leftImageView;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }

    UIImageView *imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
    imageView.image = self.image;

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([control isKindOfClass:[UIButton class]]) {
        UIImageView *imageView = (UIImageView *)view.leftCalloutAccessoryView;
        [self performSegueWithIdentifier:@"fullImageSegue" sender:imageView.image];
    }
}

@end
