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
        <table style="width:100%;" border="0">
            <tr>
                <td align="right">
                    <input id="start" name="start" class="mini-datepicker" emptyText="请输入开始日期"  format="yyyy-MM-dd" style="width:110px"/>
                    <input id="end" name="end" class="mini-datepicker" emptyText="请输入结束日期" format="yyyy-MM-dd" style="width:110px"/>
                    <input id="status" class="mini-combobox" style="width:110px;" textField="text" valueField="id" emptyText="请输入货单状态" data="[{id:-1, text:'全部'},{id:99, text:'已完成'},{id:98, text:'已过期'},{id:4, text:'已取消'},{id:2, text:'审核未通过'}]" showNullItem="false" value="-1"/>
                    <input id="cargo_desc" class="mini-textbox" emptyText="货物描述" style="width:150px;" onenter="search"/>
                    <input id="plate_number" class="mini-textbox" emptyText="车牌号" style="width:150px;" onenter="search"/>
                    <a class="mini-button" onclick="search()" plain="true" iconCls="icon-search">查询</a>
                    </td>
              </tr>
        </table>
    </div>
    <div class="mini-fit">
        <div id="datagrid" class="mini-datagrid" style="width:100%;height:100%;"  url="/order/queryHistoryList" allowResize="true" idField="id" multiSelect="true" allowAlternating="true" showPager="true" pageSize="20">
            <div property="columns">
                <div name="action" width="90" headerAlign="center" align="center" renderer="onActionRenderer" cellStyle="padding:0;">操作</div>
                <div renderer="onRenderTrace" width="150"  align="center" headerAlign="center">
                    路线
                </div>
                <div field="cargo_desc"  align="center" headerAlign="center">
                    货物描述
                </div>
                <div field="price"  width="70"  align="center" headerAlign="center">
                    价格
                </div>
                <div field="create_time"  width="110"  align="center" headerAlign="center">
                    发布时间
                </div>
                <div field="driver_name"   align="center" headerAlign="center">
                    中标司机
                </div>
                <div field="finish_time"  width="110"  align="center" headerAlign="center">
                    成交时间
                </div>
                <div field="status"  width="80"  align="center" headerAlign="center">
                    状态
                </div>
                <div renderer="onRenderReply"  align="center" headerAlign="center">
                    评价情况
                </div>
            </div>
        </div>
    </div>
</body>

</html>
<script>
    mini_debugger = false;
    mini.parse();
    var grid = mini.get("datagrid");
    grid.frozenColumns(0, 0);
    grid.load();
    
    function onActionRenderer(e){
     var grid = e.sender;
        var record = e.record;
        var uid = record._uid;
        var rowIndex = e.rowIndex;
        var s = ' <a   href="javascript:showHistoryOrderDetail(\'' + uid + '\')">详情</a>';
        if(record.driver_reply == 0 && record.status == 99){
        	s += ' <a   href="javascript:rating(\'' + uid + '\')">评价</a>';
        }
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

    function onRenderReply(e){
        var grid = e.sender;
        var record = e.record;
        var uid = record._uid;
        var rowIndex = e.rowIndex;
        var str = "";
        if(record.user_reply == 1 && record.driver_reply == 1){
            str = "双方已评";
        }else if(record.user_reply == 1){
            str = "司机已评";
        }else if(record.driver_reply == 1){
            str = "已评价";
        }
        return str;
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
                e.cellHtml = "在途";
            }
            else if(value == 4){
                e.cellHtml = "已取消";
            }
            else if(value == 99){
                e.cellHtml = "已完成";
            }
            else if(value == 98){
                e.cellHtml = "已过期";
            }
            else{
                e.cellHtml = "未知:" + value;
            }
        }
        if(field == "price"){
        	e.cellHtml = value + "元";
        }
    });

    function search() {
    	var status = mini.get("status").getValue();
    	var cargo_desc = mini.get("cargo_desc").getValue();
        grid.load({ status: status,cargo_desc:cargo_desc });
    }
    
    //详情
    function showHistoryOrderDetail(row_uid) {
        var row = grid.getRowByUID(row_uid);
        if (row) {
             mini.open({
                url: "/order/showHistoryOrderDetail/" + row.id,
                title: "货单详情", 
                width: 800, 
                height: 360,
                ondestroy: function (action) {  //弹出页面关闭前
			        grid.load();
			    }
            });
        }
    }
    
    //评价司机
    function rating(row_uid) {
        var row = grid.getRowByUID(row_uid);
        if (row) {
             mini.open({
                url: "/order/rating_to_driver/" + row.id,
                title: "评价司机", 
                width: 800, 
                height: 560,
                ondestroy: function (action) {  //弹出页面关闭前
                    grid.load();
                }
            });
        }
    }

        
</script>