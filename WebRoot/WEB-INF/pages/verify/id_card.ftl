<html>
 <head>
 	<link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
	<script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
 </head>
<body>
        <div class="mini-fit" >
			<div id="datagrid" class="mini-datagrid" style="width:100%;height:98%;" url="/verify/queryIdCardList" allowResize="true" idField="id" multiSelect="true" allowAlternating="true" pageSize="10" > 
		        <div property="columns">
		           <div field="id_name" width="100">
		            	姓名
		            </div>
		            <div field="id_card" width="100">
		            	身份证号码
		            </div>
		           <div field="photo" width="100">
		            	身份证图片
		            </div>
		             <div field="create_time" width="100">
		            	验证时间
		            </div>
		             <div field="status" width="100">
		            	验证结果
		            </div>
		             <div field="regioninfo" width="100">
		            	发证机关
		            </div>
		             <div field="birthday" width="100">
		            	生日
		            </div>
		             <div field="gender" width="100">
		            	性别
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
        if (field == "photo") {
        	if(value){
            	e.cellHtml = "<a href='" + value + "' target='_blank'><img width='50' height='50' src='" + value + "'/></a>";
            }
            else{
            	e.cellHtml = "无";
            }

        }
        if (field == "gender") {
        	if(value == 0){
            	e.cellHtml = "女";
            }
            else if(value == 1){
            	e.cellHtml = "男";
            }
            else{
            	e.cellHtml = "未知";
            }

        }
        if (field == "status") {
        	if(value=='1'){
            	e.cellHtml = "一致，有图";
            }
            else if(value=='2'){
            	e.cellHtml = "不一致";
            }
            else if(value=='3'){
            	e.cellHtml = "无此号码";
            }
            else if(value=='4'){
            	e.cellHtml = "一致";
            }

        }
    });
    

</script>
</html>
