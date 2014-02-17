<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>易运宝--随时随地随您挑！</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link href="/css/style.css" rel="stylesheet" />
<#-- <link href="/css/contactable.css" rel="stylesheet"> -->

<LINK href='/css/qq_blue.css' type=text/css rel=stylesheet>

<script type="text/javascript" src="/js/jquery-1.6.2.min.js"></script>
<#-- <script type="text/javascript" src="/js/contactable.js"></script> -->
<script type="text/javascript" src="/js/boot.js"></script>
<script type="text/javascript" src="/js/pptBox.js"></script>
<script type="text/javascript" src="/js/jquery.raty.min.js"></script>
<SCRIPT src='/js/jquery.Sonline.js'></SCRIPT>
<script>
	jQuery(function($){
		/*
		$('#contact').contactable({
	 		recipient: 'test@test.com',
	 		subject: 'A Feeback Message'
	 	});
		$("#contactable").click();
		*/

		$("#publishOrder").click(function(){
			mini.open({
                url:  "/order/publishOrder",
                title: "发布货单",
                width: 700,
                height: 600,
                allowDrag:true,
                allowResize:false,
                ondestroy: function (action) {
                  
                    if (action == "ok") {
                        // var iframe = this.getIFrameEl();
                        
                        // var data = iframe.contentWindow.GetData();
                        // data = mini.clone(data);
                        
                        // btnEdit.setValue(data.id);
                        // btnEdit.setText(data.text);
                    }
                }
            });
		});
		
		//证件验证
		$("#btnVerify").click(function(){
			 mini.open({
                url: "/verify",
                title: "证件验证", 
                width: 750, 
                height: 600
            });
		});
		
		//保险
		$("#btnSafety").click(function(){
			 mini.open({
               url: "/insurance/cpic",
		          title: "中国太平洋国内货运险投保系统", width: 900, height: 700
            });
		});
		
		//修改密码
		$("#btnUpdatePWD").click(function(){
			 mini.open({
                url: "/newPWD",
                title: "修改密码", 
                width: 300, 
                height: 200
            });
		});
		
		$.fn.raty.defaults.path = '/images/rate';
    	$('#myscore').raty({
    		score : ${user.score},
    		readOnly : true
    	});
    	
    	$("body").Sonline({
			Position:"right",//left或right
			Top:200,//顶部距离，默认200px
			Effect:true, //滚动或者固定两种方式，布尔值：true或false
			DefaultsOpen:true, //默认展开：true,默认收缩：false
			Qqlist:"2540609923|客服01,1937657942|客服02,2867692922|客服03" //多个QQ用','隔开，QQ和客服名用'|'隔开
		});
    	
	});
	
</script>
</head>
<body>
<div class="wrap">
<div class="main">
    <div class="banner"><div > 
    <script>
     var box =new PPTBox();
     box.width =1024; //宽度
     box.height = 85;//高度
     box.autoplayer = 3;//自动播放间隔时间
	<#list adList as ad>
	     box.add({"url":"${ad.ad_img!""}","href":"${ad.ad_link!"#"}","title":"${ad.ad_title!""}"});
  	</#list>
     box.show();
    </script>
    </div></div>
    <div class="header">
        <div id="logo" class="bleft fl">
            <h1 style="margin-left:20px;"><img src="/images/logo.gif" width="147" height="77"></h1>
        </div>
        <div class="toobar bcenter fl">
            <div class="tbutton"><a class="publish" href="javascript:void(0)" id="publishOrder">发布货源</a></div>
            <div class="tbutton"><a class="verify"  href="javascript:void(0)" id="btnVerify">证件验证</a></div>
            <div class="tbutton"><a class="safety" href="javascript:void(0)" id="btnSafety">货运保险</a></div>
             <a class="app yahei" href="http://www.1yunbao.com/file/yiyunbao_hz.apk" title="点击下载易运宝安卓版" alt="点击下载易运宝安卓版"></a>
            <a class="app yahei" href="http://www.1yunbao.com/file/yiyunbao_hz.ipa" title="点击下载易运宝苹果版" alt="点击下载易运宝苹果版"></a>
        </div>
        <div class="user bright fl">
            <div class="uname"><span id="loginUserName"><font size="3">${companyName!""}</font></span></div>
            <div class="action" style="text-align:center">
           	 物流币:￥${(user.gold!0)?string("0.00")}  <a href="/pay" target="_blank">充值</a>  <a href="/logout">注销</a>
           	 <br>
           	 <div style="margin-left:40px;">
           	 	<div id="myscore" ></div>
           	 </div>
            </div>
        </div>
        <div class="clear"></div>
    </div>
    <div class="center" >
       
        <div class="bcenter content fl" style="width:100%">
        	<iframe  src="/content" id="mainframe" frameborder="0" name="main" style="width:100%;height:100%;" border="0" scrolling="no"></iframe>
		</div>
        
        <div class="clear"></div>
    </div>
    <div class="footer">
        @2013 易运宝 蜀ICP备13009214号
    </div>
    </div><div class="footeryy"></div>
    <div id="contact"></div>
</div>
</body>
</html>

