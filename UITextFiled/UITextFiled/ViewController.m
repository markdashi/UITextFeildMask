//
//  ViewController.m
//  UITextFiled
//
//  Created by mark on 2018/7/10.
//  Copyright © 2018年 mark. All rights reserved.
//

#import "ViewController.h"

//MARK:输入框和键盘之间的间距
static CGFloat INTERVAL_KEYBOARD = 30;

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@end

@implementation ViewController
{
  NSDictionary *keyboardInfo;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField1.delegate = self.textField2.delegate = self.textField3.delegate = self;
}

# pragma mark - UIKeyboardWillShowNotification UIKeyboardWillHideNotification
- (void)keyboardWillShow:(NSNotification *)noti{
    keyboardInfo = noti.userInfo;
    NSLog(@"keyboardWillShow : %@",keyboardInfo);
    [self textFieldShouldBeginEditing:[self isFirstTextFieldResponder]];
}
- (void)keyboardWillHide:(NSNotification *)noti{
    NSLog(@"keyboardWillHide : %@",noti.userInfo);
    keyboardInfo = noti.userInfo;
    [self animationWithkeybooard:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

# pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.textField1) {
        [self.textField2 becomeFirstResponder];
    }else if (textField == self.textField2){
        [self.textField3 becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    NSString *trimText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimText length] > 5) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (!keyboardInfo) {
        return YES;
    }
    CGFloat kbHeight = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat offset = (textField.frame.origin.y + textField.frame.size.height + INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    if (offset > 0) {
        if (offset > kbHeight) {
            offset = kbHeight-50;
        }
        [self animationWithkeybooard:^{
            self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }else{
        [self animationWithkeybooard:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

# pragma mark - animation
- (void)animationWithkeybooard:(void (^)(void))animations{
    NSTimeInterval duration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [[keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    animations();
    [UIView commitAnimations];
}
- (UITextField *)isFirstTextFieldResponder{
    if ([self.textField1 isFirstResponder]) {
        return _textField1;
    }else if ([self.textField2 isFirstResponder]) {
        return _textField2;
    }else{
        return _textField3;
    }
}



@end
