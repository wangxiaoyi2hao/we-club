//
//  MpaViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/10/31.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "MpaViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "RoadPlanViewController.h"
#import "TestViewController.h"






@interface MpaViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{

    MAMapView *_mapView;
    AMapSearchAPI *_search;//搜索的东西
    UIButton*_locationButton;//自定义一个定位模式下的button
    CLLocation*_currentLocation;
    
    
    UIButton*_navWorkButton;//步行
    UIButton*_navBusButton;//公交行
    UIButton*_navCarButton;//汽车行
    
    
    //显示店家的经纬度
    float barLatitude; //纬度
    float barLongitude;//经度
    
    //我的位置信息
    MAUserLocation *userLocation;
    
    
}

@end

@implementation MpaViewController
//自定义了右下角的变换模式的button
-(void)initCountrols{


    
    _locationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame=CGRectMake(20, CGRectGetHeight(_mapView.bounds)-80, 40, 40);
    _locationButton.autoresizingMask=UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    _locationButton.backgroundColor=[UIColor blackColor];
    _locationButton.alpha=0.8;
    _locationButton.layer.cornerRadius=5;
    [_locationButton addTarget:self action:@selector(locateActopm) forControlEvents:UIControlEventTouchUpInside];
    [_locationButton setImage:[UIImage imageNamed:@"定位-2.png"] forState:UIControlStateNormal];
    [_mapView addSubview:_locationButton];
 
    
    
    _navBusButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _navBusButton.frame=CGRectMake(220, CGRectGetHeight(_mapView.bounds)-78,70, 40);
    _navBusButton.layer.cornerRadius=5;
    _navBusButton.autoresizingMask=UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    _navBusButton.backgroundColor=[UIColor blackColor];
    _navBusButton.alpha=0.8;
    [_navBusButton setTitle:@"查询路线" forState:UIControlStateNormal];
    _navBusButton.titleLabel.textColor=[UIColor whiteColor];
    _navBusButton.titleLabel.font=[UIFont systemFontOfSize:13];
//    [_mapView addSubview:_navBusButton];
    [_navBusButton addTarget:self action:@selector(pushPlanController) forControlEvents:UIControlEventTouchUpInside];

}

//跳转到路径页面
-(void)pushPlanController{
    TestViewController*controller=[[TestViewController alloc]init];
   
    [self.navigationController pushViewController:controller animated:YES];

}



-(void)initSearch{
    //搜索服务的key
    [AMapSearchServices sharedServices].apiKey = @"91c9bb4d5527e9d1832545c8da02a0f2";
    //关键字搜索
    _mapView.zoomLevel=11.5;
    _search = [[AMapSearchAPI alloc] init];
//    _mapView.mapType=MKMapTypeSatellite;
//    [_mapView metersPerPointForCurrentZoomLevel]=1000
    _search.delegate = self;
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项但是也要必须填写，要不他会给到一个suggestion中
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    #pragma mark  需要给变量
    geo.address =_barCity;
  
    geo.city=_barCity;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    //发起正向地理编码
    [_search AMapGeocodeSearch: geo];

    
    
 
 
}
#pragma 这个事件可以让路线开始导航～～
-(void)roadPlan{
    [AMapSearchServices sharedServices].apiKey = @"91c9bb4d5527e9d1832545c8da02a0f2";
    //关键字搜索
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;

    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude:39.994949 longitude:116.447265];
    request.destination = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    request.strategy = 2;//距离优先
    request.requireExtension = YES;
    
    //发起路径搜索
    [_search AMapDrivingRouteSearch: request];
}

//规划路线的回调方法
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route ==nil)
    {
        return;
    }
    
    //通过AMapNavigationSearchResponse对象处理搜索结果
    AMapRoute *route = response.route;
    for (int i=0; i<route.paths.count; i++) {
        AMapPath*aaa=[route.paths objectAtIndex:i];
        
        for (int i=0; i<aaa.steps.count; i++) {
            AMapStep*bbb=[aaa.steps objectAtIndex:i];
#pragma mark  我要的值－－－－要的路线图已经出来了
            NSLog(@"%@",bbb.instruction);
        }
      
    }

}
//实现正地理编码给出经纬度
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if(response.geocodes.count == 0)
    {
        return;
    }
    
    //通过AMapGeocodeSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %d", response.count];
    NSString *strGeocodes = @"";
    for (AMapTip *p in response.geocodes) {
        strGeocodes = [NSString stringWithFormat:@"%@\ngeocode: %@", strGeocodes, p.description];

    }
 
//    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strGeocodes];

    for (int i=0; i<response.geocodes.count; i++) {
        AMapGeocode*aaa=[response.geocodes objectAtIndex:i];
      
        barLatitude=aaa.location.latitude;
        barLongitude=aaa.location.longitude;
    }
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
#pragma mark 这里给活的经纬度  给活的名字
    //这里给活的经纬度  给活的名字
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(barLatitude, barLongitude);
    pointAnnotation.title = _barCity;
    pointAnnotation.subtitle = _barCity;
    
    [_mapView addAnnotation:pointAnnotation];
  
//    AMapTransitRouteSearchRequest
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //验证高德地图的key
    [MAMapServices sharedServices].apiKey = @"91c9bb4d5527e9d1832545c8da02a0f2";
    //定位开启
    _mapView.showsUserLocation = YES;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
//    _mapView.showTraffic= YES;

   
    
    [self.view addSubview:_mapView];
    //导航条
    [self loadNav];
    [self initSearch];

    //地图下方的模式切换
    [self initCountrols];
   

    
  
}


#pragma mark 搜索需要完成的事件
//让它显示泡可以显示定位的地理位置
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if ([view.annotation isKindOfClass:[MAUserLocation  class]]) {
        [self reGeoAction];
    }



}

//逆地理编码请求
-(void)reGeoAction{

    if (_currentLocation) {
        AMapReGeocodeSearchRequest*request=[[AMapReGeocodeSearchRequest alloc]init];
        request.location=[AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
     
        [_search AMapReGoecodeSearch:request];
    }

  

}
//search的回调
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
}

//逆地理编码
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
 
    NSString*title=response.regeocode.addressComponent.city;
    if (title.length==0) {
        title=response.regeocode.addressComponent.province;
    }
    _mapView.userLocation.title=title;
    _mapView.userLocation.subtitle=response.regeocode.formattedAddress;
    NSLog(@"%@",    _mapView.userLocation.location);

    
}
//搜索按钮事件
-(void)searchAction{
    if (_currentLocation==nil||_search==nil) {
     
        return;
    }
    
  
}
#pragma mark 定位模式的事件
//左下角定位按钮模式实现
-(void)locateActopm{
    if (_mapView.userTrackingMode!=MAUserTrackingModeFollow) {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }

}
//修改按钮状态
-(void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated{
    if (mode==MAUserTrackingModeNone) {
        [_locationButton setImage:[UIImage imageNamed:@"定位-2.png"] forState:UIControlStateNormal];
    }else{
    
       [_locationButton setImage:[UIImage imageNamed:@"定位-1.png"] forState:UIControlStateNormal];
    }


}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
      
        _currentLocation=_mapView.userLocation.location;

    }
}
// 实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image=[UIImage imageNamed:@"bigHead.png"];
        annotationView.centerOffset=CGPointMake(0, -13);
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
//        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
#pragma mark 导航条的配置
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
-(void)viewDidDisappear:(BOOL)animated{

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
