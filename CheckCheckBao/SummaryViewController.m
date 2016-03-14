//
//  SummaryViewController.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController{
    
    __block BaoController *baoController;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //baoController
    [self setupController];
    
    //collection view
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - controller
-(void)setupController{
    if (baoController == nil) {
        baoController = [BaoController sharedController];
        baoController.delegateBaoController = self;
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.collectionView reloadData];
    [super viewWillAppear:animated];
}

#pragma mark - collection view delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSLog(@"section count: %li",baoController.baoAlbums.count);
    return baoController.baoAlbums.count;
    //return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    BaoAlbum *baoAlbum = [baoController.baoAlbums objectAtIndex:section];
    NSLog(@"image count:%li", baoAlbum.baoImages.count);
    return baoAlbum.baoImages.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImagePriceCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"priceCollectionCell" forIndexPath:indexPath];
    BaoAlbum *baoAlbum = [baoController.baoAlbums objectAtIndex:indexPath.section];
    BaoImage *baoImage = [baoAlbum.baoImages objectAtIndex:indexPath.row];
    NSLog(@"indexPath:%@", indexPath);
    
    cell.labelPrice.text = [NSString stringWithFormat:@"%f", baoImage.price];
    UIImage *image = [[BaoController sharedController] fetchImageFromAssetURL:baoImage.imageURL];
    
    
    if (image) {
        NSLog(@"have image url:%@", baoImage.imageURL);
        cell.imageView.image = image;
        
    }else {
        NSLog(@"no image");
        cell.backgroundColor = [UIColor grayColor];
    }
    
    
    
    
    return cell;
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

#pragma mark - calculation


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
