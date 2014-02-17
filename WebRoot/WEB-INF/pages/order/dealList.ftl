<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
 </head>
<body style="background:url(images/bg2.png) ; ">

<div class="mini-toolbar" style="border-bottom:0;padding:0px;">
    <table style="width:100%;">
        <tr>
            <td>
            	 <a class="mini-button" onclick="map()" plain="true" iconCls="icon-filter">查看地图</a>
            </td>
            <td style="white-space:nowrap;">
                <input id="cargo_desc" class="mini-textbox" empty	Text="货物名称" style="width:150px;" onenter="search"/>
                <input id="plate_number" class="mini-textbox" emptyText="车牌号" style="width:150px;" onenter="search"/>
                <a class="mini-button" onclick="search()" plain="true" iconCls="icon-search">查询</a>
               
            </td>
        </tr>
    </table>
</div>
<div class="mini-fit">
	<div id="datagrid" class="mini-datagrid" style="width:100%;height:100%;"  url="/order/queryDealList?status=3" allowResize="true" idField="id" multiSelect="true" allowAlternating="true" showPager="false" onpreload="onpreload"> 
        <div property="columns">
            <div name="action" width="" headerAlign="center" align="center" renderer="onActionRenderer" cellStyle="padding:0;">操作</div>
            <div field="id" allowSort="true" width="40"  visible="false">
            	编号
            </div>
             <div renderer="onRenderTrace" width="100">
            	路线
            </div>
             <div field="cargo_desc">
            	货物名称
            </div>
             <div field="cargo_number" width="80">
            	货物数量
            </div>
             <div field="plate_number" width="80">
            	车牌号
            </div>
            <div field="loading_time"  allowSort="true">
            	装车时间
            </div>
        </div>
	</div>
</div>

    <script src="../js/boot.js"></script>
<script>
    mini_debugger = false;
    function onpreload(p){
        //console.debug(p)
    }

    
    function onActionRenderer(e){
        var grid = e.sender;
        var record = e.record;
        var uid = record._uid;
        var rowIndex = e.rowIndex;
        var s = "";
        s += ' <a   href="javascript:showDealOrder(\'' + uid + '\')">详情</a>';
        s += ' <a   href="javascript:trajectory(\'' + uid + '\')">轨迹</a>';
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
    
    mini.parse();
    var grid = mini.get("datagrid");
   // grid.frozenColumns(0, 2);
    grid.load();
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
    });


    
    //查看订单
    function showDealOrder(row_uid) {
        var row = grid.getRowByUID(row_uid);
        if (row) {
             mini.open({
                url: "/order/showDealOrder/" + row.id,
                title: "订单详情", 
                width: 800, 
                height: 700
            });
        }
    }
    
    //查看轨迹
    function trajectory(row_uid) {
        var row = grid.getRowByUID(row_uid);
        if (row) {
             mini.open({
                url: "/order/trajectory?id=" + row.id,
                title: "订单轨迹", 
                width: 800, 
                height: 700
            });
        }
    }

    function search() {
        var cargo_desc = mini.get("cargo_desc").getValue();
        var plate_number = mini.get("plate_number").getValue();
        grid.load({cargo_desc:cargo_desc,plate_number:plate_number});
    }
    
    //查看地图
    function map(){
             mini.open({
                url: "/order/showMap",
                title: "地图", 
                width: 850, 
                height: 650
            });
    }
                 
    //定位 
    function showLocation(row_uid) {
            var row = grid.getRowByUID(row_uid);
            initAllMarker(row.longitude,row.latitude , row.driver_name);
        }
</script>
</body>
</html>