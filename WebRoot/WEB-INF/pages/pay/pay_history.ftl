<html>
 <head>
 	<link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
	<script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
 </head>
<body>
        <div class="mini-toolbar" style="border-bottom:0;padding:0px;">
        </div>
        <div class="mini-fit" >
			<div id="datagrid" class="mini-datagrid" style="width:100%;height:98%;" url="/pay/payHistory" allowResize="true" idField="id" multiSelect="true" allowAlternating="true" pageSize="10" > 
		        <div property="columns">
		            <div field="pay_money" width="100">
		            	充值金额
		            </div>
		           <div field="pay_platform" width="100">
		            	充值方式
		            </div>
		           <div field="status" width="100">
		            	充值状态
		            </div>
		             <div field="create_time" width="200">
		            	下单时间
		            </div>
		             <div field="finish_time" width="200">
		            	充值完成时间
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
        //格式化状态
        if (field == "pay_platform") {
        	if(value == 1){
            	e.cellHtml = "易宝";
            }
            else{
            	e.cellHtml = "支付宝";
            }
        }
        
        if (field == "status") {
        	if(value == 0){
            	e.cellHtml = "待付款";
            }
            else if(value == 99){
            	e.cellHtml = "充值成功";
            }
            else{
            	e.cellHtml = "未知";
            }
        }
    });
    
</script>
</html>
