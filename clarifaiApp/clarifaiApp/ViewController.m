//
//  ViewController.m
//  clarifaiApp
//
//  Created by John Bogil on 8/25/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *photoLibraryButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTagsForTestURL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getTagsForTestURL {
   // NSString *dataUrl = [NSString stringWithFormat:@"https://api.clarifai.com/v1/tag/?encoded_data=assets-library://asset/asset.JPG?id=5271EBE9-3BBF-4177-B045-A9078BFC1C62&ext=JPG"];
    NSString *dataUrl = [NSString stringWithFormat:@"encoded_data=assets-library://asset/asset.JPG?id=5271EBE9-3BBF-4177-B045-A9078BFC1C62&ext=JPG"];
    NSURL *url = [NSURL URLWithString: dataUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"Bearer mf3ZEgCQppI6ERVWTzUP7VbwvOhc2j" forHTTPHeaderField:@"Authorization"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
}
- (IBAction)photoLibraryButtonPressed:(id)sender {
    
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage,
      (NSString *) kUTTypeMovie];
    
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}
- (IBAction)cameraButtonPressed:(id)sender {
    
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage,
      (NSString *) kUTTypeMovie];
    
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}

-(void)imagePickerController:
(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                NSLog(@"error");
            } else {
                NSLog(@"url %@", assetURL);
            }  
        }];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        NSURL *url = info[UIImagePickerControllerMediaURL];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
