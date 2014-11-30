//
//  NetworkingConfiguration.h
//  Network
//
//  Created by Kowloon on 12-4-13.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#ifndef NetworkingConfiguration_h
#define NetworkingConfiguration_h

/* Interface */

#define JR_IMAGE_SERVICE  @"http://124.207.66.50:10005"
#define JR_SERVICE  @"http://124.207.66.50:10005"
#define JR_LOGIN [NSString stringWithFormat:@"%@/member/login.json",JR_SERVICE]
#define JR_REGIST_SENDSMS [NSString stringWithFormat:@"%@/member/sendSmsAuth.json",JR_SERVICE]
#define JR_VALIDSMS [NSString stringWithFormat:@"%@/member/validSms.json",JR_SERVICE]
#define JR_REGISTUSER [NSString stringWithFormat:@"%@/member/registUser.json",JR_SERVICE]
#define JR_PROLIST [NSString stringWithFormat:@"%@/design/getprojlist.json",JR_SERVICE]
#define JR_GIVEALIKE [NSString stringWithFormat:@"%@/design/givealike.json",JR_SERVICE]
#define JR_CASE_COMMENT [NSString stringWithFormat:@"%@/design/getComment.json",JR_SERVICE]
#define JR_PRODETAIL [NSString stringWithFormat:@"%@/design/getprojdetail.json",JR_SERVICE]
#define JR_DESIGNERLIST [NSString stringWithFormat:@"%@/member/searchDesignerList.json",JR_SERVICE]
#define JR_DESIGNERDETAIL [NSString stringWithFormat:@"%@/member/getDesignerDetail.json",JR_SERVICE]
#define JR_MYCENTERINFO [NSString stringWithFormat:@"%@/member/getMyCenterInfo.json",JR_SERVICE]
#define JR_SIGNIN [NSString stringWithFormat:@"%@/member/signin.json",JR_SERVICE]
#define JR_GETMEMBERDETAIL [NSString stringWithFormat:@"%@/member/getMemberDetail.json",JR_SERVICE]
#define JR_FOLLOWDESIGNER [NSString stringWithFormat:@"%@/member/followDesigner.json",JR_SERVICE]
#define JR_GETFOLLOWLIST [NSString stringWithFormat:@"%@/member/getFollowList.json",JR_SERVICE]
#define JR_UNFOLLOWDESIGNER [NSString stringWithFormat:@"%@/member/unfollowDesigner.json",JR_SERVICE]

#define JR_GET_TOKEN_FOR_RESET_PWD [NSString stringWithFormat:@"%@/member/getTokenForResetPwd.json",JR_SERVICE]
#define JR_RESET_PWD [NSString stringWithFormat:@"%@/member/resetPwd.json",JR_SERVICE]
#define JR_PWD_EMAIL [NSString stringWithFormat:@"%@/member/sendFindLoginPwdEmail.json",JR_SERVICE]

#define kHTTPMethodGet @"GET"
#define kHTTPMethodPost @"POST"

#endif
