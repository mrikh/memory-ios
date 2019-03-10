//
//  MRActivityIndicator.h
//  My Moncalm
//
//  Created by Mayank Rikh on 10/02/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRActivityIndicator : UIView

-(instancetype)initOnView:(UIView *)view withText:(NSString *)text;

-(void)startAnimating;

-(void)stopAnimating;

@end
