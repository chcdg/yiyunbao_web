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
		<div id="datagrid" class="mini-datagrid" style="width:100%;height:100%;" 
        url="/order/queryVie/${orderId}" allowResize="true" idField="id" multiSelect="true" allowAlternating="true" pageSize="10" > 
	        <div property="columns">
	            <div renderer="onRenderDriverInfo" field="driver_name" allowSort="true" width="80">
	            	司机
	            </div>
	            <div field="driver_bond"  allowSort="true" width="50">
	            	<font color="red">保证金</font>
	            </div>
	            <div field="driver_price"  allowSort="true" width="50">
	            	<font color="red">司机报价</font>
	            </div>
	            <div field="phone" width="80">
	            	司机电话
	            </div>
                <div field="car_phone" width="80">
                    随车电话
                </div>
                <div field="plate_number" width="80">
                    车牌号
                </div>
	            <div field="create_time" width="120" >
	            	抢单时间
	            </div>
	            <div field="status"  width="40">
	            	状态
	            </div>
                <div name="action" width="110" headerAlign="center" align="center" renderer="onActionRenderer" cellStyle="padding:0;">操作</div>
	        </div>
		</div> 
	</div>


<script>
    mini.parse();
    var grid = mini.get("datagrid");
    grid.load();
    
    function onRenderDriverInfo(e){
    	var grid = e.sender;
        var record = e.record;
        var uid = record._uid;
        var rowIndex = e.rowIndex;
        var driver_name = record.driver_name;
        var s = ' <a   href="javascript:show_vie_driver(\'' + uid + '\')">' + driver_name + '</a>';
        return s;
    }

    function onActionRenderer(e){
    	var grid = e.sender;
        var record = e.record;
        var uid = record._uid;
        var rowIndex = e.rowIndex;
        var s = ' <a   href="javascript:show_vie_driver(\'' + uid + '\')">查看详情</a>';
        s += ' <a   href="javascript:accept_order(\'' + uid + '\')">确认抢单</a>';
        return s;
    }
    
    grid.on("drawcell", function (e) {
        var record = e.record,
        column = e.column,
        field = e.field,
        value = e.value;
        //格式化状态
        if (field == "status") {
        	if(value == 0){
            	e.cellHtml = "已抢";
            }
            else if(value == 1){
            	e.cellHtml = "<font color='green'>中标</font>";
            }
            else if(value == 2){
            	e.cellHtml = "<font color='red'>退出</font>";
            }
            else{
            	e.cellHtml = "未知";
            }
        }
        if (field == "driver_bond") {
            e.cellHtml = "<font color='red'>" + value + "</font>";
        }
    });

    function accept_order(row_uid) {
        var row = grid.getRowByUID(row_uid);
        if (row) {
        	 mini.confirm("确定要由该司机承接货单吗？", "确认",
	            function (action, value) {
	                if (action == "ok") {
	                    $.ajax({
			                url: "/order/accept_order",
			                data: {order_id: ${orderId}, driver_id: row.driver_id},
			                cache: false,
                            dataType: 'json',
			                success: function (text) {
			                	if(text.success){
				                    mini.alert("已接受投标,订单交易成功.");
				                    CloseWindow("save");
			                	}
			                	else{
			                		mini.alert(text.data || "操作失败，请联系管理员");
			                	}
			                },
			                error: function (jqXHR, textStatus, errorThrown) {
			                    mini.alert(jqXHR.responseText);
			                    //CloseWindow();
			                }
			            });
			            
	                } 
	            }
	        );
        
        }
    }
    function show_vie_driver(row_uid){
        var row = grid.getRowByUID(row_uid);
        if (row) {
	        mini.open({
                url: "/order/show_vie_driver/" + row.driver_id + "-" + ${orderId},
                title: "司机详细信息",
                width: 800, 
                height: 560
            });
        }
    }
    function CloseWindow(action) {
        if (window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
        else window.close();            
    }
    
</script>
</body>
</html>