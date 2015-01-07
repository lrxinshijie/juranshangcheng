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
/* Dev/TEST */
//#define JR_IMAGE_SERVICE  @"http://image1.juran.cn"
//#define JR_SERVICE  @"http://124.207.66.50:10005"

/* UAT */
#define JR_IMAGE_SERVICE  @"http://image1.juran.cn"
#define JR_SERVICE  @"http://54.223.161.28:8080"

/* Production */
//#define JR_IMAGE_SERVICE  @"http://image10.juran.cn"
//#define JR_SERVICE  @"http://app.juran.cn:81"

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
#define JR_MYQUESTION [NSString stringWithFormat:@"%@/QA/myQuestion.json",JR_SERVICE]
#define JR_MYANSWER [NSString stringWithFormat:@"%@/QA/getMyAnswer.json",JR_SERVICE]
#define JR_APPLYMEASUER [NSString stringWithFormat:@"%@/trade/applyMeasure.json",JR_SERVICE]

#define JR_GET_TOKEN_FOR_RESET_PWD [NSString stringWithFormat:@"%@/member/getTokenForResetPwd.json",JR_SERVICE]
#define JR_RESET_PWD [NSString stringWithFormat:@"%@/member/resetPwd.json",JR_SERVICE]
#define JR_PWD_EMAIL [NSString stringWithFormat:@"%@/member/sendFindLoginPwdEmail.json",JR_SERVICE]

#define JR_GETDEDESIGNERPROLIST [NSString stringWithFormat:@"%@/design/getDeDesignerProjectList.json",JR_SERVICE]
#define JR_GET_DE_MYTOPIC [NSString stringWithFormat:@"%@/topic/getDeMyTopic.json",JR_SERVICE]
#define JR_EDIT_MEMBERINFO [NSString stringWithFormat:@"%@/member/editMemberInfo.json",JR_SERVICE]
#define JR_GET_MYREQUESTLIST [NSString stringWithFormat:@"%@/design/getMyRequestList.json",JR_SERVICE]
#define JR_GET_QUESTIONDETAIL [NSString stringWithFormat:@"%@/QA/getQuestionDetail.json",JR_SERVICE]
#define JR_GET_MSG_INFO [NSString stringWithFormat:@"%@/info/get_msg_info.json",JR_SERVICE]
#define JR_GET_ALLAREA_INFO [NSString stringWithFormat:@"%@/location/getAllAreaInfo.json",JR_SERVICE]
#define JR_CHANGE_PWD [NSString stringWithFormat:@"%@/member/changePwd.json",JR_SERVICE]
#define JR_GET_QUESTIONLIST [NSString stringWithFormat:@"%@/QA/getQuestionList.json",JR_SERVICE]
#define JR_GET_DEQUESTIONDETAIL [NSString stringWithFormat:@"%@/QA/getDeQuestionDetail.json",JR_SERVICE]
#define JR_PUBLISHQUESTION [NSString stringWithFormat:@"%@/QA/publishQuestion.json",JR_SERVICE]
#define JR_ANSWER_QUESTION [NSString stringWithFormat:@"%@/QA/answerQuestion.json",JR_SERVICE]
#define JR_SET_BESTANSWER [NSString stringWithFormat:@"%@/QA/setBestAnswer.json",JR_SERVICE]
#define JR_GET_HOTWORDS [NSString stringWithFormat:@"%@/search/getHotwords.json",JR_SERVICE]
#define JR_SEARCH_DESIGNER [NSString stringWithFormat:@"%@/search/searchDesigner.json",JR_SERVICE]
#define JR_GET_MYDEMANDDETAIL [NSString stringWithFormat:@"%@/design/getMyDesignReqDetailInfo.json",JR_SERVICE]
#define JR_GET_TOPICDETAIL [NSString stringWithFormat:@"%@/topic/getTopicDetail.json",JR_SERVICE]
#define JR_COMMIT_TOPIC [NSString stringWithFormat:@"%@/topic/commitTopic.json",JR_SERVICE]
#define JR_GET_OLDTOPICLIST [NSString stringWithFormat:@"%@/topic/getOldTopicList.json",JR_SERVICE]
#define JR_SEARCH_QUESTION [NSString stringWithFormat:@"%@/search/searchQuestion.json",JR_SERVICE]
#define JR_UPDATE_BINDINGEMAIL [NSString stringWithFormat:@"%@/member/updateBindingEmail.json",JR_SERVICE]
#define JR_ADD_FEEDBACK [NSString stringWithFormat:@"%@/support/addFeedback.json",JR_SERVICE]
#define JR_SAVE_MOBILEPHONE [NSString stringWithFormat:@"%@/member/saveMobilePhone.json",JR_SERVICE]
#define JR_REQ_STOP [NSString stringWithFormat:@"%@/design/ReqStop.json",JR_SERVICE]
#define JR_REJECT_DESIGNREQ [NSString stringWithFormat:@"%@/design/rejectDesignReq.json",JR_SERVICE]
#define JR_SET_MSG_READ [NSString stringWithFormat:@"%@/info/set_msg_read.json",JR_SERVICE]
#define JR_GET_VERSION [NSString stringWithFormat:@"%@/search/getVersion.json",JR_SERVICE]
#define JR_GET_MSG_DETAIL [NSString stringWithFormat:@"%@/info/get_msg_detail.json",JR_SERVICE]

















#define JR_UPLOAD_HEAD_IMAGE [NSString stringWithFormat:@"%@/member/uploadHeadImage.htm",JR_SERVICE]

#define JR_ADD_COMMENT [NSString stringWithFormat:@"%@/design/addComment.json",JR_SERVICE]
#define JR_GET_BANNER_INFO [NSString stringWithFormat:@"%@/member/getBannerInfo.json",JR_SERVICE]
#define JR_THIRD_LOGIN [NSString stringWithFormat:@"%@/member/thirdLogin.json",JR_SERVICE]
#define JR_SUBJECT_LIST [NSString stringWithFormat:@"%@/info/get_subject_list.json",JR_SERVICE]
#define JR_SUBJECT_DETAIL [NSString stringWithFormat:@"%@/info/get_subject_detail.json",JR_SERVICE]
#define JR_CASE_LIKE [NSString stringWithFormat:@"%@/design/givealike.json",JR_SERVICE]
#define JR_CASE_FAVORITE [NSString stringWithFormat:@"%@/design/addprjfavorite.json",JR_SERVICE]
#define JR_CASE_UNFAVORITE [NSString stringWithFormat:@"%@/design/removeprjfavorite.json",JR_SERVICE]
#define JR_PUBLISH_DESIGN [NSString stringWithFormat:@"%@/design/publishDesign.json",JR_SERVICE]
#define JR_FAV_PROJECT [NSString stringWithFormat:@"%@/design/getMyFavProject.json",JR_SERVICE]
#define JR_PRIVATE_LIST [NSString stringWithFormat:@"%@/member/getPrivateLetterList.json",JR_SERVICE]
#define JR_PRIVATE_DETAIL [NSString stringWithFormat:@"%@/member/getPrivateLetterDetailList.json",JR_SERVICE]
#define JR_SEARCH_CASE [NSString stringWithFormat:@"%@/search/searchProject2d.json",JR_SERVICE]
#define JR_UPLOAD_IMAGE [NSString stringWithFormat:@"%@/image/uploadImage.htm",JR_SERVICE]
#define JR_SEND_PRIVATE [NSString stringWithFormat:@"%@/member/sendPrivateLetter.json",JR_SERVICE]
#define JR_APPLY_MEASURE [NSString stringWithFormat:@"%@/trade/applyMeasure.json",JR_SERVICE]
#define JR_REPLY_LETTER [NSString stringWithFormat:@"%@/member/replyPrivateLetter.json",JR_SERVICE]
#define JR_DELETE_LETTER [NSString stringWithFormat:@"%@/member/deletePrivateLetter.json",JR_SERVICE]

#define kHTTPMethodGet @"GET"
#define kHTTPMethodPost @"POST"


//设计师端
#define JR_GET_INDEX_DESIGN_REQ_LIST [NSString stringWithFormat:@"%@/index/getIndexDesignReqList.json",JR_SERVICE]
#define JR_GET_INDEX_PRIVATELETTERREP [NSString stringWithFormat:@"%@/index/getIndexPrivateLetterReq.json",JR_SERVICE]
#define JR_GET_INDEX_DESIGNER_LIST_REQ [NSString stringWithFormat:@"%@/index/getIndexDesignerListReq.json",JR_SERVICE]
#define JR_GET_DESIGNER_SELFDETAIL [NSString stringWithFormat:@"%@/member/getDesignerSelfDetail.json",JR_SERVICE]
#define JR_GET_DEPROJECTLISTREQ [NSString stringWithFormat:@"%@/project/getDeProjectListReq.json",JR_SERVICE]
#define JR_GET_REALNAMEAPPLY [NSString stringWithFormat:@"%@/design/getRealNameApply.json",JR_SERVICE]
#define JR_REALNAME_APPLY [NSString stringWithFormat:@"%@/member/realNameApply.json",JR_SERVICE]
#define JR_GET_DESIGNER_CENTERINFO [NSString stringWithFormat:@"%@/member/getDesignerCenterInfo.json",JR_SERVICE]








#define JR_CREATE_PROJECT [NSString stringWithFormat:@"%@/project/createProjectReq.json",JR_SERVICE]

#endif
