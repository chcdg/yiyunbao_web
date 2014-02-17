<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
 </head>
<body>
    <#-- <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:550px;" plain="false"> -->
        <div name="first" class="mini-panel" title="个人资料" style="width:100%;" showCollapseButton="true">
            <table style="table-layout:fixed;" >
                <tr>
                    <td style="width:100px;">手机号码：</td>
                    <td style="width:200px;">
                        ${user.phone!?html}
                    </td>
                     <td style="width:100px;">公司名称：</td>
                    <td style="width:200px;">
                        ${user.company_name!?html}
                    </td>
                   
                </tr>
                <tr>
                    <td style="width:100px;">联系人：</td>
                    <td style="width:200px;">
                        ${user.name!?html}
                    </td>
                    <td style="width:100px;">座机：</td>
                    <td style="width:200px;">
                        ${user.telcom!?html}
                    </td>
                    
                </tr>
                
                <tr>
                	 <td style="width:100px;">推荐人：</td>
                    <td style="width:200px;">
                        ${user.recommender!?html}
                    </td>
                	 <td style="width:100px;">注册时间：</td>
                    <td style="width:200px;">
                        ${(user.regist_time?string("yyyy-MM-dd HH:mm:ss"))!}
                    </td>
                   
                    
                </tr>
                <tr>
                	  <td style="width:100px;">营业执照：</td>
                    <td style="width:200px;">
                        <a href="${user.licence_photo!"/images/nopic.png"}" target="_blank"> <img src="${user.licence_photo!"/images/nopic.png"}" width="60" height="60"></a>
                    </td>
                	  <td style="width:100px;">地址：</td>
                    <td style="width:200px;">
                        ${user.address!?html}
                    </td>
                   
                </tr>
                <tr>
                   
                    <td style="width:100px;height:40px;" colspan="2" align="center">
                    	<a class="mini-button" onclick="edit()" plain="false" iconCls="icon-edit">修改资料</a>
				 	</td>
				  <td style="width:100px;height:40px;" colspan="2" align="center">
                    	<a class="mini-button" onclick="changePassword()" plain="false" iconCls="icon-edit">修改密码</a>
				 </td>
                </tr>
            </table>
        </div>
        <div class="mini-panel" title="我的帐户" style="width:100%;" showCollapseButton="true">
            <table style="table-layout:fixed;" >
                <tr>
                    <td style="width:100px;">帐户余额</td>
                    <td style="width:200px;">
                        ${(user.gold!0)?string("0.00")}
                    </td>
                    <td style="width:100px;">
                        <a class="mini-button" href="/pay" plain="false" target="_blank" iconCls="icon-user">帐号充值</a>
                    </td>
                    <td style="width:200px;">
                    	<a class="mini-button" onclick="businessList()" plain="false" iconCls="icon-downgrade">账户记录</a>
                    </td>
                </tr>
            </table>
        </div>
        <div class="mini-panel" title="我的信誉" style="width:100%;" showCollapseButton="true">
            <table style="table-layout:fixed;" >
            	<tr>
                    <td style="width:100px;">信誉评价：</td>
                    <td style="width:200px;" 
                    	<div id="myscore"></div>
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">履约诚信度：</td>
                    <td style="width:200px;">
                    	<div id="myscore1"></div>
                    	
                    </td>
                     
                </tr>
                 <tr>
                   <td style="width:100px;">信息真实度：</td>
                    <td style="width:200px;">
                    	<div id="myscore2"></div>
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">付款及时率：</td>
                    <td style="width:200px;" >
                    	<div id="myscore3"></div>
                    </td>
                    <td style="width:200px;"  >
                    	<a class="mini-button"  onclick="reply()" plain="false" target="_blank" iconCls="icon-node">详情</a>
                    </td>
                </tr>
            </table>
        </div>
         <div class="mini-panel" title="我的排名" style="width:100%;" showCollapseButton="true">
            <table style="table-layout:fixed;" >
            	 <tr>
                    <td style="width:140px;">成交货单数量：</td>
                    <td style="width:100px;">
                        ${(user.order_count!0)?string("0")} 单
                    </td>
                    <td style="width:50px;">排名：
                    </td>
                    <td style="width:100px;">
                        ${(user.order_count_rank!0)?string("0")} 位
                    </td>
                </tr>
                <tr>
                    <td style="width:140px;">保费成交金额：</td>
                    <td style="width:100px;">
                        ${(user.insurance_count!0)?string("0")} 元
                    </td>
                   <td style="width:50px;">排名：
                    <td style="width:100px;">
                        ${(user.insurance_count_rank!0)?string("0")} 位
                    </td>
                </tr>
                  <tr>
                    <td style="width:140px;">验证数量：</td>
                    <td style="width:200px;">
                        ${(user.verify_count!0)?string("0")} 次
                    </td>
                    <td style="width:50px;">排名：
                    </td>
                    <td style="width:100px;">
                        ${(user.verify_count_rank!0)?string("0")} 位
                    </td>
                </tr>
                <tr>
                    <td style="width:140px;">成功推荐数量：</td>
                    <td style="width:200px;">
                        ${(user.recommender_count!0)?string("0")} 次
                    </td>
                    <td style="width:50px;">排名：
                    </td>
                    <td style="width:100px;">
                        ${(user.recommender_count_rank!0)?string("0")} 位
                    </td>
                </tr>
               
                <tr>
                    <td style="width:140px;">车队规模：</td>
                    <td style="width:200px;">
                        ${(user.fleet_count!0)?string("0")} 辆
                    </td>
                    <td style="width:50px;">排名：
                    </td>
                    <td style="width:100px;">
                        ${(user.fleet_count_rank!0)?string("0")} 位
                    </td>
                </tr>
              
                 <tr>
                    <td colspan="4">
                    	提示：排名为0表示还未进入我们的排名，需要加油哦！
					</td>
                </tr>
            </table>
        </div>
    <#-- </div> -->
</body>
</html>
 <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
    <script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
    <script type="text/javascript" src="/js/jquery.raty.min.js"></script>
<script>
    mini.parse();
    //修改资料成功后，更新首页顶部显示登陆用户名
	parent.parent.window.document.getElementById("loginUserName").innerHTML = "${user.company_name!?html}";
    function changePassword(){
        mini.open({
            url: "/newPWD",
            title: "修改密码", 
            width: 300, 
            height: 200
        });
    }
    
     function edit(){
        mini.open({
            url: "/account/edit",
            title: "修改资料", 
            width: 500, 
            height: 300,
            ondestroy: function (action) {
                window.location.reload();
                
            }
        });
    }
    
    function businessList(){
        mini.open({
            url: "/account/business",
            title: "账户记录", 
            width: 750, 
            height: 500
        });
    }
    
    function reply(){
        mini.open({
            url: "/account/getUserReply" ,
            title: "评价详情", 
            width: 750, 
            height: 500
        });
    }
    
    
    $(function() {
   	 	$.fn.raty.defaults.path = '/images/rate';
    	$('#myscore1').raty({
    		score : ${user.score1},
    		readOnly : true
    	});
    	$('#myscore2').raty({
    		score : ${user.score2},
    		readOnly : true
    	});
    	$('#myscore3').raty({
    		score : ${user.score3},
    		readOnly : true
    	});
    	$('#myscore').raty({
    		score : ${user.score},
    		readOnly : true
    	});
    });
</script>