//
//  ViewController.m
//  DisplaysCollectionView
//
//  Created by 李正兵 on 16/4/18.
//  Copyright © 2016年 李正兵. All rights reserved.
//

#import "ViewController.h"
#import "DisplayCollectionViewCell.h"
#import "DisplayCollectionViewLayout.h"

static const float kCollectionItemWidth = 160;

#define SCR_WIDTH [UIScreen mainScreen].bounds.size.width


@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CGFloat f_origin_x;
}
@property (weak, nonatomic) IBOutlet UICollectionView *cvDisplay;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    f_origin_x =  - (SCR_WIDTH- kCollectionItemWidth)/2.0;

    
    [self.cvDisplay registerNib:[UINib nibWithNibName:@"DisplayCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DisplayCollectionViewCell"];
    self.cvDisplay.dataSource = self;
    self.cvDisplay.delegate = self;
    self.cvDisplay.showsHorizontalScrollIndicator = NO;
    DisplayCollectionViewLayout *layout = [DisplayCollectionViewLayout new];
    layout.itemSize = CGSizeMake(160, 185);
    self.cvDisplay.collectionViewLayout = layout;
    self.cvDisplay.contentOffset = CGPointMake(kCollectionItemWidth*1.5 - SCR_WIDTH*0.5 , 0);
    
//    [self magicBlock];
}

- (void)magicBlock {
    
    id (^testBlock)(NSString *string,NSArray *array) = ^id(NSString *string,NSArray *array) {
        NSLog(@"param:%@--%@",string,array);
        return string;
    };
    
    const char * _Block_signature(void *);
    const char * signature = _Block_signature((__bridge void *)(testBlock));
    
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:signature];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    NSString *string = @"string";
    [invocation setArgument:&string atIndex:1];
    
    
    NSArray *array = @[@"xx",@"oo"];
    [invocation setArgument:&array atIndex:2];
    
    [invocation invoke];
    
    id returnValue;
    [invocation getReturnValue:&returnValue];
    NSLog(@"returnValue:%@",returnValue);
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DisplayCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    float x = scrollView.contentOffset.x;
    
    float origin = f_origin_x;
    float index_float = (x - origin)/kCollectionItemWidth;
    NSUInteger index_uInteger = 0;
    if (index_float > 0) {
        index_uInteger = (int)(index_float + 0.5);
    }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
