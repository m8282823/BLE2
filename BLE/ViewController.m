//
//  ViewController.m
//  BLE
//
//  Created by HGDQ on 15/10/16.
//  Copyright (c) 2015年 HGDQ. All rights reserved.
//

#import "ViewController.h"
#import <GameKit/GameKit.h>

@interface ViewController ()<GKPeerPickerControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *sendTextField;
@property (weak, nonatomic) IBOutlet UILabel *revLabel;
@property (weak, nonatomic) IBOutlet UIButton *openBLE;
@property (strong,nonatomic) GKSession *session;//蓝牙连接会话

@property (nonatomic,copy)NSString *sendString;

@end

@implementation ViewController

#pragma mark - 控制器视图方法
- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setSendTextField];
}
/**
 *  sendTextField代理关联
 */
- (void)setSendTextField{
	self.sendTextField.delegate = self;
	self.sendTextField.placeholder = @"数据发送区";
	self.sendTextField.clearButtonMode = UITextFieldViewModeAlways;
}
/**
 *  打开蓝牙设备按钮
 *  打开蓝牙设备 开始搜索
 *  @param sender sender description
 */
- (IBAction)openBLE:(id)sender {
	GKPeerPickerController *pearPickerController=[[GKPeerPickerController alloc]init];
	pearPickerController.delegate=self;
	[pearPickerController show];
}
/**
 *  发送数据按钮
 *
 *  @param sender sender description
 */
- (IBAction)sendButton:(id)sender {
	//NSString转NSData
	NSData *data = [self.sendString dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error=nil;
	//蓝牙设备发送数据
	[self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
	if (error) {
		NSLog(@"发送数据过程中发生错误，错误信息:%@",error.localizedDescription);
	}
}
#pragma mark - UITextFieldDelegate代理方法
/**
 *  textField可以编辑
 *
 *  @param textField textField description
 *
 *  @return YES  可以编辑   NO  不可以编辑
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	return YES;
}
/**
 *  键盘Return键按下
 *  收起键盘
 *  @param textField textField description
 *
 *  @return return value description
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	NSLog(@"texe = %@",textField.text);
	self.sendString = textField.text;
	[textField resignFirstResponder]; //收起键盘
	return YES;
}
#pragma mark - GKPeerPickerController代理方法
/**
 *  连接到某个设备
 *
 *  @param picker  蓝牙点对点连接控制器
 *  @param peerID  连接设备蓝牙传输ID
 *  @param session 连接会话
 */
-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	self.session=session;
	NSLog(@"已连接客户端设备:%@.",peerID);
	//设置数据接收处理句柄，相当于代理，一旦数据接收完成调用它的-receiveData:fromPeer:inSession:context:方法处理数据
	[self.session setDataReceiveHandler:self withContext:nil];
	
	[picker dismiss];//一旦连接成功关闭窗口
}

#pragma mark - 蓝牙数据接收方法
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
	//NSdata转NSString
	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	//给接收区显示
	self.revLabel.text = str;
	NSLog(@"数据接收成功！");
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end




























