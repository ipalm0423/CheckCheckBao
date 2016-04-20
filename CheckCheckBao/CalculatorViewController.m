//
//  CalculatorViewController.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/5.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()




@property (strong, nonatomic) IBOutlet UILabel *calculateNumberLabel;



@end

@implementation CalculatorViewController


@synthesize delegateCalculator;
@synthesize totalNumber;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.totalNumber = 0;
    self.calculateNumberLabel.text = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view 
-(void)addSubviewOnBottom:(UIView*)hostView{
    NSLog(@"add calculator");
    
    self.view.frame = CGRectMake(0, hostView.frame.size.height - 400, hostView.frame.size.width, 400);
    [hostView addSubview:self.view];
    
    
    
}

-(void)returnNumberToZero{
    self.totalNumber = 0;
    self.calculateNumberLabel.text = @"0";
    [self sendValueToDelegate];
}



#pragma mark - delegate





#pragma mark - calculator button

- (IBAction)zeroButtonTouch:(id)sender {
    if (![self.calculateNumberLabel.text  isEqual: @"0"]) {
        self.calculateNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.calculateNumberLabel.text, @"0"];
        
    }
    
    [self sendValueToDelegate];
    
}

- (IBAction)pointButtonTouch:(id)sender {
    if ([self.calculateNumberLabel.text rangeOfString:@"."].location == NSNotFound) {
        self.calculateNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.calculateNumberLabel.text, @"."];
        
    }
    
    [self sendValueToDelegate];
    
}

- (IBAction)oneButtonTouch:(id)sender {
    if (![self.calculateNumberLabel.text  isEqual: @"0"]) {
        self.calculateNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.calculateNumberLabel.text, @"1"];
        
    }else {
        self.calculateNumberLabel.text = @"1";
    }
    
    [self sendValueToDelegate];
    
}

- (IBAction)twoButtonTouch:(id)sender {
    if (![self.calculateNumberLabel.text  isEqual: @"0"]) {
        self.calculateNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.calculateNumberLabel.text, @"2"];
        
    }else {
        self.calculateNumberLabel.text = @"2";
    }
    
    [self sendValueToDelegate];
}

- (IBAction)threeButtonTouch:(id)sender {
    if (![self.calculateNumberLabel.text  isEqual: @"0"]) {
        self.calculateNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.calculateNumberLabel.text, @"3"];
        
    }else {
        self.calculateNumberLabel.text = @"3";
    }
    
    [self sendValueToDelegate];
}

- (IBAction)fourButtonTouch:(id)sender {
    if (![self.calculateNumberLabel.text  isEqual: @"0"]) {
        self.calculateNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.calculateNumberLabel.text, @"4"];
        
    }else {
        self.calculateNumberLabel.text = @"4";
    }
    
    [self sendValueToDelegate];
}

- (IBAction)fiveButtonTouch:(id)sender {
    if (![self.calculateNumberLabel.text  isEqual: @"0"]) {
        self.calculateNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.calculateNumberLabel.text, @"5"];
        
    }else {
        self.calculateNumberLabel.text = @"5";
    }
    
    [self sendValueToDelegate];
}

- (IBAction)sixButtonTouch:(id)sender {
    if (![self.calculateNumberLabel.text  isEqual: @"0"]) {
        self.calculateNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.calculateNumberLabel.text, @"6"];
        
    }else {
        self.calculateNumberLabel.text = @"6";
    }
    
    [self sendValueToDelegate];
}

- (IBAction)sevenButtonTouch:(id)sender {
    if (![self.calculateNumberLabel.text  isEqual: @"0"]) {
        self.calculateNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.calculateNumberLabel.text, @"7"];
        
    }else {
        self.calculateNumberLabel.text = @"7";
    }
    
    [self sendValueToDelegate];
}

- (IBAction)eightButtonTouch:(id)sender {
    if (![self.calculateNumberLabel.text  isEqual: @"0"]) {
        self.calculateNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.calculateNumberLabel.text, @"8"];
        
    }else {
        self.calculateNumberLabel.text = @"8";
    }
    
    [self sendValueToDelegate];
}

- (IBAction)nineButtonTouch:(id)sender {
    if (![self.calculateNumberLabel.text  isEqual: @"0"]) {
        self.calculateNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.calculateNumberLabel.text, @"9"];
        
    }else {
        self.calculateNumberLabel.text = @"9";
    }
    
    [self sendValueToDelegate];
}

- (IBAction)acButtonTouch:(id)sender {
    self.calculateNumberLabel.text = @"0";
    [self sendValueToDelegate];
}


#pragma mark - calculate
- (void)sendValueToDelegate {
    
    self.totalNumber = [self.calculateNumberLabel.text floatValue];
    NSLog(@"done button touch %f", self.totalNumber);
    
    if (self.delegateCalculator && [self.delegateCalculator respondsToSelector:@selector(didChangeCalculatorValue:)]) {
        [self.delegateCalculator didChangeCalculatorValue:self.totalNumber];
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
