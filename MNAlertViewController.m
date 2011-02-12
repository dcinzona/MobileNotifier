/*
Copyright (c) 2010-2011, Peter Hajas
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Peter Hajas nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL PETER HAJAS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "MNAlertViewController.h"

@implementation MNAlertViewController

@synthesize dataObj;

@synthesize alertHeader, sendAway, takeAction, alertBackground, applicationIcon;
@synthesize delegate = _delegate;

-(id)init
{
	self = [super init];
	if(self != nil)
	{
		alertHeader = [[UILabel alloc] init];
		sendAway = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		alertBackground = [[UIImageView alloc] init];

		//Wire up sendAway!
		[sendAway addTarget:self action:@selector(sendAway:) forControlEvents:UIControlEventTouchUpInside];
		//Wire up the takeAction!
		[takeAction addTarget:self action:@selector(takeAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return self;
}

-(id)initWithMNData:(MNAlertData*) data
{
	self = [super init];
	
	dataObj = data;
	
	return self;
}

-(void)loadView
{
	[super loadView];
	
	alertHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250 , 40)];
	alertHeader.text = dataObj.header;
	alertHeader.font = [UIFont fontWithName:@"Helvetica" size:12];
	alertHeader.backgroundColor = [UIColor clearColor];

	sendAway = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	sendAway.frame = CGRectMake(265, 18, 34, 20);
	[sendAway setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/Application Support/MobileNotifier/sendAwayButton.png"] forState:UIControlStateNormal];
	takeAction = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[takeAction setTitle:dataObj.text forState:UIControlStateNormal];
	[takeAction setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[takeAction setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	takeAction.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10];

	takeAction.frame = CGRectMake(20, 20, 230, 40);
	
	alertBackground = [[UIImageView alloc] init];
	[alertBackground setFrame:CGRectMake(0,0,320,62)];
	alertBackground.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/MobileNotifier/alertBackground.png"];
	
	//Not yet functional :/
	applicationIcon = [[UIImageView alloc] init];
	[applicationIcon setFrame:CGRectMake(10,10,42,42)];
	applicationIcon.image = [_delegate iconForBundleID:dataObj.bundleID];


	//Wire up sendAway!
	[sendAway addTarget:self action:@selector(sendAway:) forControlEvents:UIControlEventTouchUpInside];
	//Wire up the takeAction!
	[takeAction addTarget:self action:@selector(takeAction:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:alertBackground];
	
	[self.view addSubview:alertHeader];
	[self.view addSubview:sendAway];
	[self.view addSubview:takeAction];
	[self.view addSubview:applicationIcon];
	
}

-(void)sendAway:(id)sender
{
	//Notify the delegate
	[_delegate alertViewController:self hadActionTaken:kAlertSentAway];

	//And that's it! The delegate will take care of everything else.
}

-(void)takeAction:(id)sender
{
	//Notify the delegate
	[_delegate alertViewController:self hadActionTaken:kAlertTakeAction];
}

@end
