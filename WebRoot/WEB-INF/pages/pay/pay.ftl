<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>易运宝--随时随地随您挑！</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="/login/css/style.css" rel="stylesheet">
<link rel="stylesheet" href="/css/validation/validationEngine.jquery.css" type="text/css"/>
<link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
<SCRIPT type="text/javascript" src="/js/jquery-1.6.2.min.js"></SCRIPT>
<script type="text/javascript" src="/js/jquery.validationEngine-zh_CN.js"></script>
<script type="text/javascript" src="/js/jquery.validationEngine.js"></script>
<script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
<script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
<script>
	jQuery(document).ready(function(){
	   jQuery("#form1").validationEngine();
	});
	
	function changePayPlatform(val){
		if(val == 3){
			$("#span_money").css("display", "none");
			$("#coupon").css("display", "block");
		}
		else{
			$("#span_money").css("display", "block");
			$("#coupon").css("display", "none");
		}
	}
</script>
</head>
<body >
<div class="wrap">
  <div class="mainLogin">
    <!--头部开始-->
    <div class="loginHead"> <a href="http://www.1yunbao.com" class="loginLogo"><img src="/images/logo.gif" width="147" height="77"></a>
      <div class="loginFontL yahei size18"><font class="left black5">易运宝你的运货好帮手！</font></div>
    </div>
    <!--头部结束-->
    <!--注册导航开始-->
    <div class="change size20 yahei"> <span class="a" style="width:100%">请填写以下信息进行充值</span></div>
    <!--注册导航结束-->
    <!--注册表单开始-->
    <div class="regFrom"> 
    <form id="form1" method="post" action="/pay/pay">
       <span> <font class="yahei size18 black3 left">充值账号：</font>
      	 ${user.phone!""}
      </span> 
     
      
      <span> <font class="yahei size18 black3 left" style="margin-top:20px;">支付方式：</font>
      	<input id="platform_yiyunbao" type="radio" name="pay_platform" value="3" checked="checked" onclick="changePayPlatform(3)"/><img src="/images/pay/yiyunbao.png"/>
      </span> 
      <span > <font class="yahei size18 black3 left" style="margin-top:20px;"> </font>
		<input id="platform_yibao" type="radio" name="pay_platform" value="1"  onclick="changePayPlatform(1)"/><img src="/images/pay/yibao.jpg"/>
      </span> 
      <span > <font class="yahei size18 black3 left" style="margin-top:20px;"> </font>
		<input id="platform_alipay" type="radio" name="pay_platform" value="2" onclick="changePayPlatform(2)"/><img src="/images/pay/alipay.gif"/>
      </span> 
      <div id="coupon">
	      <span> <font class="yahei size18 black3 left">充值卡号：</font>
	      	<input type="text"  id="card_no" name="card_no" class="validate[custom[number]] text-input">
	      </span> 
	      <span> <font class="yahei size18 black3 left">充值密码：</font>
	      	<input type="text"  id="card_pwd" name="card_pwd" class="validate[custom[number]] text-input">
	      </span> 
      </div>
       <span id="span_money" style="display:none"> <font class="yahei size18 black3 left">充值金额：</font>
      	<input type="radio" name="pay_money" value="50" checked="checked" />50元 
		<input type="radio" name="pay_money" value="100" />100元 
		<input type="radio" name="pay_money" value="200" />200元
		<input type="radio" name="pay_money" value="500" />500元
		<input type="radio" name="pay_money" value="-1" />其他
		<input type="text"  id="pay_money2" name="pay_money2" class="validate[custom[number]] text-input">
      </span> 
      <span><input id="payButton" type="submit" class="payButton" value="" ></span>
    </form>  
      </div>
    <!--注册表单结束-->
    <!--常见问题开始-->
    <div class="loginFont size18 yahei">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr width="1024px">
          <td width="10%">
          </td>
          <td width="30%">
         	 <font class="black9" size="2">技术服务：400-876-5156</font>
          </td>
          <td width="20%"> <font size="3">常见问题</font><br>
            <a href="#" class="black9" ><font class="black9" size="2">使用说明下载</font></a>
            </td>
          <td width="20%">
          	<a href="#" class="black9"><font class="black9" size="2">在线支付相关问题</font></a>
          </td>
          <td width="20%">
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
	
