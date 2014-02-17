<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <script>
		var carStatus = [
    { "id": "0", "text": "空车" },
    { "id": "1", "text": "途中" },
    { "id": "2", "text": "已出发" },
    { "id": "3", "text": "已到达" },
    { "id": "4", "text": "故障" },
    { "id": "5", "text": "故障解除" },
	{ "id": "6", "text": "回程" }
	]
    </script>
    
 </head>
<body>
         <form id="form1" method="post">
        <input name="id" class="mini-hidden" value="${fleet.id}"/>
        <div style="padding-left:11px;padding-bottom:5px;">
            
        </div>
        <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:280px;" plain="false">
   		  <div title="基本信息" closable="false">
        	<table style="table-layout:fixed;">
                <tr>
                    <td style="width:100px;"> 随车手机：</td>
                    <td style="width:200px;">    
                        <input name="phone" class="mini-textbox" required="true" size=300	vtype="int" value="${fleet.phone!""}"/><font color="red">*</font>
                    </td>
                    <td style="width:100px;">车牌号码：</td>
                    <td style="width:200px;">      
                        <input name="cphm" class="mini-textbox" required="true"  value="${fleet.cphm!""}"/><font color="red">*</font>
                    </td>
                </tr>
              <tr>
                    <td style="width:100px;"> 司机姓名：</td>
                    <td style="width:200px;">    
                        <input name="driver_name" class="mini-textbox" required="true"  value="${fleet.driver_name!""}"/><font color="red">*</font>
                    </td>
                    <td style="width:100px;">期望流向：</td>
                    <td style="width:200px;">      
                        <input name="qwlx" class="mini-textbox" required="true" value="${fleet.qwlx!""}" /><font color="red">*</font>
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">车型：</td>
                    <td style="width:200px;">    
                    	<input id="car_type" name="car_type" class="mini-combobox" textField="name" 
                            valueField="id" emptyText="请选择货车车型" url="/dict/getAllCarType"  showNullItem="false" required="true" value="${fleet.car_type!""}"/><font color="red">*</font> 
                    </td>
                    <td style="width:100px;">吨位：</td>
                    <td style="width:200px;">      
                        <input name="car_weight"  class="mini-spinner" required="true" decimalPlaces="1" value="${fleet.car_weight!""}"/><font color="red">*</font>
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;"> 车长：</td>
                    <td style="width:200px;">    
                        <input name="car_length" class="mini-spinner" required="true"  decimalPlaces="1" value="${fleet.car_length!""}"/><font color="red">*</font>
                    </td>
                    <td style="width:100px;">容积：</td>
                    <td style="width:200px;">    
                        <input name="car_bulk"  class="mini-spinner" decimalPlaces="1" value="${fleet.car_bulk!""}"/>
                    </td>
                    
                </tr>
                 <tr>
                    <td style="width:100px;">车高：</td>
                    <td style="width:200px;">    
                        <input name="car_height"  class="mini-spinner"decimalPlaces="1" value="${fleet.car_height!""}"/>
                    </td>
                    <td style="width:100px;">车宽：</td>
                    <td style="width:200px;">      
                        <input name="car_width"  class="mini-spinner" decimalPlaces="1" value="${fleet.car_width!""}"/>
                    </td>
                
                <tr >
               	 <td >备注：</td>
                    <td colspan=3>      
                    	<textarea name="remark"  class="mini-textarea" style="width:430px;">${fleet.remark!""}</textarea>
                    </td>
                </tr>     
            </table>
    </div>
    <div title="车辆信息"  closable="false">
    	<table style="table-layout:fixed;">
      		  <tr>
                    <td style="width:100px;">发动机号码：</td>
                    <td style="width:200px;">    
                        <input name="fdjh" class="mini-textbox" value="${fleet.fdjh!""}"/>
                    </td>
                    <td style="width:100px;">车架号码：</td>
                    <td style="width:200px;">      
                        <input name="cjhm" class="mini-textbox" value="${fleet.cjhm!""}"/>
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">保险卡号：</td>
                    <td style="width:200px;">    
                        <input name="bxkh" class="mini-textbox" value="${fleet.bxkh!""}"/>
                    </td>
                    <td style="width:100px;">运营证书：</td>
                    <td style="width:200px;">      
                        <input name="yyzs" class="mini-textbox" value="${fleet.yyzs!""}"/>
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">挂靠单位：</td>
                    <td colspan=3>    
                        <input name="gkdw" class="mini-textbox" size=160 value="${fleet.gkdw!""}"/>
                    </td>
                </tr>
         </table>       
    </div>
    <div title="车主信息"  closable="false">
       <table style="table-layout:fixed;">
      		  <tr>
                    <td style="width:100px;">车主姓名：</td>
                    <td style="width:200px;">    
                        <input name="owner_name" class="mini-textbox" value="${fleet.owner_name!""}"/>
                    </td>
                    <td style="width:100px;">车主手机：</td>
                    <td style="width:200px;">      
                        <input name="owner_phone" class="mini-textbox" value="${fleet.owner_phone!""}"/>
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">身份证号：</td>
                    <td style="width:200px;">    
                        <input name="owner_id_card" class="mini-textbox" value="${fleet.owner_id_card!""}"/>
                    </td>
                    <td style="width:100px;">电话号码：</td>
                    <td style="width:200px;">      
                        <input name="owner_tel" class="mini-textbox" value="${fleet.owner_tel!""}"/>
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">其他电话：</td>
                    <td style="width:200px;">    
                        <input name="owner_tel2" class="mini-textbox" value="${fleet.owner_tel2!""}"/>
                    </td>
                    <td style="width:100px;">家庭住址：</td>
                    <td style="width:200px;">      
                        <input name="owner_address" class="mini-textbox" value="${fleet.owner_address!""}"/>
                    </td>
                </tr>
         </table>       
    </div>
    <div title="司机信息"  closable="false">
        <table style="table-layout:fixed;">
      		  <tr>
                    <td style="width:100px;">身份证号：</td>
                    <td style="width:200px;">    
                        <input name="driver_id_card" class="mini-textbox" value="${fleet.driver_id_card!""}"/>
                    </td>
                    <td style="width:100px;">驾驶执照：</td>
                    <td style="width:200px;">      
                        <input name="driver_jszz" class="mini-textbox" value="${fleet.driver_jszz!""}"/>
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">家庭电话：</td>
                    <td style="width:200px;">    
                        <input name="driver_tel" class="mini-textbox" value="${fleet.driver_tel!""}"/>
                    </td>
                    <td style="width:100px;">其他电话：</td>
                    <td style="width:200px;">      
                        <input name="driver_tel2" class="mini-textbox" value="${fleet.driver_tel2!""}"/>
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">家庭住址：</td>
                    <td style="width:200px;">    
                        <input name="driver_jszz" class="mini-textbox" value="${fleet.driver_jszz!""}"/>
                    </td>
                </tr>
         </table>       
    </div>
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

            var json = mini.encode([o]);
            $.ajax({
                url: "/fleet/update",
                data: { data: json },
                cache: false,
                success: function (text) {
                	var o = mini.decode(text);
                	if(!o.success){
                		mini.alert(o.data);
                	}else{
	                    CloseWindow("save");
                	}
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(jqXHR.responseText);
                    CloseWindow();
                }
            });
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
