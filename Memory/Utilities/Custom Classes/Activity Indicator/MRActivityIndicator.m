//
//  MRActivityIndicator.m
//  My Moncalm
//
//  Created by Mayank Rikh on 10/02/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//


#import "MRActivityIndicator.h"

@interface MRActivityIndicator(){
    
    UIVisualEffectView *blurView;
    UIActivityIndicatorView *indicator;
}

@end


@implementation MRActivityIndicator

-(instancetype)initOnView:(UIView *)view withText:(NSString *)text{
    
    self = [super init];
    
    if(self){
        
        [self setClipsToBounds:YES];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self createOnView:view];
        
        [self createInsideViews];

        [self stopAnimating];
    }
    
    return self;
}

-(void)createBlurView{
    
    blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle: UIBlurEffectStyleDark]];
    
    [blurView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:blurView];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(blurView);
    
    NSMutableArray *customConstraints = [NSMutableArray new];
    
    [customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|" options:0 metrics:0 views:viewsDictionary]];
    
    [customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurView]|" options:0 metrics:0 views:viewsDictionary]];
    
    [self addConstraints:customConstraints];
}

-(void)createOnView:(UIView *)view{
    
    [view addSubview:self];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(self, view);
    
    NSMutableArray *customConstraints = [NSMutableArray new];
    
    [customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:0 views:viewsDictionary]];
    
    [customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:0 views:viewsDictionary]];
    
    [view addConstraints:customConstraints];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)createInsideViews{
    
    [self createBlurView];
    
//    imageView = [[UIImageView alloc] init];
//WithImage: [UIImage imageNamed:@"icMyWalletDappCoin"]];

    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    [indicator setHidesWhenStopped: YES];
    [indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [blurView.contentView addSubview:indicator];
    
    NSMutableArray *customConstraints = [NSMutableArray new];
    
    [customConstraints addObject:[NSLayoutConstraint constraintWithItem: indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:blurView.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
    [customConstraints addObject:[NSLayoutConstraint constraintWithItem: indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:blurView.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    [blurView.contentView addConstraints:customConstraints];
}

-(void)startAnimating{

    [indicator startAnimating];
    [self setHidden:NO];

//    [imageView.layer addAnimation:animation forKey:@"animation"];
}

-(void)stopAnimating{

    [indicator stopAnimating];
    [self setHidden:YES];
    
//    [imageView.layer removeAllAnimations];
}

@end
