//
//  SummaryPictureTableViewCell.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/19.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "SummaryPictureTableViewCell.h"
#import "ImagePriceCollectionViewCell.h"


@implementation SummaryPictureTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - collection view delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.baoImages.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImagePriceCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"priceCollectionCell" forIndexPath:indexPath];
    BaoImage *baoImage = [self.baoImages objectAtIndex:indexPath.row];
    
    //label
    cell.labelPrice.text = [baoImage getStringPrice];
    cell.labelTime.text = [baoImage getStringTime];
    
    
    //image
    UIImage *image = [[BaoController shareController] fetchImageFromAssetURL:baoImage.imageURL];
    
    if (image) {
        NSLog(@"have image url:%@", baoImage.imageURL);
        cell.imageView.image = image;
        
    }else {
        NSLog(@"no image");
        [cell.imageView setBackgroundColor:[UIColor grayColor]];
        cell.imageView.alpha = 0.5;
        
    }
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"image touch at row:%li", indexPath.row);
}


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
