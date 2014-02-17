<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>易运宝--随时随地随您挑！</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="login/css/style.css" rel="stylesheet">
<link rel="stylesheet" href="js/jBox/Skins/Blue/jbox.css" type="text/css"/>
<link rel="stylesheet" href="css/validation/validationEngine.jquery.css" type="text/css"/>
<SCRIPT type="text/javascript" src="js/jquery-1.6.2.min.js"></SCRIPT>
<SCRIPT type="text/javascript" src="login/js/jquery.KinSlideshow-1.2.1.min.js"></SCRIPT>
<script type="text/javascript" src="js/jBox/jquery.jBox-2.3.min.js"></script>
<script type="text/javascript" src="js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
<script type="text/javascript" src="js/jquery.validationEngine-zh_CN.js"></script>
<script type="text/javascript" src="js/jquery.validationEngine.js"></script>
<script type="text/javascript" src="js/jquery.cookie.js"></script>

<SCRIPT type=text/javascript>
function login(){
		if($("#form1").validationEngine('validate')){
			var phone = $("#phone").val();
			var password = $("#password").val();
			
			$.post("/doLogin",
	  		{
	  		  phone:phone,
	 		  password:password
	 		 },
	 		 function(response,status){
	 		 	if(!response.success){
	 		 		$.jBox.error(response.data,'登录失败');
	 		 	}
	 		 	else{
	 		 		window.location.href="/main";
	 		 	}
	 		 });
 		 }
	}
	
	function fogetPWD(){
		var html = "<div style='padding:10px;'>输入注册手机号：<input type='text' id='forgetPhone' name='forgetPhone' /><br>输入注册公司名：<input type='text' id='forgetCompany' name='forgetCompany' /></div>";
		var submit = function (v, h, f) {
   		 if (f.forgetPhone == '') {
    		    $.jBox.tip("请输入注册手机号。", 'error', { focusId: "forgetPhone" }); // 关闭设置 yourname 为焦点
   		    	 return false;
   		 }
   		 if (f.forgetCompany == '') {
    		    $.jBox.tip("请输入注册公司名。", 'error', { focusId: "forgetCompany" }); // 关闭设置 yourname 为焦点
   		    	 return false;
   		 }
   		 var phone = $("#forgetPhone").val();
   		 var company = $("#forgetCompany").val();
   		 $.jBox.tip("正在验证，请稍候...", 'loading');
  		  $.post("/forgetPWD",
	  		{
	  		  phone:phone,
	  		  company:company
	 		 },
	 		 function(response,status){
	 		 	if(!response.success){
	 		 		$.jBox.tip(response.data);
	 		 	}
	 		 	else{
	 		 		$.jBox.tip('新的密码已经发送到您手机，请用新密码登录');
	 		 	}
	 		 });
	 		 
  		  return true;
		};
		$.jBox(html, { title: "忘记密码", submit: submit });
	}
	
$(function(){
	$("#form1").validationEngine();
	 
	$("#KinSlideshow").KinSlideshow({
			moveStyle:"right",
            titleBar:{titleBar_height:30,titleBar_bgColor:"#08355c",titleBar_alpha:0.5},
            titleFont:{TitleFont_size:12,TitleFont_color:"#FFFFFF",TitleFont_weight:"normal"},
            btn:{btn_bgColor:"#FFFFFF",btn_bgHoverColor:"#1072aa",btn_fontColor:"#000000",
         btn_fontHoverColor:"#FFFFFF",btn_borderColor:"#cccccc",
         btn_borderHoverColor:"#1188c0",btn_borderWidth:1}
	});
})

function createDesktop(sUrl,sName)
{
	var objShell = new ActiveXObject("WScript.Shell");    
    var strDesktop = objShell.SpecialFolders("Desktop");    
    var objLink = objShell.CreateShortcut(strDesktop + "//易运宝.lnk");    
    
    with(objLink) {    
        TargetPath = "http://www.baidu.com";    
        WindowStyle = 1;    
        Hotkey = "CTRL+ALT+U";    
        Description = "这是程序描述";    
        WorkingDirectory = strDesktop;    
        Save();    
    }    
}
</SCRIPT>
<script>
	
	
</script>
</head>
<body >
<div class="wrap">
  <div class="mainLogin">
    <!--头部开始-->
    <div class="loginHead"> <a href="#" class="loginLogo"><img src="images/logo.gif" width="147" height="77"></a>
      <div class="loginFontL yahei size18"><font class="left black5">随时随地随您挑！</font><font class="right" style="margin-right:150px;">没有账号？请 <a href="/reg" class="blue"> 注册</a></font></div>
    </div>
    <div class="loginHeadhr"></div>
    <p>
      <!--头部结束-->
      <!--广告图开始-->
    <div class="loginBanner">
      <div class="loginBannerM" id="KinSlideshow"> 
      	<#list adList as ad>
	      <a href="${ad.ad_link!""}" target="_blank"><img src="${ad.ad_img!""}" alt='${ad.ad_title!""}'></a>
      	</#list>
      </div>
    </div>
    <!--广告图结束-->
    <!--登录功能开始-->
    <div class="loginBt"> 
    <form id="form1" action="">
    <span class="loginBtFrom" style="margin-top:83px;"> 
    <font class="yahei size18 black3 left">手机号：</font>
      <input id="phone" name="phone" type="text" class="loginBtFromB validate[required,custom[number]]" value="${login_phone!""}">
      </span>
      <span class="loginBtFrom"> <font class="yahei size18 black3 left">密  &nbsp;&nbsp;码：</font>
      <input id="password" name="password" type="password" class="loginBtFromB validate[required,custom[onlyLetterNumber,minSize[6]]]">
      </span> 
      <a href="/" class="arrows size18 yahei">马上体验</a>
      <input type="button" class="loginBtbutton" onclick="login()">
      <a href="javascript:fogetPWD()" class="loginBtPw size18 yahei">忘记密码？</a> 
      </form>
    </div>
    <!--登录功能结束-->
    <!--常见问题开始-->
    <div class="loginFont size18 yahei">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr width="1024px">
          <td width="20%" nowrap>
         	 <font  size="3">客户热线：400-876-5156</font>
          </td>
          <td width="10%"  nowrap>
         	 <font  size="3"><a href="/contact">联系我们</a></font>
          </td>
          <td width="10%"  nowrap>
         	 <font  size="3">使用说明下载</font>
          </td>
          <td width="10%"  nowrap>
          	<a href="#" ><font   size="3">在线支付相关问题</font></a>
          </td>
          <td  nowrap>
          	<a href="#"  onclick="this.style.behavior='url(#default#homepage)';this.sethomepage('http://www.1yunbao.com');"><font size="3">设置为主页</font></a>
          </td>
          <td width="10%">
          </td>
        </tr>
      </table>
    </div>
    <!--常见问题结束-->
    <!--页脚开始-->
    <div class="loginFoot black9 yahei size16 lheight32">©2013 易运宝 蜀ICP备13009214号 </div>
    <!--页脚结束-->
  </div>
  <div class="footeryy"></div>
</div>
</body>
</html>
<!--[if IE 6]>
	<script type="text/javascript" src="images/dd_belatedpng.js" ></script>
	
	<script type="text/javascript">
	DD_belatedPNG.fix('.main,.footeryy,.logout');
	</script>
	<![endif]-->
