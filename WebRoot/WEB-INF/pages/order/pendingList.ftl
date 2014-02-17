<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <style type="text/css">
    	label{
			font-family: Tahoma, Verdana, 宋体;
			font-size: 12px;
			line-height: 22px;
		}
    </style>
 </head>
<body style="background:url(/images/bg2.png) ; ">

    <div class="mini-toolbar" style="border-bottom:0;padding:0px;">
        <table style="width:100%;">
            <tr>
                <td>
                </td>
                <td style="white-space:nowrap;">
                    <!--<input id="status" class="mini-combobox" style="width:150px;" textField="text" valueField="id" emptyText="请选择货单状态" data="[{id:1, text:'审核通过'},{id:0, text:'审核中'}]" showNullItem="false" value="1" />--> 
                    <input id="cargo_desc" class="mini-textbox" emptyText="货物描述" style="width:150px;" onenter="search"/>
                    <a class="mini-button" onclick="search()" plain="true" iconCls="icon-search">查询</a>
                </td>
            </tr>
        </table>
    </div>
        <div id="datagrid" class="mini-datagrid" style="width:100%;height:600px;"  url="/order/queryPendingList" allowResize="true" idField="id" multiSelect="true" allowAlternating="true" showPager="false">
            <div property="columns">
                <div name="action" width="170" headerAlign="center" align="center" renderer="onActionRenderer" cellStyle="padding:0;">操作</div>
                <div field="id" allowSort="true" width="40" visible="false">
                    编号
                </div>
                <div renderer="onRenderTrace" width="80">
                    路线
                </div>
                <div field="cargo_desc" renderer="onRenderCargoDesc" >
                    货物描述
                </div>
                <div field="price"  allowSort="true" width="70">
                    价格
                </div>
                <div field="push_drvier_count"  allowSort="true" width="40">
                    已推送
                </div>
                <div field="vie_driver_count"  allowSort="true" width="40">
                    已投标
                </div>
                <div field="create_time"  allowSort="true">
                    发布时间
                </div>
                <div renderer="onRenderValiateTime" field="validate_time"  allowSort="true">
                    订单有效期
                </div>
                <div field="loading_time"  allowSort="true">
                    预期装货时间
                </div>
            </div>
    </div>
</body>

</html>
<script>
    mini_debugger = false;
    mini.parse();
    var grid = mini.get("datagrid");
    grid.frozenColumns(0, 2);
    grid.load();
    
    function onActionRenderer(e){
     var grid = e.sender;
        var record = e.record;
        var uid = record._uid;
        var rowIndex = e.rowIndex;
        var s = ' <a href="javascript:;" onclick="showVie(\'' + uid + '\');return false;">查看抢单</a>'
        		+ ' <a href="javascript:;" onclick="cancelOrder(\'' + uid + '\');return false;">取消货单</a>' 
        		+ ' <a href="javascript:;" onclick="showPendingOrderDetail(\'' + uid + '\');return false;">详情</a>';
        return s;
    }
    
    function onRenderTrace(e){
        var grid = e.sender;
        var record = e.record;
        var uid = record._uid;
        var rowIndex = e.rowIndex;
        var start_province_name = record.start_province_name || "";
        var start_city_name = record.start_city_name || "";
        var start_district_name = record.start_district_name || "";
        var end_province_name = record.end_province_name || "";
        var end_city_name = record.end_city_name || "";
        var end_district_name = record.end_district_name || "";
        var s = start_province_name + start_city_name  + start_district_name  + "-" + end_province_name + end_city_name + end_district_name;
        return s;
    }

    function onRenderCargoDesc(e){
        var grid = e.sender;
        var record = e.record;
        var uid = record._uid;
        var rowIndex = e.rowIndex;
        var str = record.cargo_desc + "/<b>" + record.cargo_number + "</b>";
        if(record.cargo_unit == 1){
            str += "车";
        }else if(record.cargo_unit == 2){
            str += "吨";
        }else if(record.cargo_unit == 3){
            str += "方";
        }
        return str;
    }
    
    function onRenderValiateTime(e){
        var grid = e.sender;
        var record = e.record;
        var uid = record._uid;
        var rowIndex = e.rowIndex;
        var validate_time = record.validate_time;
        var is_expired = record.is_expired;
        if(is_expired == 1){
        	validate_time = '<span style="color:red;">' + validate_time + "</span>(已过期)"
        }
        return validate_time;
    }
    
    grid.on("rowclick" , function(e){
    	var grid = e.sender;
        var record = e.record;
        var uid = record._uid;
        //showLocation(uid);
    });
    grid.on("drawcell", function (e) {
        var record = e.record,
        column = e.column,
        field = e.field,
        value = e.value;
        //格式化状态
        if (field == "status") {
        	if(value == 0){
            	e.cellHtml = "已创建";
            }
            else if(value == 1){
            	e.cellHtml = "审核通过";
            }
            else if(value == 2){
            	e.cellHtml = "审核未通过";
            }
            else if(value == 3){
            	e.cellHtml = "已中标";
            }
            else if(value == 4){
            	e.cellHtml = "已取消";
            }
            else if(value == 4){
            	e.cellHtml = "已完成";
            }
            else{
            	e.cellHtml = "未知";
            }
        }
        if(field == "price"){
        	e.cellHtml = value + "(元)";
        }
    });

    function search() {
    	var cargo_desc = mini.get("cargo_desc").getValue();
        grid.load({ cargo_desc:cargo_desc });
    }
    
    //查看抢单
    function showVie(row_uid) {
        var row = grid.getRowByUID(row_uid);
        if (row) {
	         mini.open({
                url: "/order/vieList/" + row.id,
                title: "查看抢单情况", 
                width: 800, 
                height: 400,
                ondestroy: function (action) {  //弹出页面关闭前
			        //grid.load();
                    search();
			    }
            });
        }
        return false;
    }

    //取消订单
    function cancelOrder(row_uid){
        var row = grid.getRowByUID(row_uid);
        if (row) {
            var vie_driver_count = row.vie_driver_count;
            var user_bond = row.user_bond;
            if(vie_driver_count == 0){
                 mini.confirm("要取消货单吗","温馨提示", function(action){
                        if (action == "ok"){
                            doCancelOrder(row.id);
                        }
                    });
            }else{
                if(user_bond <= 0){
                    mini.alert("取消订单将严重影响你的信誉。若有特殊情况，请联系客服取消。","温馨提示");
                    return;
                }else{
                    mini.confirm("取消订单将严重影响你的信誉，同时保证金" + user_bond + "元将赔付给" + vie_driver_count +"位抢单司机。","温馨提示", function(action){
                        if (action == "ok"){
                            doCancelOrder(row.id);
                        }
                    });
                }
            }
        }
        return false;
    }
    function doCancelOrder(orderId){
        $.ajax({
            url: "/order/cancel_order",
            data: {order_id: orderId},
            cache: false,
            dataType: 'json',
            success: function (json) {
                if(json.success){
                    mini.alert("订单已取消.");
                    search();
                }else{
                    mini.alert(json.message || "取消失败.");
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                mini.alert(jqXHR.responseText);
            }
        });
    }
    
    //查看详情并调整价格
    function showPendingOrderDetail(row_uid) {
        var row = grid.getRowByUID(row_uid);
        if (row) {
             mini.open({
                url: "/order/showPendingOrderDetail/" + row.id,
                title: "待定货单详情", 
                width: 690, 
                height: 560,
                ondestroy: function (action) {  //弹出页面关闭前
			        //grid.load();
                    search();           
			    }
            });
        }
        return false;
    }



    //定位
    function showLocation(row_uid) {
            var row = grid.getRowByUID(row_uid);
            initAllMarker(row.longitude,row.latitude , row.driver_name);
        }
        
</script>