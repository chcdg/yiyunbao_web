<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
	<style type="text/css">
		body{
			height: 97%;
		}
	</style>
 </head>
<body>
    <div class="mini-fit" >
    	 <form id="form1" action="/order/receipt"  method="post" >
		 <table style="table-layout:fixed;">
                <tr>
                    <td ></td>
                    <td  colspan="2" align="center">    
                    	回单密码(数字)：<input name="id" value="${order.id}" type="hidden">
                        <input name="receipt_password" class="mini-textbox" required="true" vtype="int" emptyText="请输入回单密码(数字)"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
						<font color="red" size="2">请将回单密码发给收货人，在确认司机完成运输任务后，由收货方告诉司机，司机凭此密码在平台上确认完成交易。</font>       
					</td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
						<a class="mini-button" iconCls="icon-ok" onclick="onOk" style="width:130px;margin-right:20px;">提交回单密码</a>       
					</td>
                </tr>
            </table>
           </form>
	</div>


<script>
    mini.parse();
   var form = new mini.Form("form1");
     function SaveData() {
            var o = form.getData();            

            form.validate();
            if (form.isValid() == false) return;

            $("#form1").submit();
        }

        function GetData() {
            var o = form.getData();
            return o;
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
        
        function onOk(e) {
            SaveData();
        }
        
        function onCancel(e) {
            CloseWindow("cancel");
        }
</script>
</body>
</html>