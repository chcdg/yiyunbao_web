<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
 	<link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
	<script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
 </head>
<body>
    <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:650px;" plain="false">
        <div name="first" title="系统消息" style="width:500px;">
            <div class="mini-fit" >
			<div id="datagrid" class="mini-datagrid" style="width:100%;height:100%;" url="/msg/list" allowResize="true" idField="id" multiSelect="true" allowAlternating="true" pageSize="20" > 
		        <div property="columns">
		           <div field="msg_title" width="100">
		            	标题
		            </div>
		           <div field="msg_content" width="100">
		            	内容
		            </div>
		            <div field="msg_time" width="100">
		            	时间
		            </div>
				</div> 
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
        //格式化
        if (field == "msg_title") {
        	e.cellHtml = "<a href='javascript:showDetail(" + record._uid + ")'>" + value + "</a>";

        }
    });
    
    function showDetail(uid){
   	 var row = grid.getRowByUID(uid);
    	$.jBox.info(row.msg_content , row.msg_title);
    }
</script>
</html>