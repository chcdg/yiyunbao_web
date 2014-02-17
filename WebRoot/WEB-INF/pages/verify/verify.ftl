<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    <style type="text/css">
        .verify-summary-title{
            font-weight: bold;
            font-size: 14px;
            font-family:Microsoft YaHei;
        }
        .verify-summary-content{
            font-size: 12px;
        }
        .verify-note{
            color:red;
            font-size: 12px;
        }
        
        #idcard
			{
			background:  url('/images/idcard.jpg') no-repeat  ;
			width:470px;
			height:300px;
			}
			
        #idcardback
			{
			background:  url('/images/idcard_back.jpg') no-repeat  ;
			width:470px;
			height:300px;
			}
    </style>
 </head>
<body>
         
        <input name="id" class="mini-hidden" />
        <div style="padding-left:11px;padding-bottom:5px;">
            
        </div>
           
        <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:950px;" plain="false">
   		  <div title="身份证验证" closable="false">
   		  
            <div id="toolbar1" class="mini-toolbar" style="padding:2px;margin-bottom:15px;">
                <table style="width:100%;">
                    <tr>
                        <td style="font-size:12px;">付费验证的费用为<b style="color:red">5</b>物流币/次，您当前的余额为<b style="color:red">${(user.gold?string("0.00"))!"0.00"}</b>个物流币
                        </td>
                        <td align="right">
                            <a class="mini-button" href="/pay" plain="false" target="_blank" iconCls="icon-user">充值</a>
                        </td>
                         <td >
                            <a class="mini-button" onclick="idCardHistory()" iconCls="icon-node">验证记录</a>   
                        </td>
                    </tr>
                </table>
            </div>
   		  	<form id="form1" method="post">
            	<table >
                    <tr>
                        <td style="width:100px;"> 姓名：</td>
                        <td style="width:200px;">    
                            <input id="id_name" name="id_name" class="mini-textbox" required="true" size=300	 /><font color="red">*</font>
                        </td>
                        <td style="width:120px;">身份证：</td>
                        <td style="width:200px;">      
                            <input id="id_card" name="id_card" class="mini-textbox" required="true"  /><font color="red">*</font>
                        </td>
                        <td style="width:100px;">
                            <a class="mini-button" onclick="btnIdCard()" style="width:60px;margin-right:20px;">确定</a>   
                        </td>
                       
                    </tr>
                    <tr>
	                    <td colspan="6">
	                    	
                      <p>
                <span class="verify-summary-title">说明</span>
                <ol class="verify-summary-content">
                    <li>付费身份证验证是直接连接到中国全国公民身份证号码查询服务中心，根据输入的姓名和身份证号码验证其一致性。</li>
                    <li>返回结果包括初始发证地、出生年月日、性别及验证结果（一致或不一致）。在结果“一致”的情况下，还可以进一步对比身份证证件照是否与本人一致。
                    </li>
                </ol>
                <div class="verify-note">注：由于数据同步问题，并不保证所有人都包含身份证证件照。查询成功后结果将自动保存在查询记录里。</div>
                <input  type="button" value="打印结果" onclick="print()">
            </p>
	                    </td>
                    </tr>
                    <tr>
                        <td style="width:100%;" colspan="5" >    
                        	
                        </td>
                       
                    </tr>
                </table>
            <iframe id="idcart_result" width="90%" height="620"></iframe>
            </form>
          


    </div>
    <div title="驾驶证验证"  closable="false">
            <div id="toolbar1" class="mini-toolbar" style="padding:2px;margin-bottom:15px;">
                <table style="width:100%;">
                    <tr>
                        <td style="font-size:12px;">付费验证的费用为<b style="color:red">5</b>物流币/次，您当前的余额为<b style="color:red">${(user.gold?string("0.00"))!"0.00"}</b>个物流币
                        </td>
                        <td align="right">
                            <a class="mini-button" href="/pay" plain="false" target="_blank">充值</a>
                        </td>
                    </tr>
                </table>
            </div>
    	<form id="form2" method="post">
        	<table style="table-layout:fixed;">
                <tr>
                    <td style="width:160px;"> 驾驶证姓名：</td>
                    <td style="width:200px;">    
                        <input id="jsz_name" name="jsz_name" class="mini-textbox" required="true" size=300	 /><font color="red">*</font>
                    </td>
                    <td style="width:130px;">驾驶证号：</td>
                    <td style="width:200px;">      
                        <input id="jsz_num" name="jsz_num" class="mini-textbox" required="true"  /><font color="red">*</font>
                    </td>
                     <td style="width:100px;">
                        <a class="mini-button" onclick="btnJSZ()" style="width:60px;margin-right:20px;">确定</a>   
                    </td>
                </tr>
            </table>
        </form>
        <p>
            <span class="verify-summary-title">说明</span>
            <ol class="verify-summary-content">
                <li>驾驶证查询数据来自权威管理机构，根据输入的姓名和驾驶证号码验证其一致性。</li>
                <li>返回结果包括初始发证地、出生年月日、性别及验证结果（一致或不一致）。在结果“一致”的情况下，还可以进一步对比驾驶证证件照是否与本人一致。
                </li>
            </ol>
            <div class="verify-note">注：由于数据同步问题，并不保证所有人都包含证件照证件照。查询成功后结果将自动保存在查询记录里。</div>
        </p>
    </div>
    <div title="行驶证验证"  closable="false">
        <h3>国家公安部暂未开放……</h3>
     	<#-- <form id="form3" method="post">
        	<table style="table-layout:fixed;">
                <tr>
                    <td style="width:100px;"> 车牌号：</td>
                    <td style="width:200px;">    
                        <input id="xsz_cph"  name="xsz_cph" class="mini-textbox" required="true" size=300	 /><font color="red">*</font>
                    </td>
                    <td style="width:100px;">发动机号：</td>
                    <td style="width:200px;">      
                        <input id="xsz_fdjh" name="xsz_fdjh" class="mini-textbox" required="true" style="width:180px;" /><font color="red">*</font>
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;"> 车架号：</td>
                    <td style="width:200px;">    
                        <input id="xsz_cjh" name="xsz_cjh" class="mini-textbox" required="true" size=300	 /><font color="red">*</font>
                    </td>
                    <td style="width:200px;">      
                       <a class="mini-button" onclick="btnXSZ()" style="width:60px;margin-right:20px;">确定</a>  
                    </td>
                </tr>
            </table>
        </form> -->
    </div>
</div>   
    

</body>

</html>
<script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
<script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
<script>
    mini.parse();
    var form1 = new mini.Form("form1");
    var form2 = new mini.Form("form2");
    
        function btnIdCard() {
            var o = form1.getData();            
            form1.validate();
            if (form1.isValid() == false) return;
        	//$.jBox.tip("正在验证身份证，请稍候...", 'loading');
			var json = mini.encode([o]);
			var link = "/verify/verifyIdCard?data=" + json; 
			$("#idcart_result").attr("src",link );
            
            
        }
	function print(){
		
            document.getElementById('idcart_result').contentWindow.focus();        
     		document.getElementById('idcart_result').contentWindow.print();
	}
     function btnJSZ() {
            var o = form2.getData();            
            form2.validate();
            if (form2.isValid() == false) return;

            $.jBox.tip("正在验证身份证，请稍候...", 'loading');
			var json = mini.encode([o]);
            $.post("/verify/verifyJSZ",
		  		{
		  		  data:json
		 		 },
		 		 function(response,status){
		 		 	
		 		 	if(!response.success){
		 		 		$.jBox.tip(response.data);
		 		 	}
		 		 	else{
		 		 		$.jBox.tip('接口还未开通');
		 		 	}
		 		 }
		 	);
        }
        
        
        function btnXSZ() {
            var o = form3.getData();            
            form3.validate();
            if (form3.isValid() == false) return;
            $.jBox.tip("正在验证身份证，请稍候...", 'loading');
            var json = mini.encode([o]);
            $.post("/verify/verifyXSZ",
		  		{
		  		 data:json
		 		 },
		 		 function(response,status){
		 		 	if(!response.success){
		 		 		$.jBox.tip(response.data);
		 		 	}
		 		 	else{
		 		 		$.jBox.tip('接口还未开通');
		 		 	}
		 		 }
		 	);
        }   
        
	//身份证验证记录
	 function idCardHistory(row_uid){
        mini.open({
            url: "/verify/idCardHistory",
            title: "身份证验证记录", 
            width: 850, 
            height: 550
        });
     }
</script>