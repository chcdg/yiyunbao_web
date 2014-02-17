<html>
 <head>
 	<link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
	<script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
 </head>
<body>
        <div class="mini-fit" >
			<div id="datagrid" class="mini-datagrid" style="width:100%;height:98%;" url="/account/getBusiness" allowResize="true" idField="id" multiSelect="true" allowAlternating="true" pageSize="10" > 
		        <div property="columns">
		        	<div type="checkcolumn" field="rowid" name="checkid"></div> 
		            <div field="business_type" width="100">
		            	交易类型
		            </div>
		           <div field="business_amount" width="100">
		            	交易金额
		            </div>
                   <#-- <div field="before_balance" width="100">
                        交易前余额
                    </div>
                   <div field="after_balance" width="100">
                        余额
                    </div> -->
		             <div field="create_time" width="100">
		            	交易时间
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
        if (field == "business_type") {
        	if(value == 0){
            	e.cellHtml = "<font color='red'>充值</font>";
            }
            else if(value == 2){
            	e.cellHtml = "<font color='green'>违约扣除</font>";
            }
            else if(value == 3){
            	e.cellHtml = "<font color='green'>成功交易扣除</font>";
            }
            else if(value == 4){
            	e.cellHtml = "<font color='green'>验证身份扣除</font>";
            }
            else if(value == 5){
            	e.cellHtml = "<font color='green'>冻结</font>";
            }
            else if(value == 6){
            	e.cellHtml = "<font color='green'>保证金扣除</font>";
            }
            else if(value == 7){
            	e.cellHtml = "<font color='green'>短信扣除</font>";
            }
            else if(value == 8){
            	e.cellHtml = "<font color='red'>保证金返还</font>";
            }
            else if(value == 9){
            	e.cellHtml = "<font color='red'>对方违约返还</font>";
            }
            else if(value == 10){
            	e.cellHtml = "<font color='green'>手机定位</font>";
            }
            else if(value == 11){
                e.cellHtml = "<font color='red'>成功交易奖励</font>";
            }
            else if(value == 12){
                e.cellHtml = "<font color='red'>对方违约赔付</font>";
            }
            else if(value == 13){
                e.cellHtml = "<font color='green'>货运保险</font>";
            }
            else{
          	  e.cellHtml = "<font color='blue'>未知</font>";
            }
        }
        if (field == "business_amount" || field == "before_balance" || field == "after_balance") {
            e.cellHtml = value.toFixed(2);
        }
    });
</script>
</html>
