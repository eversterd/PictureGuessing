//
//  ViewController.m
//  PictureGuessing
//
//  Created by shiyc on 15/12/17.
//  Copyright © 2015年 shiyc. All rights reserved.
//

#import "ViewController.h"
#import "CZQuestion.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countVIew;
@property (weak, nonatomic) IBOutlet UIButton *coinView;
@property (weak, nonatomic) IBOutlet UILabel *titleVIew;
@property (weak, nonatomic) IBOutlet UIButton *iconView;
@property (weak, nonatomic) IBOutlet UIButton *nextView;
@property (weak, nonatomic) IBOutlet UIView *answersView;
@property (weak, nonatomic) IBOutlet UIView *optionsVIew;

//frame of original iconView
@property(nonatomic,assign) CGRect oldFrame;
//Button to hide background
@property (nonatomic,weak) UIButton *coverView;
@property (nonatomic,strong)NSArray *questions;
@property (nonatomic,assign)int    index;
@property (nonatomic,assign)int    correctCount;
- (IBAction)tipCLick;
- (IBAction)helpCLick;
- (IBAction)bigImageClick;
- (IBAction)nextClick;
- (IBAction)iconClick;

@end

@implementation ViewController
-(NSArray *)questions
{
    if (_questions==nil)
    {
       
        _questions=[CZQuestion questionList];
    }
    
        return _questions;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     self.index--;
    [self nextClick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tipCLick {
    self.index--;
    [self nextClick];
    CZQuestion *question=self.questions[self.index];
    NSString *first=[NSString stringWithFormat:@"%C",[question.answer characterAtIndex:0]];
    for (UIButton *btn in self.optionsVIew.subviews){
        NSString *option=btn.currentTitle;
        if ([first isEqualToString:option]) {
            [self optionClick:btn];
        }
    }
    int coin=[self.coinView.currentTitle intValue];
    coin-=1000;
    [self.coinView setTitle:[NSString stringWithFormat:@"%d",coin] forState:UIWindowLevelNormal];
}

- (IBAction)helpCLick {
    self.index--;
    [self nextClick];
    CZQuestion *question=self.questions[self.index];
    NSString *first=[NSString stringWithFormat:@"%C",[question.answer characterAtIndex:0]];
    for (UIButton *btn in self.optionsVIew.subviews){
        NSString *option=btn.currentTitle;
        if ([first isEqualToString:option]) {
            [self optionClick:btn];
        }
    }
    int coin=[self.coinView.currentTitle intValue];
    coin-=1000;
    [self.coinView setTitle:[NSString stringWithFormat:@"%d",coin] forState:UIWindowLevelNormal];
}
///click to enlarge the picture
- (IBAction)bigImageClick {
    self.oldFrame=self.iconView.frame;
    
    CGFloat iconW=self.view.frame.size.width;
    CGFloat iconH=iconW;
    CGFloat iconX=0;
    CGFloat iconY=(self.view.frame.size.height-iconH)/2;
     /// add a view to hide the background
    UIButton *coverView=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:coverView];
    self.coverView=coverView;
    coverView.frame=self.view.frame;
    coverView.backgroundColor=[UIColor blackColor];
    [UIView animateWithDuration:1.0 animations:^{
        self.iconView.frame=CGRectMake(iconX, iconY, iconW, iconH);
        coverView.alpha=0.5;}];
    [self.view bringSubviewToFront:self.iconView];
    
    [coverView addTarget:self action:@selector(smallImageClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)smallImageClick
{
    [UIView animateWithDuration:1.0 animations:^{
        self.iconView.frame=self.oldFrame;
        self.coverView.alpha=0;}
                     completion:^(BOOL finished){
                         [self.coverView removeFromSuperview];
                     }];
    
}
//click iconView to resize the icon

- (IBAction)nextClick
{
    self.optionsVIew.userInteractionEnabled=YES;
    self.index++;
    
    if(self.index==self.questions.count){
        UIAlertController * alert=[UIAlertController  alertControllerWithTitle:@"Congratulations!"
                                message:[NSString stringWithFormat:@"Correct Answer:%d",self.correctCount]
                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* reset = [UIAlertAction
                             actionWithTitle:@"Reset"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 self.index=0;
                                 int coin=[self.coinView.currentTitle intValue];
                                 coin=10000;
                                 [self.coinView setTitle:[NSString stringWithFormat:@"%d",coin] forState:UIWindowLevelNormal];
                                 [self viewDidLoad];
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                  self.index--;
                                 [self nextClick];
                                     
                                 }];
        
        
        [alert addAction:reset];
        [alert addAction:cancel];
      [self presentViewController:alert animated:YES completion:nil];

        return;
    }
    CZQuestion *question=self.questions[self.index];
    self.countVIew.text=[NSString stringWithFormat:@"%d/%lu",self.index+1,self.questions.count];
    self.titleVIew.text=question.title;
    self.iconView.imageView.image=[UIImage imageNamed:question.icon];
    [self.iconView setImage:[UIImage imageNamed:question.icon] forState:UIControlStateNormal];
    self.nextView.enabled=self.index !=self.questions.count-1;
    [self addAnswerBtns:question];
    [self addOptionBtns:question];
}

- (IBAction)iconClick {
    if(self.coverView==nil){
        [self bigImageClick];
    }else{
        [self smallImageClick];
    }
}
-(void)addAnswerBtns:(CZQuestion *)question
{
    ///delete button set by the last question
    [self.answersView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    NSUInteger count=question.answer.length;
    for (int i=0; i<question.answer.length; i++) {
        UIButton *answerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.answersView addSubview:answerBtn];
        
        ///set frame
        CGFloat margin=10;
        CGFloat answerW=35;
        CGFloat answerH=35;
        CGFloat marginLeft=(self.answersView.frame.size.width-count*answerW-(count-1)*margin)/2;
        
        CGFloat answerY=0;
        CGFloat answerX=marginLeft+i*(answerW+margin);
        answerBtn.frame=CGRectMake(answerX, answerY, answerW, answerH);
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answerBtn addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
    }

}
- (void)answerClick:(UIButton *)sender
{
    if (sender.currentTitle ==nil) {
        return;
    }
    [self setAnswerButtonColor:[UIColor blackColor]];
    for (UIButton *optionBtn in self.optionsVIew.subviews){
        if (sender.tag==optionBtn.tag) {
            optionBtn.hidden=NO;
            break;
        }
    }
    [sender setTitle:nil forState:UIControlStateNormal];
    self.optionsVIew.userInteractionEnabled=YES;
}
- (void)addOptionBtns:(CZQuestion *)question
{
    [self.optionsVIew.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
   
    for (int i=0; i<question.options.count; i++) {
        UIButton *optionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.optionsVIew addSubview:optionBtn];
        
        ///set frame
        int totalColumn=7;
        CGFloat optionW=35;
        CGFloat optionH=35;
        
        int row=i/totalColumn;
        int column=i%totalColumn;
        CGFloat marginX=(self.optionsVIew.frame.size.width-totalColumn*optionW)/(totalColumn+1);
        CGFloat marginY=15;
        CGFloat optionX=marginX+column*(optionW+marginX);
        CGFloat optionY=row*(optionH+marginY);
        
        optionBtn.tag=i;
        optionBtn.frame=CGRectMake(optionX, optionY, optionW, optionH);
        [optionBtn setTitle:question.options[i] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [optionBtn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [optionBtn addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];

    }
 
}
- (void)optionClick:(UIButton *)sender
{
    sender.hidden=YES;
    for (UIButton *answerBtn in self.answersView.subviews)
    {
        if( answerBtn.currentTitle==nil){
            [answerBtn setTitle:sender.currentTitle  forState:UIControlStateNormal];
            answerBtn.tag=sender.tag;
            break;
        }
        
    }
    ///check answer
    BOOL isFull=YES;
    NSMutableString *inputAnswer=[NSMutableString string];
    for (UIButton *answerBtn in self.answersView.subviews)
    {
        if (answerBtn.currentTitle==nil){
            isFull=NO;
            break;
        }
        [inputAnswer appendString:answerBtn.currentTitle];
    }
    CZQuestion *question =self.questions[self.index];
    if(isFull)
    {
        self.optionsVIew.userInteractionEnabled=NO;
        if ([inputAnswer isEqualToString:question.answer])
        {
            [self setAnswerButtonColor:[UIColor blueColor]];
            
            self.correctCount++;
            int coin=[self.coinView.currentTitle integerValue];
            coin+=500;
            [self.coinView setTitle:[NSString stringWithFormat:@"%d",coin] forState:UIControlStateNormal];
            [self performSelector:@selector(nextClick) withObject:self afterDelay:1.0];
            
        }   else
            {
                [self setAnswerButtonColor:[UIColor redColor]];
            }
        
    }
    
}
- (void)setAnswerButtonColor:(UIColor *)color
{
    
    for (UIButton *btn in self.answersView.subviews)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    
}
@end
