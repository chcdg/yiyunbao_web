<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
 </head>
<body>
         <form id="form1" action="/account/update"  method="post" enctype="multipart/form-data">
        <input name="id" class="mini-hidden" />
        <div style="padding-left:11px;padding-bottom:5px;">
            <table style="table-layout:fixed;">
                <tr>
                    <td style="width:100px;">手机号码：</td>
                    <td style="width:150px;">    
                        ${user.phone}
                    </td>
                     <td style="width:100px;">公司名称：</td>
                    <td style="width:150px;">    
                       <input name="company_name" class="mini-textbox" value="${user.company_name!""}" allowInput="false"/>
                    </td>
                    
                    
                </tr>
                <tr>
                	<td style="width:100px;">联系人：</td>
                    <td style="width:150px;">    
                        <input name="name" class="mini-textbox" value="${user.name!""}"/>
                    </td>
                    <td style="width:100px;">座机号码：</td>
                    <td style="width:150px;">    
                       <input name="telcom" class="mini-textbox" value="${user.telcom!""}"/>
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">营业执照：</td>
                    <td style="width:150px;"    
                         <input id="licence_photo" name="licence_photo" class="mini-htmlfile"/>
                    </td>
                    </td>
                    <td style="width:100px;">地址：</td>
                    <td style="width:150px;" >    
                        <input name="address" class="mini-textbox" value="${user.address!""}"/>
                    </td>
                    </td>
                </tr>
                <tr>
            </table>
        </div>
        <div style="text-align:center;padding:10px;">               
            <a class="mini-button" onclick="onOk" style="width:60px;margin-right:20px;">确定</a>       
            <a class="mini-button" onclick="onCancel" style="width:60px;">取消</a>       
        </div>        
    </form>

</body>
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
</html>
