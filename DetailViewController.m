//
//  DetailViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-4.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "DetailViewController.h"
#import "DishesCustomCell.h"
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize aTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"菜单";
    aTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, 320, [UIScreen mainScreen].bounds.size.height-44-20) style:UITableViewStylePlain];
    aTableView.delegate=self;
    aTableView.dataSource=self;
    //[aTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:aTableView];
    self.aTableView.backgroundColor=[UIColor clearColor];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    DishesCustomCell *cell = (DishesCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //记载xib相当于创建了xib当中的内容，返回的数组里面包含了xib当中的对象
        // NSLog(@"新创建的cell  %d",indexPath.row);
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DishesCustomCell" owner:nil options:nil];
		
        for (NSObject *object in array)
        {
            //判断数组中的对象是不是CustomCell 类型的
            if([object isKindOfClass:[DishesCustomCell class]])
            {
                //如果是，赋给cell指针
                cell = (DishesCustomCell *)object;
                //找到之后不再寻找
                break;
            }
        }
    }
    //右边小箭头
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // cell.textLabel.text=[ary objectAtIndex:indexPath.row];
    //    XmlStriing *xmlStr=[self.array objectAtIndex:indexPath.row];
    //    cell.lab.text=xmlStr.titleCnString;
    //    cell.lab2.text=xmlStr.authorString;
    //    cell.timeLab.text=xmlStr.publishTimeString;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110;//此处返回cell的高度
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [self detailClick:nil];
    //  [aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
