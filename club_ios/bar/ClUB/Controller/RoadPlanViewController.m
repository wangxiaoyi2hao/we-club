//
//  RoadPlanViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/3.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "RoadPlanViewController.h"
#import "AppDelegate.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "RoadPlanvTableViewCell.h"

@interface RoadPlanViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{


    AMapSearchAPI *_search;
    AMapDrivingRouteSearchRequest *requestCar;
    AMapTransitRouteSearchRequest*requestBus;
    NSMutableArray*_busArray;
    NSMutableArray*_carArray;
    NSMutableArray*_walkArray;
    NSMutableArray*_exitNameArray;
   
}

@end

@implementation RoadPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认让tableview的tag值等于0
    _tableView.tag=1;
    [self busPlan];
    [AppDelegate matchAllScreenWithView:self.view];
    [self loadNav];
   
     _busArray=[NSMutableArray array];
     _carArray=[NSMutableArray array];
    _exitNameArray=[NSMutableArray array];
    

   
}
-(void)loadNav{
    
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(popView1) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    //    [leftButton setTitle:@"<" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
    
}
-(void)popView1{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)carpanClick:(id)sender{

  
    _tableView.tag=0;
    [self carPlan];

   
}
-(IBAction)BusplanClick:(id)sender{
    
  
    _tableView.tag=1;
    [self busPlan];
    
    
}
-(IBAction)manplanClick:(id)sender{
    
    
    _tableView.tag=2;
    
    
}

//驾车
-(void)carPlan{

    
    [AMapSearchServices sharedServices].apiKey = @"91c9bb4d5527e9d1832545c8da02a0f2";
    //关键字搜索
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
  requestCar = [[AMapDrivingRouteSearchRequest alloc] init];
    requestCar.origin = [AMapGeoPoint locationWithLatitude:39.994949 longitude:116.447265];
    requestCar.destination = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    requestCar.strategy = 2;//距离优先
    requestCar.requireExtension = YES;
    
    //发起路径搜索
    [_search AMapDrivingRouteSearch: requestCar];
}
//公交
-(void)busPlan{

   
    [AMapSearchServices sharedServices].apiKey = @"91c9bb4d5527e9d1832545c8da02a0f2";
    //关键字搜索
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    requestBus = [[AMapTransitRouteSearchRequest alloc] init];
    requestBus.origin = [AMapGeoPoint locationWithLatitude:39.994949 longitude:116.447265];
    requestBus.destination = [AMapGeoPoint locationWithLatitude:_barXiao longitude:_barDa];
    requestBus.strategy = 0;//最快捷模式
    requestBus.city = @"北京";
    requestBus.requireExtension=YES;
    
    //发起路径搜索
    [_search AMapTransitRouteSearch:requestBus];

}
//规划路线的回调方法
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if ([request isEqual:requestCar]) {
        if(response.route ==nil)
        {
            return;
        }
        
        //通过AMapNavigationSearchResponse对象处理搜索结果
        AMapRoute *route = response.route;
        for (int i=0; i<route.paths.count; i++) {
            AMapPath*aaa=[route.paths objectAtIndex:i];
          _carArray=(NSMutableArray*)aaa.steps;
          
        }

    }
    if ([request isEqual:requestBus]) {
        if(response.route ==nil)
        {
            return;
        }
      
        AMapRoute *route = response.route;
        NSLog(@"解析数据:%@",route);
        for (int i=0; i<route.transits.count; i++) {
            AMapTransit*bus=[route.transits objectAtIndex:i];
            NSArray*arrayBusSegements=bus.segments;
            for (int j=0; j<arrayBusSegements.count; j++) {
                AMapSegment*abc=[arrayBusSegements objectAtIndex:j];
                NSString*exitentterName=[NSString stringWithFormat:@"%@%@",abc.enterName,abc.exitName];
                [_exitNameArray addObject:exitentterName];
                _busArray=(NSMutableArray*)abc.walking.steps;
//                for (int k=0; k<abc.walking.steps.count; k++) {
//                    <#statements#>
//                }
//                @property (nonatomic, strong) AMapBusStop *departureStop; //!< 起程站
//                @property (nonatomic, strong) AMapBusStop *arrivalStop; //!< 下车站
//                AMapWalking*ads=[arrayBusSegements objectAtIndex:j];
//                _busArray=(NSMutableArray*)ads.steps;
                //                for (int k=0; k<abc.buslines.count; k++) {
//                    amaps*bbc=[abc.buslines objectAtIndex:k];
//                    
//                    [_busArray addObject:bbc.];
//                }

            }
            
        }

    }
    
 [_tableView reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_tableView.tag==0) {
            return _carArray.count;
    }else if (_tableView.tag==1){
    
    
        return _busArray.count;
    }else{
    
        return _walkArray.count;
    }



}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static   NSString *str=@"cell";
    RoadPlanvTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"RoadPlanvTableViewCell" owner:self options:nil];
        cell=[arry objectAtIndex:0];
    }
    //驾车
    if (_tableView.tag==0) {
        cell.labsubAddress.hidden=YES;
        AMapStep*step=[_carArray objectAtIndex:indexPath.row];
        cell.labeAddress.text=step.instruction;
       
    }
    if (_tableView.tag==1) {
             AMapStep*step=[_busArray objectAtIndex:indexPath.row];
//        NSString*str11=[_busArray objectAtIndex:0];
        cell.labeAddress.text=step.instruction;
        cell.labsubAddress.text=[_exitNameArray objectAtIndex:indexPath.row];
        
    }
    if (_tableView.tag==2) {
        
    }
  
 


    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
