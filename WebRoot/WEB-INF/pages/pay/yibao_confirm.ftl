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
    <div class="change size20 yahei"> <span class="a" style="width:100%">正在跳转到易宝支付，请稍候……</span></div>
    <!--注册导航结束-->
    <!--注册表单开始-->
    <div class="regFrom"> 
    <form id="form1" method="post" action="${payUrl}" accept-charset="gbk"  onsubmit="document.charset='gbk'">
       <span> <font class="yahei size18 black3 left">充值账号：</font>
      	 ${pay.u_phone!""}
      </span> 
       <span> <font class="yahei size18 black3 left">账户名称：</font>
      	 ${pay.u_name!""}
      </span> 
      <span> <font class="yahei size18 black3 left">充值金额：</font>
      	${pay.pay_money?string("0.00")}元
      </span> 
      <span> <font class="yahei size18 black3 left">支付方式：</font>
      	<img src="/images/pay/yibao.jpg"/>
      </span> 
      <input type="hidden" name="p0_Cmd" value="Buy"><br>
      <input type="hidden" name="p1_MerId" value="${p1_MerId}"><br>
      <input type="hidden" name="p2_Order" value="${pay.id}"><br>
      <input type="hidden" name="p3_Amt" value="${pay.pay_money?string("0.00")}"><br>
      <input type="hidden" name="p4_Cur" value="CNY"><br>
      <input type="hidden" name="p5_Pid" value="${p5_Pid}"><br>
      <input type="hidden" name="p6_Pcat" value=""><br>
      <input type="hidden" name="p7_Pdesc" value=""><br>
      <input type="hidden" name="p8_Url" value="http://www.1yunbao.com/pay/yibao"><br>
      <input type="hidden" name="p9_SAF" value="0"><br>
      <input type="hidden" name="pa_MP" value=""><br>
      <input type="hidden" name="pd_FrpId" value=""><br>
      <input type="hidden" name="pr_NeedResponse" value="1"><br>
      <input type="hidden" name="hmac" value="${hmac}"><br>
      <span><input type="submit" id="payButton" class="button" value="现在去支付"></span>
    </form>  
      </div>
    <!--注册表单结束-->
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
<script>
	$("#payButton").click();
</script>
<!--[if IE 6]>
	<script type="text/javascript" src="images/dd_belatedpng.js" ></script>
	
	<script type="text/javascript">
	DD_belatedPNG.fix('.main,.footeryy,.logout');
	</script>
	<![endif]-->
	
