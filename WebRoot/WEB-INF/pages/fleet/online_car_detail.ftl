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
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
 </head>
<body>
        <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:300px;" plain="false">
   		  <div title="基本信息" closable="false" style="margin-left:200px;">
        	<table  border="0" cellPadding="5">
                <tr>
                    <th> 随车手机：</th>
                    <td >${driver.phone}</td>
                    <th>车牌号码：</th>
                    <td >${driver.plate_number!""}</td>
                </tr>
              <tr>
                    <th> 司机姓名：</th>
                    <td >${driver.name}</td>
                    <th>当前位置：</th>
                    <td>${driver.last_position!""}</td>
                </tr>
                <tr>
                    <th>车型：</th>
                    <td>${driver.type_name!""}</td>
                    <th>吨位：</th>
                    <td>${driver.car_weight!""}吨</td>
                </tr>
                <tr>
                    <th> 车长：</th>
                    <td>${driver.car_length!""}米</td>
                    <th>主营路线：</th>
                    <td>
                    	${driver.start_province_name!""}
                    	${driver.start_city_name!""}
                    	-
                    	${driver.end_province_name!""}
                    	${driver.end_city_name!""}
                    </td>
                </tr>
                 <tr>
                    <th>其他线路1：</th>
                    <td>
	                    ${driver.start_province2_name!""}
	                	${driver.start_city2_name!""}
	                	-
	                	${driver.end_province2_name!""}
	                	${driver.end_city2_name!""}
                    </td>
                    <th>其他线路2：</th>
                    <td>
	                    ${driver.start_province3_name!""}
	                	${driver.start_city3_name!""}
	                	-
	                	${driver.end_province3_name!""}
	                	${driver.end_city3_name!""}
                    </td>
                   </tr>
                   <tr>
	                <td colspan=4 align="right">
	        		</td>
                </tr>
            </table>
            <span style="margin-left:140px;margin-top:30px;">如需查看司机更多信息或操作，请在<b style="color:red">我的车队</b>中操作</span>
            <a style="margin-left:240px;margin-top:10px;" class="mini-button" iconCls="icon-add" onclick="add_my_tream()">添加到我的车队</a>
            </div>
</div>   
</body>

</html>
<script>
    mini.parse();
    
    function SaveData() {
        var o = form.getData();            

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

	function delRow() {
    	 mini.confirm("确定删除记录？", "确定？",
            function (action) {            
                if (action == "ok") {
                    $.ajax({
                        url: "/fleet/delete",
                        success: function (text) {
                           CloseWindow('OK');
                        },
                        error: function () {
                        	mini.alert("删除失败，请稍后再试");
                        	CloseWindow('OK');
                        }
                    });
                } 
            }
        );
	        
    }
        
    function edit(){
        mini.open({
            url: "/fleet/edit",
            title: "修改信息", 
            width: 700, 
            height: 400,
            ondestroy: function (action) {
                window.location.reload();
                
            }
        });
     }
    
    function add_my_tream(){
    	var row_ids = "";
 	   var reg=/,$/;//表达式，去掉最后字符串最后一个逗号
 	   row_ids = row_ids+${driver.id};
 	   mini.confirm("确定添加到车队吗？", "提醒",
		            function (action) {            
		                if (action == "ok") {
//		                     grid.loading("处理中，请稍候......");
		                    $.ajax({
		                        url: "/fleet/addTOMyCars/" + row_ids,
		                        success: function (text) {
		                    		mini.alert(text);
//		                    		CloseWindow("OK");
		                    },
		                        error: function () {
		                        	mini.alert("添加失败，请检查后再试！");
//		                        	grid.unmask();
//		                        	CloseWindow("OK");
		                        }
		                    });
		                }
		            }
		     );
 	   }
     
     function CloseWindow(action) {
        if (window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
        else window.close();            
    } 
</script>
