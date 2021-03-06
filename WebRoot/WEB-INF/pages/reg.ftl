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
        jQuery("#btnReg").click(function(){
        	if(jQuery("#form1").validationEngine('validate')){
        		var phone = $("#phone").val();
				var password = $("#password").val();
				var password2 = $("#password2").val();
				var captcha = $("#captcha").val();
				var recommender = $("#recommender").val();
				var company_name = $("#company_name").val();
				
	        	$.post("/doReg",
		  		{
		  		  phone:phone,
		 		  password:password,
		 		  password2:password2,
		 		  captcha:captcha,
		 		  recommender:recommender,
		 		  company_name:company_name
		 		 },
		 		 function(response,status){
		 		 	if(!response.success){
		 		 		$.jBox.tip(response.data);
		 		 	}
		 		 	else{
		 		 		$.jBox.prompt('注册成功，点击确定后继续完善资料', '成功', 'success', { 
		 		 			closed: function () { 
		 		 				window.location.href="/reg2";
		 		 			} 
		 		 		});
		 		 	}
		 		 });
        	}
        });
        var timeID ;
        jQuery("#btnCaptcha").click(function(){
        	var phone = $("#phone").val();
        	if(phone=='undefined' || phone==''){
        		$.jBox.error('请输入手机号', '错误');
        		return;
        	}
    		var phone = $("#phone").val();
    		$.jBox.tip("正在发送验证码到您的手机，请稍候...", 'loading');
        	$.post("/captcha",
	  		  {
	  		  phone:phone
	 		 },
	 		 function(response,status){
	 		 	$.jBox.tip(response.data);
	 		 });
	 		 
	 		$("#btnCaptcha").css("display","none");
	 		$("#my-timer").css("display","");
	 		var settimmer = 0;
        	timeID = window.setInterval(function() {
                    var timeCounter = $("b[id=show-time]").html();
                    var updateTime = eval(timeCounter)- eval(1);
                    $("b[id=show-time]").html(updateTime);
                    if(updateTime == 0){
                    	$("#btnCaptcha").css("display","block");
                    	$("#my-timer").css("display","none");
                    	$("#show-time").html('60');
                    	window.clearInterval(timeID);
                       // window.location = "/reg";
                    }
                }, 1000);
        });
    });
    
    function showXieyi(){
    	var content = "";
    	content +="尊敬的用户您好，欢迎使用易运宝信息平台！";
    	content +="<br>";
    	content +="易运宝致力于成为中国最有价值、最诚信的货运信息平台，为中国以千万计的物流参与方提供易用、好用的大众物流信息平台。平台倡导使用各方（即用户）以“诚信为本”、“信誉为先”，遵守平台服务使用协议。";
    	content +="<br>";
    	content +="一．服务提示";
    	content +="<br>";
    	content +="1、“易运宝”（http://www.1yunbao.com）提供基于互联网及通信的相关服务。用户在注册过程中点击“同意”表示用户完全接受本协议项下的全部条款，方能获得平台使用权。";
    	content +="<br>";
    	content +="2、平台可根据实际情况全权决定修订本协议。如本协议有变更，将在平台上予以提示，通知予您。您继续登录或使用本平台表示您接受修订后的协议。";
    	content +="<br>";
    	content +="二．服务内容及相关提示";
    	content +="<br>";
    	content +="1、“易运宝”平台服务内容遵守注册时营业执照规定范围。平台根据实际情况，在国家法律充许的情况下保留变更、中断或终止部分或全部服务的权利。";
    	content +="<br>";
    	content +="2、平台在服务时，可能会对部分服务收取一定的费用。在此情况下，平台会在相关页面上做明确的提示。如用户拒绝支付该费用，则不能使用该服务。";
    	content +="<br>";
    	content +="3、易运宝平台仅提供与经营相关的服务，除此之外与相关服务有关的设备及所需的费用（如通讯费及上网费）均应由用户自行负担。";
    	content +="<br>";
    	content +="4、平台提供内容，部分为用户或其它方发布，重要内容（如证件）请及时验证；平台发布信息尽量做到准确，但因众多原因，可能存在准确度不够、信息真实性不够、信息更新不及时等现象，务必请用户通过与对方联系证实相关细节；若在平台上达成交易意向后，双方应进一步签定受国家法律保护的相关协议或合同；平台只是提供信息，并协助达成合作，平台不会承担因双方交易而带来的任何经济与法律风险。";
    	content +="<br>";
    	content +="5、用户使用“易运宝”平台将视为无条件授权平台记录交易双方的合作过程以及相互评价内容，并整理成用户的信誉记录，平台将有权向其它用户展示其信誉记录。";
    	content +="<br>";
    	content +="6、用户应妥善保管帐户和密码，因此而导致的积分及信誉损失，将由用户自己承担。";
    	content +="<br>";
    	content +="三．所有权提示";
    	content +="<br>";
    	content +="1、“易运宝”平台提供的网络服务内容可能包括：货源信息、车源信息、各类商户信息、行业资讯、物流企业介绍等。所有这些内容受版权、商标和其他所有权法律的保护。";
    	content +="<br>";
    	content +="2、用户只有在获得“易运宝”平台官方许可授权之后才能使用这些内容，如擅自复制、再造、或创造与内容有关的产品，公司保留相关法律追责的权利。";
    	content +="<br>";
    	content +="四．使用承诺";
    	content +="<br>";
    	content +="用户在使用“易运宝”平台服务过程中，必须遵循以下原则：";
    	content +="<br>";
    	content +="(1) 遵守国家有关的法律和法规；";
    	content +="<br>";
    	content +="(2) 不得为任何非法目的而使用平台服务；";
    	content +="<br>";
    	content +="(3) 遵守所有与网络、通讯服务有关的网络协议、规定和程序；";
    	content +="<br>";
    	content +="(4) 不得利用“易运宝”平台服务进行任何可能对互联网的正常运转造成不利影响的行为；";
    	content +="<br>";
    	content +="(5)不得利用“易运宝”平台服务传输任何骚扰性的、中伤他人的、辱骂性的、恐吓性的、庸俗淫秽的或其他任何非法的信息资料；";
    	content +="<br>";
    	content +="(6) 不得利用“易运宝”平台服务进行任何不利于他人及“易运宝”平台的行为。";
    	content +="<br>";
    	content +="五．服务变更、中断或终止";
    	content +="<br>";
    	content +="如因系统维护或升级的需要而需暂停网络服务，“易运宝”平台将尽可能事先进行通告。";
    	content +="<br>";
    	content +="如发生下列任何一种情形，“易运宝”平台有权随时中断或终止向用户提供本协议项下的网络服务而无需通知用户：";
    	content +="<br>";
    	content +="(a)	用户提供或发布虚假资料或信息；";
    	content +="<br>";
    	content +="(b)	给其他用户造成实质的损失；";
    	content +="<br>";
    	content +="(b) 用户违反本协议中规定的使用规则。";
    	content +="<br>";
    	content +="除前款所述情形外，“易运宝”平台同时保留在不事先通知用户的情况下随时中断或终止部分或全部网络服务的权利。对于所有因服务的中断或终止而造成的任何损失，“易运宝”平台无需对用户或任何第三方承担任何责任。";
    	content +="<br>";
    	$.jBox.open(content,"“易运宝”平台服务使用协议",600,500);
    	
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
    <div class="change size20 yahei"> <span class="a">填写基本信息</span> <span class="b">完善资料</span> </div>
    <!--注册导航结束-->
    <!--注册表单开始-->
    <div class="regFrom"> 
    <form id="form1" method="post" action="/doReg">
      <span> <font class="yahei size18 black3 left"><font class="red">*</font>手机号：</font>
      	<input id="phone" name="phone" type="text" class="loginBtFromB validate[required,custom[number,minSize[11],maxSize[11]]]]] text-input">
      </span> 
      <span> <font class="yahei size18 black3 left"><font class="red">*</font>验证码：</font>
      	<input id="captcha" name="captcha" type="text" class="loginBtFromB  validate[required,custom[number]] text-input">
     	<input id="btnCaptcha" type="button" class="setCode" value="  ">
     	<div id="my-timer" style="display:none">
        	<b id="show-time">60</b>秒后才能重新获取验证码        
		</div>
      </span> 
      <span> <font class="yahei size18 black3 left"><font class="red">*</font>公司名：</font>
      	<input id="company_name" name="company_name" type="text" class="loginBtFromB validate[required] text-input">
      </span> 
      
      <span> <font class="yahei size18 black3 left"><font class="red">*</font>密&nbsp;&nbsp;&nbsp;&nbsp;码：</font>
      	<input id="password" name="password" type="password" class="loginBtFromB  validate[required,custom[onlyLetterNumber,minSize[6]]] text-input">
      </span> 
      <span> <font class="yahei size18 black3 left"><font class="red">*</font>确认密码：</font>
      	<input id="password2" name="password2" type="password" class="loginBtFromB  validate[required,custom[onlyLetterNumber,minSize[6],equals[password]]] text-input">
      </span> 
      <span nowrap> <font class="yahei size18 black3 left">推荐人：</font>
      	<input id="recommender" name="recommender" type="text" class="loginBtFromB validate[custom[number,minSize[11],maxSize[11]]]]]" >(输入推荐人手机号)
      </span> 
      <span class="yahei size16 left">
      <input id="argee" name="argee" type="checkbox" class="validate[required]" value="" checked="true">
     	 同意协议 <a href="#" class="blue" onclick="showXieyi()">点击查看协议</a> 
      </span> 
      <span><input id="btnReg" type="button" class="regButton" value="" ></span>
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
<!--[if IE 6]>
	<script type="text/javascript" src="images/dd_belatedpng.js" ></script>
	
	<script type="text/javascript">
	DD_belatedPNG.fix('.main,.footeryy,.logout');
	</script>
	<![endif]-->
	
