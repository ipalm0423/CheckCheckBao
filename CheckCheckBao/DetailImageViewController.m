//
//  DetailImageViewController.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/4/16.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "DetailImageViewController.h"

@interface DetailImageViewController ()

@end

@implementation DetailImageViewController{
    BaoController *baoController;
    BOOL isEditing;
    
    //temp price and note
    float newPrice;
    NSString *newNote;
    
    UITapGestureRecognizer *tapRecognizer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    baoController = [BaoController shareController];
    
    [self setupBaoImage];
    [self switchToEdit:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self registerForKeyboardNotifications];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self deregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
    
}

- (void)registerForKeyboardNotifications {
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

-(void) keyboardWillShow:(NSNotification *) note {
    //move constraint
    [self.view addGestureRecognizer:tapRecognizer];
    
    
    
    
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
    
    
    
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self.view endEditing:YES];
    
}

-(void)setupBaoImage{
    isEditing = NO;
    
    if (self.baoImage) {
        NSLog(@"have bao image");
        UIImage *newImage = [self.baoImage getFullSizeImage];
        if (newImage) {
            self.imageViewItem.image = newImage;
            self.labelNoImage.alpha = 0;
        }else{
            self.labelNoImage.alpha = 1;
        }
        self.textFieldPrice.text = [NSString stringWithFormat:@"%.1f", self.baoImage.price];
        self.textViewDescription.text = self.baoImage.note;
        self.textViewDescription.delegate = self;
        self.labelModifyCost.alpha = 0;
        self.labelModifyCost.text = @"";
        self.labelModifyDescription.text = @"";
        self.labelModifyDescription.alpha = 0;
        
    }else{
        NSLog(@"no bao image");
        self.labelNoImage.alpha = 1;
        self.buttonEdit.alpha = 0;
        self.textFieldPrice.alpha = 0;
        self.textViewDescription.alpha = 0;
        self.labelModifyCost.alpha = 0;
        self.labelModifyCost.text = @"";
        self.labelModifyDescription.text = @"";
        self.labelModifyDescription.alpha = 0;
    }
}



-(void)switchToEdit:(BOOL)isEdit{
    isEditing = isEdit;
    if (isEdit) {
        //text view
        self.textViewDescription.editable = YES;
        self.textViewDescription.textColor = [UIColor blueColor];
        self.textViewDescription.layer.borderColor = [UIColor grayColor].CGColor;
        self.textViewDescription.layer.borderWidth = 1;
        self.textViewDescription.layer.cornerRadius = 10;
        self.textViewDescription.clipsToBounds = YES;
        self.textViewDescription.backgroundColor = [UIColor clearColor];
        [self.textViewDescription setContentOffset:CGPointZero animated:YES];

        
        newNote = self.baoImage.note;
        
        
        //text field
        self.textFieldPrice.borderStyle = UITextBorderStyleRoundedRect;
        self.textFieldPrice.enabled = YES;
        newPrice = self.baoImage.price;
        
        //label
        self.labelModifyCost.alpha = 1;
        self.labelModifyCost.text = @"Modify Your Price";
        self.labelModifyDescription.text = @"Modify Your Notes";
        self.labelModifyDescription.alpha = 1;
        
        //button
        [self.buttonEdit setTitle:@"Done" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contraintTextViewToSuperViewBottom.constant = 350;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        
        //text field
        self.textFieldPrice.borderStyle = UITextBorderStyleNone;
        self.textFieldPrice.enabled = NO;
        self.textFieldPrice.text = [NSString stringWithFormat:@"%.1f", self.baoImage.price];
        
        //text view
        self.textViewDescription.editable = NO;
        self.textViewDescription.textColor = [UIColor blueColor];
        self.textViewDescription.layer.borderColor = [UIColor clearColor].CGColor;
        self.textViewDescription.layer.borderWidth = 1;
        self.textViewDescription.clipsToBounds = YES;
        self.textViewDescription.text = self.baoImage.note;
        [self.textViewDescription setContentOffset:CGPointZero animated:YES];
        
        
        //label
        self.labelModifyCost.alpha = 0;
        self.labelModifyCost.text = @"";
        self.labelModifyDescription.text = @"";
        self.labelModifyDescription.alpha = 0;
        
        //button
        [self.buttonEdit setTitle:@"Edit" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contraintTextViewToSuperViewBottom.constant = 40;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}



#pragma mark - text field
- (IBAction)TextFieldPriceValueChanged:(UITextField *)sender {
    newPrice = [sender.text floatValue];
    
    
}

- (IBAction)textFieldPriceInputDidEndOnExit:(UITextField *)sender {
    [self.view endEditing:YES];
    NSLog(@"did end on exit");

    
}

#pragma mark - text view
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"did end editing");
}

-(void)textViewDidChange:(UITextView *)textView{
    newNote = textView.text;
}






#pragma mark - button

- (IBAction)buttonEditTouch:(UIButton *)sender {
    
    if (isEditing) {//save and leave editing
        //save
        self.baoImage.price = newPrice;
        self.baoImage.note = newNote;
        [baoController saveAllChange];
    }
    
    //view
    [self switchToEdit:!isEditing];
    
    
    
    
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
