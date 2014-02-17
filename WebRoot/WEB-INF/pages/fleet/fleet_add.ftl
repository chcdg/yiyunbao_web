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
        <input name="id" class="mini-hidden" />
        <div style="padding-left:11px;padding-bottom:5px;">
            
        </div>
        <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:330px;" plain="false">
   		  <div title="基本信息" closable="false" >
        	<table style="table-layout:fixed;" border="0">
                <tr>
                    <td style="width:100px;"> 随车手机：</td>
                    <td style="width:200px;">    
                        <input name="phone" class="mini-textbox" required="true" size=300	vtype="int" /><font color="red">*</font>
                    </td>
                    <td style="width:100px;">车牌号码：</td>
                    <td style="width:200px;">      
                        <input name="cphm" class="mini-textbox" required="true"  /><font color="red">*</font>
                    </td>
                </tr>
              <tr>
                    <td style="width:100px;"> 司机姓名：</td>
                    <td style="width:200px;">    
                        <input name="driver_name" class="mini-textbox" required="true"  /><font color="red">*</font>
                    </td>
                    <td style="width:100px;">身份证号：</td>
                    <td style="width:200px;">    
                        <input name="id_card" class="mini-textbox"/>
                    </td>
                </tr>
                <tr>
	                <td style="width:100px;">线路1：</td>
	                <td style="width:200px;" colspan="3">    
		                <input id="start_province" name="start_province" class="mini-combobox" textField="name" onvaluechanged="onStartProvinceChanged"
	                    	valueField="id" emptyText="省/直辖市" url="/dict/getProvinceList" showNullItem="false" style="width:100px" required="true"/> 
		                <input id="start_city" name="start_city" class="mini-combobox"  emptyText="地市" textField="name"  valueField="id" style="width:100px" required="true"/>
		                                     至
		                <input id="end_province" name="end_province" class="mini-combobox" textField="name" onvaluechanged="onEndProvinceChanged"
	                		valueField="id" emptyText="省/直辖市" url="/dict/getProvinceList" showNullItem="false" style="width:100px" required="true"/> 
		                <input id="end_city" name="end_city" class="mini-combobox"  emptyText="地市" textField="name"  valueField="id" style="width:100px" required="true"/><font color="red">*</font>
	                </td>
                </tr>
                <tr>
	                <td style="width:100px;">线路2：</td>
	                <td style="width:200px;" colspan="3">    
	                <input id="start_province2" name="start_province2" class="mini-combobox" textField="name" onvaluechanged="onStartProvinceChanged2"
                		valueField="id" emptyText="省/直辖市" url="/dict/getProvinceList" showNullItem="false" style="width:100px"/> 
	                <input id="start_city2" name="start_city2" class="mini-combobox"  emptyText="地市" textField="name"  valueField="id" style="width:100px"/>
                                              至
                   <input id="end_province2" name="end_province2" class="mini-combobox" textField="name" onvaluechanged="onEndProvinceChanged2"
                   	valueField="id" emptyText="省/直辖市" url="/dict/getProvinceList" showNullItem="false" style="width:100px"/> 
                      <input id="end_city2" name="end_city2" class="mini-combobox"  emptyText="地市" textField="name"  valueField="id" style="width:100px"/>
	               </td>
                </tr>
                <tr>
	                <td style="width:100px;">线路3：</td>
	                <td style="width:200px;" colspan="3">    
	                <input id="start_province3" name="start_province3" class="mini-combobox" textField="name" onvaluechanged="onStartProvinceChanged3"
                		valueField="id" emptyText="省/直辖市" url="/dict/getProvinceList" showNullItem="false" style="width:100px" /> 
	                <input id="start_city3" name="start_city3" class="mini-combobox"  emptyText="地市" textField="name"  valueField="id" style="width:100px"/>
                                               至
                    <input id="end_province3" name="end_province3" class="mini-combobox" textField="name" onvaluechanged="onEndProvinceChanged3"
            			valueField="id" emptyText="省/直辖市" url="/dict/getProvinceList" showNullItem="false" style="width:100px"/> 
                    <input id="end_city3" name="end_city3" class="mini-combobox"  emptyText="地市" textField="name"  valueField="id" style="width:100px"/>
	               </td>
                </tr>                
                <tr>
                    <td style="width:100px;">车型：</td>
                    <td style="width:200px;">    
                    	<input id="car_type" name="car_type" class="mini-combobox" textField="name" 
                            valueField="id" emptyText="请选择货车车型" url="/dict/getAllCarType"  showNullItem="false" required="true"/><font color="red">*</font> 
                    </td>
                    <td style="width:100px;"> 车长：</td>
                    <td style="width:200px;">    
                        <input name="car_length" class="mini-spinner" required="true"  decimalPlaces="1"/><font color="red">*</font>
                    </td>
                </tr>
                <tr>
	                <td style="width:100px;">吨位：</td>
	                <td style="width:200px;">      
	                    <input name="car_weight"  class="mini-spinner" decimalPlaces="1" />
	                </td>
                    <td style="width:100px;">容积：</td>
                    <td style="width:200px;">    
                        <input name="car_bulk"  class="mini-spinner" decimalPlaces="1" />
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">车高：</td>
                    <td style="width:200px;">    
                        <input name="car_height"  class="mini-spinner"decimalPlaces="1" />
                    </td>
                    <td style="width:100px;">车宽：</td>
                    <td style="width:200px;">      
                        <input name="car_width"  class="mini-spinner" decimalPlaces="1" />
                    </td>
                </tr>
               	 <td >备注：</td>
                    <td colspan=3>      
                    	<textarea name="remark"  class="mini-textarea" style="width:430px;"></textarea>
                    </td>
                </tr>     
            </table>
    </div>
    <div title="车辆信息"  closable="false">
    	<table style="table-layout:fixed;">
      		  <tr>
                    <td style="width:100px;">发动机号码：</td>
                    <td style="width:200px;">    
                        <input name="fdjh" class="mini-textbox" />
                    </td>
                    <td style="width:100px;">车架号码：</td>
                    <td style="width:200px;">      
                        <input name="cjhm" class="mini-textbox" />
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">保险卡号：</td>
                    <td style="width:200px;">    
                        <input name="bxkh" class="mini-textbox" />
                    </td>
                    <td style="width:100px;">运营证书：</td>
                    <td style="width:200px;">      
                        <input name="yyzs" class="mini-textbox" />
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">挂靠单位：</td>
                    <td colspan=3>    
                        <input name="gkdw" class="mini-textbox" size=160/>
                    </td>
                </tr>
         </table>       
    </div>
    <div title="车主信息"  closable="false">
       <table style="table-layout:fixed;">
      		  <tr>
                    <td style="width:100px;">车主姓名：</td>
                    <td style="width:200px;">    
                        <input name="owner_name" class="mini-textbox" />
                    </td>
                    <td style="width:100px;">身份证号：</td>
                    <td style="width:200px;">    
                        <input name="owner_id_card" class="mini-textbox" />
                    </td>
                </tr>
                 <tr>
	                 <td style="width:100px;">车主手机：</td>
	                 <td style="width:200px;">      
	                     <input name="owner_phone" class="mini-textbox" />
	                 </td>
                    <td style="width:100px;">电话号码：</td>
                    <td style="width:200px;">      
                        <input name="owner_tel" class="mini-textbox" />
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">其他电话：</td>
                    <td style="width:200px;">    
                        <input name="owner_tel2" class="mini-textbox" />
                    </td>
                    <td style="width:100px;">家庭住址：</td>
                    <td style="width:200px;">      
                        <input name="owner_address" class="mini-textbox" />
                    </td>
                </tr>
         </table>       
    </div>
    <div title="司机信息"  closable="false">
        <table style="table-layout:fixed;">
      		  <tr>
		      		<td style="width:100px;">家庭住址：</td>
		            <td style="width:200px;">    
		                <input name="driver_address" class="mini-textbox" />
		            </td>
                    <td style="width:100px;">驾驶执照：</td>
                    <td style="width:200px;">      
                        <input name="driver_jszz" class="mini-textbox" />
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">家庭电话：</td>
                    <td style="width:200px;">    
                        <input name="driver_tel" class="mini-textbox" />
                    </td>
                    <td style="width:100px;">其他电话：</td>
                    <td style="width:200px;">      
                        <input name="driver_tel2" class="mini-textbox" />
                    </td>
                </tr>
         </table>       
    </div>
</div>   
<div style="text-align:center;padding:10px;">               
            <a class="mini-button" iconCls="icon-ok" onclick="onOk" style="margin-right:20px;">添加</a>       
            <a class="mini-button" iconCls="icon-cancel" onclick="onCancel">取消</a>       
        </div>  
    </form>

</body>
<script>
    mini.parse();
    var form = new mini.Form("form1");

        function SaveData() {
            var o = form.getData();         
            
            if(o.start_province2 == ""){
            	o.start_province2 = 0;
            }
            if(o.start_city2 == ""){
            	o.start_city2 = 0;
            }
            if(o.end_province2 == ""){
            	o.end_province2 = 0;
            }
            if(o.end_city2 == ""){
            	o.end_city2 = 0;
            }
            if(o.start_province3 == ""){
            	o.start_province3 = 0;
            }
            if(o.start_city3 == ""){
            	o.start_city3 = 0;
            }
            if(o.end_province3 == ""){
            	o.end_province3 = 0;
            }
            if(o.end_city3 == ""){
            	o.end_city3 = 0;
            }
            
            form.validate();
            if (form.isValid() == false) return;

            var json = mini.encode([o]);

            $.ajax({
                url: "/fleet/save",
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
        
        var start_province = mini.get("start_province");
        var start_city = mini.get("start_city");
        function onStartProvinceChanged(e) {
            var id = start_province.getValue();
            start_city.setValue("");
            var url = "/dict/getArea?id=" + id
            start_city.setUrl(url);
            start_city.select(0);
        }
        
    	var end_province = mini.get("end_province");
        var end_city = mini.get("end_city");
        function onEndProvinceChanged(e) {
            var id = end_province.getValue();
            end_city.setValue("");
            var url = "/dict/getArea?id=" + id
            end_city.setUrl(url);
            end_city.select(0);
        }
        
    	var start_province2 = mini.get("start_province2");
        var start_city2 = mini.get("start_city2");
        function onStartProvinceChanged2(e) {
            var id = start_province2.getValue();
            start_city2.setValue("");
            var url = "/dict/getArea?id=" + id
            start_city2.setUrl(url);
            start_city2.select(0);
        }
        
    	var end_province2 = mini.get("end_province2");
        var end_city2 = mini.get("end_city2");
        function onEndProvinceChanged2(e) {
            var id = end_province2.getValue();
            end_city2.setValue("");
            var url = "/dict/getArea?id=" + id
            end_city2.setUrl(url);
            end_city2.select(0);
        }
        
    	var start_province3 = mini.get("start_province3");
        var start_city3 = mini.get("start_city3");
        function onStartProvinceChanged3(e) {
            var id = start_province3.getValue();
            start_city3.setValue("");
            var url = "/dict/getArea?id=" + id
            start_city3.setUrl(url);
            start_city3.select(0);
        }
        
    	var end_province3 = mini.get("end_province3");
        var end_city3 = mini.get("end_city3");
        function onEndProvinceChanged3(e) {
            var id = end_province3.getValue();
            end_city3.setValue("");
            var url = "/dict/getArea?id=" + id
            end_city3.setUrl(url);
            end_city3.select(0);
        }

</script>
</html>
