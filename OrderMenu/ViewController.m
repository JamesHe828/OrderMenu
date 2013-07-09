//
//  ViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-3.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "DetailViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize pageC;
@synthesize aTableView;
@synthesize numberStr;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
	ascrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 146)];
    [self.view addSubview:ascrollview];
    ascrollview.pagingEnabled=YES;
    ascrollview.showsHorizontalScrollIndicator=NO;
    ascrollview.delegate=self;
    ascrollview.contentSize=CGSizeMake(320*5, 146);
    for (int i = 0 ; i<5; i++) {
        UIImageView *aImage = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 146)];
        aImage.userInteractionEnabled = YES;
//         aImage.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:212.0/255.0 blue:217.0/255.0 alpha:1];
        aImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        [ascrollview addSubview:aImage];
        
    }
    for (int j=0; j<5; j++)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(320*j, 0, 320, 146);
        [btn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
        [ascrollview addSubview:btn];
    }
    pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(120,126, 100, 10)];
    pageC.numberOfPages = 5;
    pageC.currentPage=0;
    [self.view addSubview:pageC];
    
    self.navigationItem.title=@"美食推荐";
    self.navigationController.navigationBar.tintColor=[UIColor orangeColor];
    
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,146, 320, [UIScreen mainScreen].bounds.size.height - 146-44-20) style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
    //[aTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:aTableView];
    self.aTableView.backgroundColor=[UIColor clearColor];
    ary=[[NSArray alloc] initWithObjects:@"a.jpg",@"b.jpg",@"c.jpg",@"d.jpg",@"e.jpg",@"f.jpg", nil];
    nameAry=[[NSArray alloc] initWithObjects:@"汉丽轩",@"金汉斯",@"徐同泰",@"阳光小餐厅",@"卷凉皮",@"河南天空", nil];
    addressAry=[[NSArray alloc] initWithObjects:@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西",@"花园路国基路向北100米路西", nil];
}
-(void)detailClick:(id)sender
{
    DetailViewController *detailVC=[[DetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_NO" object:nil];
   
}
-(void)viewWillAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"pan_YES" object:nil];
    [super viewWillAppear:animated];
}
#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [ary count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //记载xib相当于创建了xib当中的内容，返回的数组里面包含了xib当中的对象
        // NSLog(@"新创建的cell  %d",indexPath.row);
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
		
        for (NSObject *object in array)
        {
            //判断数组中的对象是不是CustomCell 类型的
            if([object isKindOfClass:[CustomCell class]])
            {
                //如果是，赋给cell指针
                cell = (CustomCell *)object;
                //找到之后不再寻找
                break;
            }
        }
    }
    //右边小箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imag.image=[UIImage imageNamed:[ary objectAtIndex:indexPath.row]];
    cell.lab.text=[nameAry objectAtIndex:indexPath.row];
    cell.lab2.textColor=[UIColor grayColor];
    cell.lab2.text=[addressAry objectAtIndex:indexPath.row];
    cell.timeLab.textColor=[UIColor grayColor];
    cell.timeLab.text=@"0371-88888815";
    numberStr=cell.timeLab.text;
    [cell.abtn addTarget:self action:@selector(detailClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bbtn addTarget:self action:@selector(callNum:) forControlEvents:UIControlEventTouchUpInside];
   // cell.textLabel.text=[ary objectAtIndex:indexPath.row];
    //    XmlStriing *xmlStr=[self.array objectAtIndex:indexPath.row];
    //    cell.lab.text=xmlStr.titleCnString;
    //    cell.lab2.text=xmlStr.authorString;
    //    cell.timeLab.text=xmlStr.publishTimeString;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [self detailClick:nil];
  //  [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
}
//打电话
-(void)callNum:(id)sender
{
    UIWebView *callPhoneWebVw = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",numberStr]]];
    NSLog(@"%@",numberStr);
    [callPhoneWebVw loadRequest:request];
    [self.view addSubview:callPhoneWebVw];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",numberStr]]];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView==ascrollview)
    {
        int page2=ascrollview.contentOffset.x/320;
        self.pageC.currentPage=page2;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
