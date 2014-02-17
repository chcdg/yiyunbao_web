<html>
 <head>
    <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jquery-1.6.2.min.js"></script></p> 
 </head>
<body>
        <div class="mini-fit" >
		<div id="datagrid" class="mini-datagrid" style="width:100%;height:100%;" 
        url="/driverReply/query/${driver_id}" allowResize="true" idField="id" multiSelect="true" allowAlternating="true" pageSize="10" showEmptyText="true" emptyText="暂无评价"> 
        <div property="columns">
            <div field="score1" >
            	履约诚信度
            </div>            
            <div field="score2" >
            	运输准时率
            </div>
            <div field="score3" >
            	服务态度
            </div>
            <div field="reply_content" >
            	评价内容
            </div>
            <div field="reply_time" >
            	评价时间
            </div>
            <div field="name" >
            	评价人
            </div>
        </div>
		</div> 
	</div>

</body>
<script>
    mini.parse();
    var grid = mini.get("datagrid");
    grid.load();
     grid.on("drawcell", function (e) {
        var record = e.record,
        column = e.column,
        field = e.field,
        value = e.value;
        //格式化状态
        if (field == "score1") {
        	e.cellHtml = "<font color='red'>" + value + "</font> 分";
        }
        if (field == "score2") {
        	e.cellHtml = "<font color='red'>" + value + "</font> 分";
        }
        if (field == "score3") {
        	e.cellHtml = "<font color='red'>" + value + "</font> 分";
        }
    });
    
</script>
</html>
