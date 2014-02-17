<html>
 <head>
 	<link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
	<script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
 </head>
<body ondragstart="window.event.returnValue=false" oncontextmenu="window.event.returnValue=false" onselectstart="event.returnValue=false">
        <div class="mini-toolbar" style="border-bottom:0;padding:0px;">
	        <table style="width:100%;" border="0">
		        <tr>
		            <td style="width:100%;">
		            	<a id="addDriverMany" class="mini-button" iconCls="icon-add" onclick="add_my_tream()" >添加到我的车队</a>
		            	<a class="mini-button" iconCls="icon-node" onclick="showSMS()">发送短信</a>
		            	<a class="mini-button" iconCls="icon-upload" onclick="importUser()">导入司机</a>
		            	<!--<a href="#" style="margin-left:45%;" onclick="toMyFleet()" >进入我的车队</a>-->
		            </td>
		       </tr>
		       <tr></tr>
		       <tr>
		            <td style="white-space:nowrap;" align="right">
		            <input id="start_province" name="start_province" class="mini-combobox" textField="name" 
		            valueField="id" emptyText="出发地" url="/dict/getProvinceList" showNullItem="false" style="width:80px;font-size:12px;"/>
		            
		            <input id="end_province" name="end_province" class="mini-combobox" textField="name" 
		            valueField="id" emptyText="目的地" url="/dict/getProvinceList" showNullItem="false" style="width:90px;font-size:12px;"/>
		            
		            <input id="last_position" name="last_position" class="mini-textbox" textField="name" 
		            valueField="id" emptyText="请输入车辆位置" style="font-size:12px;"/>
		            
		            <input id="car_type" name="car_type" class="mini-combobox" textField="name"
		            valueField="id" emptyText="车型" url="/dict/getAllCarType" showNullItem="false" style="width:80px;font-size:12px;"/>
		            
		            <input id="car_length" name="car_length" class="mini-combobox" textField="name" 
		            valueField="value" emptyText="车长(米)" url="/car_length.txt" showNullItem="false" style="width:80px;font-size:12px;"/>
		            
		            <input id="car_weight" name="car_weight" class="mini-combobox" textField="name" 
		            valueField="value" emptyText="载重(吨)" url="/car_weight.txt" showNullItem="false" style="width:80px;font-size:12px;"/>
		            
		            <input id="driver_attest" name="driver_attest" class="mini-combobox" textField="name" 
		            valueField="value" emptyText="有无证件" url="/driver_attest.txt" showNullItem="false" style="width:80px;font-size:12px;"/>
		            
		            <a class="mini-button" onclick="search()" plain="true" iconCls="icon-search">搜索</a>
		            </td>
		      </tr>
		      <tr></tr>
		      </table> 
        </div>
        <div class="mini-fit" >
			<div id="datagrid" class="mini-datagrid" style="width:100%;height:98%;" url="/fleet/list" allowResize="true" idField="id" multiSelect="true" allowAlternating="true" pageSize="20" > 
			<div property="columns">
        	<div type="checkcolumn" field="rowid" name="checkid"></div> 
        	<div field="plate_number" width="80">
            	车牌号码
            </div>
            <!--<div field="start_province_name" width="55">
            	出发省
            </div>-->
            <div field="start_city_name" width="55">
            	出发地
            </div>
            <!--<div field="end_province_name" width="55">
            	目的省
            </div>-->
            <div field="end_city_name" width="55">
            	目的地
            </div>
            <div field="name" width="60">
            	司机
            </div>
           <div field="phone" width="100">
            	随车手机
            </div>
            <div name="action" width="40" headerAlign="center" align="center" renderer="onActionRenderer" cellStyle="padding:0;">
        		
        	</div>
             <div field="last_position" width="110">
            	当前位置
            </div>
            <div field="type_name" width="60">
            	车型
            </div>
            <div field="car_length" width="60">
            	车长(米)
            </div>
            <div field="car_weight" width="60">
            	载重(吨)
            </div>
            <div field="last_position_time" width="100">
            	定位时间
            </div> 
             <div field="status" width="70">
            	有无证件
            </div>
		</div> 
			</div>
		</div>
	
<div id="win1" class="mini-window" title="发送短信" style="width:300px;height:200px;" 
   showToolbar="true" showFooter="true" showModal="true"   allowDrag="true">
   短信内容： 
   <textarea name="remark"  class="mini-textarea" style="width:280px;"></textarea>
   <div style="text-align:center;padding:10px;">               
     <a class="mini-button" iconCls="icon-node" onclick="sendSMS()">发送</a>  
   </div> 
</div>
</body>
<script>
window.onselectstart=function()   {return   false;}       //禁用选择
window.oncopy=function()   {return   false;}       //禁止复制

    mini.parse();
    var grid = mini.get("datagrid");
    grid.load();
    grid.on("drawcell", function (e) {
        var record = e.record,
        column = e.column,
        field = e.field,
        value = e.value;
        var uid = record._uid;
        //格式化状态
        if (field == "status") {
        	if(value == 1){
            	e.cellHtml = "<font color='green'>有</font>";
            }else{
            	e.cellHtml = "<font color='red'>无</font>";
            }
        }
        if(field == "phone"){
        	e.cellHtml = value.substring(0,3)+"****"+value.substring(7,value.length);
        }
        if (field == "last_position_time") {
			e.cellHtml =  mini.formatDate ( mini.parseDate ( value ), 'MM-dd HH:mm' );
        }
        if (field == "car_type_name") {
        	var content = '';
        	if(value){
        		content += value + ",";
        	}
        	content += record.car_length + '米,' + record.car_weight + '吨'; 
			e.cellHtml =  content;
        }
    });
    
    function onActionRenderer(e) {
        var grid = e.sender;
        var record = e.record;
        var uid = record._uid;
        var rowIndex = e.rowIndex;

        var s = ' <a   href="javascript:showDetail(\'' + uid + '\')">详情</a>';
        	

        if (grid.isEditingRow(record)) {
            s = '<a class="Update_Button" href="javascript:updateRow(\'' + uid + '\')">确定</a> '
                + '  <a class="Cancel_Button" href="javascript:cancelRow(\'' + uid + '\')">取消</a>';
        }
        return s;
    }
    
    
    function add_my_tream(){
    	var rows = grid.getSelecteds();//获取勾选的行
    	var row_ids = "";
 	   var reg=/,$/;//表达式，去掉最后字符串最后一个逗号
 	   if(rows.length > 0){
 		   for(var i=0;i<rows.length;i++){
 			  row_ids = row_ids+rows[i].id+",";//把所有的id拼成一个ids字符串
 		   }
 		  mini.confirm("确定添加到车队吗？", "提醒",
		            function (action) {            
		                if (action == "ok") {
		                     grid.loading("处理中，请稍候......");
		                    $.ajax({
		                        url: "/fleet/addTOMyCars/" + row_ids.replace(reg,""),
		                        success: function (text) {
		                    		mini.alert(text);
		                    		grid.reload();
		                        },
		                        error: function () {
		                        	mini.alert("添加失败，请检查后再试！");
		                        	grid.unmask();
		                        }
		                    });
		                }
		            }
		     );
 	   }else{
 		   mini.alert("请选择你要操作的数据.");
 		   return;
 	   }
    }
    
    function toMyFleet(){
    	var iframe = this.getIFrameEl();
    	alert(iframe);
    }
    
    
       function add() {
            mini.open({
                url: "/fleet/add",
                title: "新增车辆", width: 700, height: 400,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    var data = { action: "new"};
                    iframe.contentWindow.SetData(data);
                },
                ondestroy: function (action) {
                    grid.reload();
                }
            });
        }
        
      // 查看详情  
      function showDetail(row_uid) {
		var row = grid.getRowByUID(row_uid);
        if (row) {
	        mini.open({
                url: "/fleet/online_cars_detail/" + row.id,
                title: "查看详情", 
                width: 700, 
                height: 370,
                ondestroy: function (action) {  //弹出页面关闭前
			        //grid.load();
                    search();           
			    }
            });
        }
    }   
    
     function search() {
        var start_province = mini.get("start_province").getValue();
        var end_province = mini.get("end_province").getValue();
        var last_position = mini.get("last_position").getValue();
        var car_type = mini.get("car_type").getValue();
        var car_length = mini.get("car_length").getValue();
        var car_weight = mini.get("car_weight").getValue();
        var driver_attest = mini.get("driver_attest").getValue();
        grid.load({start_province:start_province,end_province:end_province,last_position: last_position,car_type:car_type,car_length:car_length,car_weight:car_weight,driver_attest:driver_attest});
    }  
    
    //显示短信发送窗口
    function showSMS() {
        var rows = grid.getSelecteds();
        if(rows.length == 0){
        	mini.alert('请选择要发送的司机');
        	return;
        }
        
         mini.prompt("<font color=red>按手机短信收费，0.1物流币/条</font><br>请输入短信内容：", "发送短信",
            function (action, value) {
                if (action == "ok") {
                	if(!value){
                		mini.alert("请输入短信内容");
                		return;
                	}
                    
                     var phones = [];
                  	 for (var i = 0, l = rows.length; i < l; i++) {
                        var r = rows[i];
                        phones.push(r.phone);
                   	 }
                    var phoneStr = phones.join(',');
                    $.jBox.tip("正在发送短信，请稍候...", 'loading');
                    $.post("/fleet/sms",
			  		 {
			  		  phones:phoneStr,
			  		  content:value
			 		 },
			 		 function(response,status){
			 		 	if(response.success){
			 		 		 $.jBox.tip("发送成功");
			 		 	}
			 		 	else{
			 		 		 $.jBox.tip(response.data);
			 		 		mini.alert(response.data + '<br><a class="mini-button" href="/pay" plain="false" target="_blank" iconCls="icon-user">帐号充值</a>');
			 		 	}
			 		 });
                } 
            },
            true
        );
    } 
    
     function invitSMS(row_uid) {
      	 var row = grid.getRowByUID(row_uid);
         mini.open({
                url: "/fleet/invitSMSInit?phone=" +　row.phone,
                title: "邀请注册", width: 700, height: 400,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    var data = { action: "new"};
                    iframe.contentWindow.SetData(data);
                },
                ondestroy: function (action) {
                    grid.reload();
                }
            });
    } 
    
    //发送短信
    function sendSMS(){
    	var rows = grid.getSelecteds();
    	
    }  
    
     function delRow(row_uid) {
             var row = grid.getRowByUID(row_uid);
            if (row) {
            	 mini.confirm("确定删除记录？", "确定？",
		            function (action) {            
		                if (action == "ok") {
		                     grid.loading("删除中，请稍候......");
		                    $.ajax({
		                        url: "/fleet/delete/" + row.id,
		                        success: function (text) {
		                            grid.reload();
		                        },
		                        error: function () {
		                        	mini.alert("删除失败，请稍后再试");
		                        	grid.unmask();
		                        }
		                    });
		                } 
		            }
		        );
		        
            }
        }
        
    function edit(row_uid){
       	var row = grid.getRowByUID(row_uid);
        mini.open({
            url: "/fleet/edit/" + row.id,
            title: "修改信息", 
            width: 700, 
            height: 400,
            ondestroy: function (action) {
                window.location.reload();
                
            }
        });
     }
     
     function importUser(row_uid){
        mini.open({
            url: "/fleet/importUser/",
            title: "导入司机", 
            width: 300, 
            height: 200,
            ondestroy: function (action) {
                window.location.reload();
                
            }
        });
     }
     
</script>
</html>
