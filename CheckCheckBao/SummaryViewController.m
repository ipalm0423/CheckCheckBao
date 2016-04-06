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

-(NSMutableArray*)getUIImageByBaoImagesArray:(NSMutableArray*)baoImages{
    NSMutableArray *newImages = [NSMutableArray new];
    for (BaoImage *baoImage in baoImages) {
        UIImage *image = [baoController fetchImageFromAssetURL:baoImage.imageURL];
        if (image) {
            [newImages addObject:image];
        }else{
            UIImage *noImage = [[UIImage alloc]init];
            [newImages addObject:noImage];
        }
        
    }
    return newImages;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SummaryPictureTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SummaryPicture" forIndexPath:indexPath];
    NSMutableArray *baoImages = nil;
    
    //data
    if (indexPath.section == 0) {
        baoImages = unPriceBaoAlbum.baoImages;
    }else{//monthly images
        BaoAlbum *baoAlbum = [monthlyBaoAlbumArray objectAtIndex:(indexPath.section-1)];
        baoImages = baoAlbum.baoImages;
    }
    
    //collection view delegate
    cell.baoImages = baoImages;
    cell.uiImageArray = [self getUIImageByBaoImagesArray:baoImages];
    cell.isDeleteActive = isDeleteActive;
    cell.collectionView.delegate = cell;
    cell.collectionView.dataSource = cell;
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


#pragma mark - delete

- (void)activateDeletionMode:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        isDeleteActive = !isDeleteActive;
        [self.tableView reloadData];
        NSLog(@"is delete active: %@", isDeleteActive ? @"yes":@"no");
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
