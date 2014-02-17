<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
	    <script src="/js/boot.js"></script>
	    <script src="/js/swfupload/swfupload.js" type="text/javascript"></script>
	    <style type="text/css">
	    	html, body{
			  margin:0;padding:0;border:0;width:100%;height:100%;overflow:hidden;
			} 
	    </style>
	    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
	    <title>批量导入司机</title>
	</head>
	<body >
		<div style="margin-top:30px;padding:10px" align="center">
			<a class="mini-button " iconCls="icon-download" href="http://www.1yunbao.com/mu_ban.xls" >下载模板</a>
		</div>
		<div style="border:1px;color:red;" align="center">温馨提醒：<br>如果您是第一次使用批量导入司机功能，请一定先下载模板.<br>按照我们的格式来填写，这样可以避免未知错误的发生哦</div> 
		    <div style="margin-top:50px;" align="center">
			    <label>请选择文件：</label>
				<input id="importDriver" class="mini-fileupload"
				name="file" limitType="*.xls;*.xlsx" 
				flashUrl="/js/swfupload/swfupload.swf"
				uploadUrl="/fleet/uploadDriverFile" 
				onuploadsuccess="uploadsuccess" 
				onuploaderror="uploaderror"
				 />
				<a class="mini-button " iconCls="icon-upload" onclick="fileUpload" >上传</a>
			</div>
			<div style="margin-top:20px;" align="center"><a class="mini-button " iconCls="icon-no" onclick="closeMyWin" >关闭窗口</a></div>
	    <script type="text/javascript">
  			mini.parse();
//  			mini.get("batchDriver_win").show();
  			
  			function fileUpload(){
  				var upload = mini.get("importDriver");
  				if(upload.getText() == ""){
  					mini.alert("请选择上传到的文件！");
  					return;
  				}
  				upload.startUpload();
  			}
  			function uploadsuccess(){
//  				var load = mini.loading("数据导入中...", "导入中");
//  				$.post("/fleet/batchImportDriver",function(text){
//  					mini.hideMessageBox(load);
//  					mini.alert(text.data);
//  				});	
//  				mini.get("importDriver").setText("");
  				
  				
  				$.ajax({
                     url: "/fleet/batchImportDriver",
                     success: function (text) {
  						mini.alert(text);
  						mini.get("importDriver").setText("");
                     },
                     error: function (text) {
                    	 alert(text);
                     	mini.alert("导入失败，请检查后再试！");
                     }
                 });
  			}
  			
  			function closeMyWin(){
  				window.location.reload();
  				CloseWindow("OK");
  			}
  			
  			
  			function CloseWindow(action) {            
  		        if (window.CloseOwnerWindow) {
  		        	return window.CloseOwnerWindow(action);
  		        }else{ 
  		        	window.close();            
  		        }
  		    }
  		</script>
	</body>
</html>