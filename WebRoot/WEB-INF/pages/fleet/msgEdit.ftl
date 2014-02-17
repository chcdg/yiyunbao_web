<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
    <script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
 </head>
<body>
	<table border="0" style="margin-left:10px;margin-top:30px;" cellpadding="5" cellspacing="">
		<tr>
			<td style="color:green">提示：按手机短信收费，0.1物流币/条</td>
		</tr>
		<tr>
			<td>
				手机号码：<input id="phone" name="phone" class="mini-textbox" width="180"  emptyText="请输入要发送的手机号码" required="true"/>
			</td>
		</tr>
		<tr>
			<td>
				<textarea id="content" name="content" class="mini-textarea" width="240" height="100" emptyText="" onkeyup="keypress()"></textarea>
			</td>
		</tr>
		<tr>
			<td align="center">
				<a class="mini-button " iconCls="icon-ok" onclick="sendMsgTo()" >发送</a>
				<label id="pinglun" style="">您还可以输入<b id="count" style="color:red"></b>个字</label>
			</td>
		</tr>
	</table>
</body>
<script>
    mini.parse();
    
    window.onload = function(){
    	var name = "${driver.name!""}";
    	var phone = "${driver.phone!""}";
    	var car_type = "${car_type!""}";
    	var car_length = "${driver.car_length!""}";
    	var last_position = "${driver.last_position!""}";
    	var str;
    	if(null == last_position || "" == last_position){
    		mini.get("content").setEmptyText("暂无司机位置信息，请先定位...");
    	}else{
    		str = name+","+phone+", "+car_type+", "+car_length+"米, 当前位置："+last_position;
    	}
//    	if(null == last_position || "" == last_position){
//    		mini.alert("暂无司机位置信息，请先定位.");
//    		return;
//    	}
    	mini.get("content").setValue(str);
    }
    
    function sendMsgTo(){
    	var phone = mini.get("phone").getValue();
    	var content = mini.get("content").getValue();
    	var str = /^1[34589]\d{9}$/;
    	if(null != phone){
    		if(!(str.test(phone))){
    			mini.alert("手机号码格式不正确.");
    			return;
    		}
    	}
    	$.jBox.tip("正在发送短信，请稍候...", 'loading');
    	$.post("/fleet/sendMsgTo",
		 {
		  phone:phone,
		  content:content
		 },
		 function(response,status){
		 	if(response.success){
		 		 $.jBox.tip("发送成功");
		 		CloseWindow("OK");
		 	}
		 	else{
		 		 $.jBox.tip(response.data);
		 		mini.alert(response.data + '<br><a class="mini-button" href="/pay" plain="false" target="_blank" iconCls="icon-user">帐号充值</a>');
		 	}
		 });
    }
    
    function CloseWindow(action) {            
        if (action == "close" && form.isChanged()) {
            if (confirm("数据被修改了，是否先保存？")) {
                return false;
            }
        }
        if (window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
        else window.close();            
    }
    
    function keypress(){
    	var text = mini.get("content").getValue();
    	var len;//记录剩余字符串的长度   
    	if(text.length>=70){//限制字数
    		mini.alert("亲,一条短信最多只能输入70个字噢");
    		text = text.substr(0,70);
    		len=0; 
    	}else{     
    		len=70-text.length;  //限制字数 
    	}   
    	document.getElementById("count").innerText=len;
    }
</script>
</html>
