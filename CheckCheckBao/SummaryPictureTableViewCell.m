//
//  SummaryPictureTableViewCell.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/19.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "SummaryPictureTableViewCell.h"
#import "ImagePriceCollectionViewCell.h"
#import "DetailImageViewController.h"


@implementation SummaryPictureTableViewCell{
    
    BaoController *baoController;
}


- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}








#pragma mark - button






/*
 -(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
 UICollectionReusableView *reusableview = nil;
 
 if (kind == UICollectionElementKindSectionHeader) {
 ImageHeaderCollectionReusableView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCollectionCell" forIndexPath:indexPath];
 ImageHeaderCollectionReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCollectionCell" forIndexPath:indexPath];
 BaoAlbum *baoAlbum = [baoController.baoAlbums objectAtIndex:indexPath.section];
 
 NSString *title = [NSString stringWithFormat:@"Monthly Sum: %f$", baoAlbum.sum];
 header.labelPrice.text = title;
 
 header.labelHeader.text = [NSString stringWithFormat:@"%@ / %@", baoAlbum.year, baoAlbum.month];
 
 
 return header;
 }
 
 
 if (kind == UICollectionElementKindSectionFooter) {
 
 UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
 
 reusableview = footerview;
 }
 
 return nil;
 }*/

@end
