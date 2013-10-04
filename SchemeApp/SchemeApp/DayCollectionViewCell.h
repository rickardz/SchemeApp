//
//  DayCollectionViewCell.h
//  SchemeApp
//
//  Created by Henrik on 2013-10-01.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

@import UIKit;


@interface DayCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSDate *date;

@end
