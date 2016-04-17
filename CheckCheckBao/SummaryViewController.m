//
//  SummaryViewController.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "SummaryViewController.h"
#import "SummarySectionMonthlyTableViewCell.h"
#import "SummaryPictureTableViewCell.h"
#import "DetailImageViewController.h"


@interface SummaryViewController ()

@end

@implementation SummaryViewController{
    
    __block BaoController *baoController;
    NSMutableArray *monthlyBaoAlbumArray;
    BaoAlbum *unPriceBaoAlbum;
    
    BOOL isDeleteActive;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //baoController
    baoController = [BaoController shareController];
    baoController.delegateBaoController = self;
    
    //table view
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    
    //long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(activateDeletionMode:)];
    //longPress.delegate = self;
    [self.tableView addGestureRecognizer:longPress];
    isDeleteActive = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    [self setupAllSummaryArray];
    [self.tableView reloadData];
    NSLog(@"view will appear");
    
    [super viewWillAppear:animated];
}


#pragma mark - data separate
-(void)setupAllSummaryArray{
    [self setupMonthlyArray];
    [self setupUnPriceArray];
}

-(void)setupMonthlyArray{
    monthlyBaoAlbumArray = [NSMutableArray new];
    
    [baoController sortBaoAlbumsByDate];//from old to new
    
    monthlyBaoAlbumArray = baoController.baoAlbums;
    NSLog(@"monthly count: %li", monthlyBaoAlbumArray.count);
}

-(void)setupUnPriceArray{
    [baoController updateUnPriceBaoImageArray];//baoController
    if (baoController.unPriceBaoAlbum) {
        NSLog(@"have album");
        NSLog(@"un price array:%li", baoController.unPriceBaoAlbum.baoImages.count);
        unPriceBaoAlbum = baoController.unPriceBaoAlbum;
    }else {
        NSLog(@"dont have album");
    }
    
    
    
    NSLog(@"un Price image count: %li", unPriceBaoAlbum.baoImages.count);
}



//deprecate
/*
-(void)setupWeeklyData{
    
    for (int i = 0; i < baoController.baoAlbums.count; i++) {
        BaoAlbum *baoAlbum = [baoController.baoAlbums objectAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"%@-%@", baoAlbum.year, baoAlbum.month];
        
        
    }
    
    
}

-(void)dateComponent{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    NSDate *thisWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - 7)];
    NSDate *lastWeek  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - ([components day] -1))];
    NSDate *thisMonth = [cal dateFromComponents:components];
    
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    NSLog(@"today=%@",today);
    NSLog(@"yesterday=%@",yesterday);
    NSLog(@"thisWeek=%@",thisWeek);
    NSLog(@"lastWeek=%@",lastWeek);
    NSLog(@"thisMonth=%@",thisMonth);
    NSLog(@"lastMonth=%@",lastMonth);
}
*/

#pragma mark - table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return monthlyBaoAlbumArray.count + 1;// section.0 is 沒有標價的照片
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 && unPriceBaoAlbum.baoImages.count > 0) {
        return 1;
    }else if (section > 0){//monthly array count
        
        return 1;
    }
    
    return 0;
}

-(UITableViewCell *)tableView2delete:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SummaryPictureTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SummaryPicture" forIndexPath:indexPath];
    
    
    //collection view delegate
    cell.collectionView.tag = indexPath.section;
    cell.collectionView.delegate = self;
    cell.collectionView.dataSource = self;
    [cell.collectionView reloadData];
    
    return cell;
}

-(UITableViewCell *)tableView2delete22:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SummaryPictureTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SummaryPicture" forIndexPath:indexPath];
    
    
    //collection view delegate
    cell.collectionView.tag = indexPath.section;
    cell.collectionView.delegate = self;
    cell.collectionView.dataSource = self;
    [cell.collectionView reloadData];
    
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SummaryPictureTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SummaryPicture" forIndexPath:indexPath];
    
    
    //collection view delegate
    cell.collectionView.tag = indexPath.section;
    cell.collectionView.delegate = self;
    cell.collectionView.dataSource = self;
    [cell.collectionView reloadData];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && unPriceBaoAlbum.baoImages.count > 0) {
        return 40;
    }else if (section > 0 && monthlyBaoAlbumArray.count > 0) {
        return 40;
    }
    
    
   
    
    return 0;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //monthly summary
    SummarySectionMonthlyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SummarySectionMonthly"];
    BaoAlbum *baoAlbum = nil;
    
    if (section == 0) {
        baoAlbum = unPriceBaoAlbum;
        cell.labelTime.text = @"These checks don't have price";
        cell.labelSum.text = [NSString stringWithFormat:@"%li", unPriceBaoAlbum.baoImages.count];
    }else{//monthly array count
        baoAlbum = [monthlyBaoAlbumArray objectAtIndex:(section-1)];
        cell.labelSum.text = [baoAlbum getStringSumPrice];
        cell.labelTime.text = [baoAlbum getStringTime];
    }
    
    
    return cell.contentView;
}




#pragma mark - collection view delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger index = collectionView.tag;
    if (index == 0) {//section 0 = unPrice
        return unPriceBaoAlbum.baoImages.count;
    }else{
        BaoAlbum *baoAlbum = [monthlyBaoAlbumArray objectAtIndex:index - 1];
        return baoAlbum.baoImages.count;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BaoImage *baoImage = nil;
    NSInteger albumIndex = collectionView.tag;
    
    if (albumIndex == 0) {
        baoImage = [unPriceBaoAlbum.baoImages objectAtIndex:indexPath.row];
    }else{
        BaoAlbum *baoAlbum = [monthlyBaoAlbumArray objectAtIndex:albumIndex - 1];
        baoImage = [baoAlbum.baoImages objectAtIndex:indexPath.row];
    }
    
    
    ImagePriceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"priceCollectionCell" forIndexPath:indexPath];
    if (baoImage) {
        
        //label
        cell.labelPrice.text = [baoImage getStringPrice];
        cell.labelTime.text = [baoImage getStringTime];
        
        
        //image
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.layer.masksToBounds = YES;
        
        UIImage *image = [baoImage getSmallSizeUIImage];
        if (image) {
            
            cell.imageView.image = image;
            cell.imageView.alpha = 1;
            NSLog(@"have image url:%@", baoImage.imageURL);
            
        }else {
            NSLog(@"no image");
            cell.imageView.image = nil;
            [cell.imageView setBackgroundColor:[UIColor grayColor]];
            cell.imageView.alpha = 0.5;
            
        }
        
        cell.buttonDelete.tag = indexPath.row;
        cell.buttonDelete.layer.cornerRadius = cell.buttonDelete.frame.size.height / 2;
        cell.buttonDelete.layer.masksToBounds = YES;
        
        if (isDeleteActive) {
            cell.buttonDelete.alpha = 1;
            
        }else{
            cell.buttonDelete.alpha = 0;
        }
    }
    
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"image touch at row:%li", indexPath.row);
    BaoImage *selectImage = nil;
    NSInteger albumIndex = collectionView.tag;
    
    if (albumIndex == 0) {
        selectImage = [unPriceBaoAlbum.baoImages objectAtIndex:indexPath.row];
    }else{
        BaoAlbum *baoAlbum = [monthlyBaoAlbumArray objectAtIndex:albumIndex - 1];
        selectImage = [baoAlbum.baoImages objectAtIndex:indexPath.row];
    }
    
    
    if (selectImage) {
        DetailImageViewController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailImageView"];
        
        VC.baoImage = selectImage;
        
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}


#pragma mark - delete

- (void)activateDeletionMode:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        isDeleteActive = !isDeleteActive;
        [self.tableView reloadData];
        NSLog(@"is delete active: %@", isDeleteActive ? @"yes":@"no");
    }
    
    
}

- (IBAction)buttonDeleteTouch:(UIButton *)sender {
    if (isDeleteActive) {
        //table row
        CGPoint buttonTablePosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *tableIndexPath = [self.tableView indexPathForRowAtPoint:buttonTablePosition];
        
        NSInteger imageIndex = sender.tag;
        
        //delete
        if (tableIndexPath.section == 0) {
            BaoImage *deleteImage = [unPriceBaoAlbum.baoImages objectAtIndex:imageIndex];
            
            [unPriceBaoAlbum.baoImages removeObjectAtIndex:imageIndex];
            [baoController deleteBaoImage:deleteImage];
        }else{
            BaoAlbum *baoAlbum = [monthlyBaoAlbumArray objectAtIndex:tableIndexPath.section - 1];
            BaoImage *deleteImage = [baoAlbum.baoImages objectAtIndex:imageIndex];
            
            [baoController deleteBaoImage:deleteImage];
            [baoAlbum.baoImages removeObjectAtIndex:imageIndex];
        }
        
        [baoController saveAllChange];
        
        //reload view
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tableIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        
        
    }
}

- (IBAction)buttonBackToCameraTouch:(UIBarButtonItem *)sender {
    
    self.tabBarController.selectedIndex = 0;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation



@end
