<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <script>
		var carStatus = [
    { "id": "0", "text": "空车" },
    { "id": "1", "text": "途中" },
    { "id": "2", "text": "已出发" },
    { "id": "3", "text": "已到达" },
    { "id": "4", "text": "故障" },
    { "id": "5", "text": "故障解除" },
	{ "id": "6", "text": "回程" }
	]
    </script>
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
 </head>
<body>

        <input name="id" class="mini-hidden" />
        <div style="padding-left:11px;padding-bottom:5px;">
            
        </div>
           
        <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:280px;" plain="false">
   		  <div title="基本信息" closable="false">
        	<table style="table-layout:fixed;" border="0">
                <tr>
                    <td style="width:100px;"> 随车手机：</td>
                    <td style="width:200px;">    
                    	${fleet.phone!""}
                    </td>
                    <td style="width:100px;">车牌号码：</td>
                    <td style="width:200px;">      
                    	${fleet.cphm!""}
                    </td>
                </tr>
              <tr>
                    <td style="width:100px;"> 司机姓名：</td>
                    <td style="width:200px;">    
                  	  ${fleet.driver_name!""}
                    </td>
                    <td style="width:100px;">期望流向：</td>
                    <td style="width:200px;">      
                    	 ${fleet.qwlx!""}
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">车型：</td>
                    <td style="width:200px;">    
                    	${fleet.car_type_name!""}
                    </td>
                    <td style="width:100px;">吨位：</td>
                    <td style="width:200px;">      
                    	${fleet.car_weight!""}
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;"> 车长：</td>
                    <td style="width:200px;">    
                    	${fleet.car_length!""}米
                    </td>
                    <td style="width:100px;">容积：</td>
                    <td style="width:200px;">    
                    	${fleet.car_bulk!""} 
                    </td>
                    
                </tr>
                 <tr>
                    <td style="width:100px;">车高：</td>
                    <td style="width:200px;">    
                    	${fleet.car_height!""}
                    </td>
                    <td style="width:100px;">车宽：</td>
                    <td style="width:200px;">     
                    	${fleet.car_width!""} 
                    </td>
                <tr >
               	 <td >备注：</td>
                    <td colspan=3>   
                    	${fleet.remark!""}    
                    </td>
                </tr>     
                <tr >
                
               	 <td ><a class="mini-button " iconCls="icon-edit" onclick="edit()" >修改信息</a> </td>
               	 <td>
               	 	<a class="mini-button " iconCls="icon-remove" onclick="delRow()" >删除信息</a>
               	 </td>
           	 	<#if regist == true>
               	 <td>
               	 	<a class="mini-button " iconCls="icon-find" onclick="gpsLocation(0)" >免费定位</a>
               	 	
               	 </td>
               	 <td >
               	 	<a class="mini-button " iconCls="icon-search" onclick="phoneLocation()" >手机定位</a>  
               	 	<a class="mini-button " iconCls="icon-filter" onclick="trajectory()" >轨迹回放</a>  
				</td>
				<#else>
               	 <td >
               	 	<a class="mini-button " iconCls="icon-search" onclick="phoneLocation()" >手机定位</a>  
				</td>
           	 	<td>
           	 		司机还未成为易运宝会员，无法使用免费定位.<br/><a href='#' onclick='invitSMS()'>点此邀请司机注册</a>
           	 	</td>
           	 	<!--<td>
           	 		司机还未成为易运宝会员，无法查看轨迹.<a href='#' onclick='invitSMS()'>点此邀请司机注册</a>
           	 	</td>-->
           	 	</#if> 
           	 	
                </tr>     
                <tr>
                	<td></td>
                	<td><a class="mini-button " iconCls="icon-downgrade" onclick="sendMsgTo()" >发送司机资料至</a></td>
                </tr>
            </table>
    </div>
    <div title="车辆信息"  closable="false">
    	<table style="table-layout:fixed;">
      		  <tr>
                    <td style="width:100px;">发动机号码：</td>
                    <td style="width:200px;">    
                    	${fleet.fdjh!""} 
                    </td>
                    <td style="width:100px;">车架号码：</td>
                    <td style="width:200px;">    
                    	${fleet.cjhm!""}   
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">保险卡号：</td>
                    <td style="width:200px;">    
                    	${fleet.bxkh!""}   
                    </td>
                    <td style="width:100px;">运营证书：</td>
                    <td style="width:200px;">     
                    	${fleet.yyzs!""}    
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">挂靠单位：</td>
                    <td colspan=3>    
                    	${fleet.gkdw!""}  
                    </td>
                </tr>
         </table>       
    </div>
    <div title="车主信息"  closable="false">
       <table style="table-layout:fixed;">
      		  <tr>
                    <td style="width:100px;">车主姓名：</td>
                    <td style="width:200px;">    
                    	${fleet.owner_name!""}  
                    </td>
                    <td style="width:100px;">车主手机：</td>
                    <td style="width:200px;"> 
                    	${fleet.owner_phone!""}       
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">身份证号：</td>
                    <td style="width:200px;">    
                    	${fleet.owner_id_card!""} 
                    </td>
                    <td style="width:100px;">电话号码：</td>
                    <td style="width:200px;">    
                    	${fleet.owner_tel!""}   
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">其他电话：</td>
                    <td style="width:200px;">    
                    	${fleet.owner_tel2!""}   
                    </td>
                    <td style="width:100px;">家庭住址：</td>
                    <td style="width:200px;">  
                    	${fleet.owner_address!""}      
                    </td>
                </tr>
         </table>       
    </div>
    <div title="司机信息"  closable="false">
        <table style="table-layout:fixed;">
      		  <tr>
                    <td style="width:100px;">身份证号：</td>
                    <td style="width:200px;">    
                    	${fleet.driver_id_card!""}  
                    </td>
                    <td style="width:100px;">驾驶执照：</td>
                    <td style="width:200px;">      
                    	${fleet.driver_jszz!""}  
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">家庭电话：</td>
                    <td style="width:200px;">    
                    	${fleet.driver_tel!""} 
                    </td>
                    <td style="width:100px;">其他电话：</td>
                    <td style="width:200px;">   
                    	${fleet.driver_tel2!""}    
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">家庭住址：</td>
                    <td style="width:200px;">    
                    	${fleet.driver_address!""} 
                    </td>
                </tr>
         </table>       
    </div>
</div>   
<div id="mapContainer" style="width:100%;height:400px;"></div>
</body>

</html>
<script>
    mini.parse();

        function SaveData() {
            var o = form.getData();            

            form.validate();
            if (form.isValid() == false) return;

            var json = mini.encode([o]);
            $.ajax({
                url: "/fleet/save",
                data: { data: json },
                cache: false,
                success: function (text) {
                	var o = mini.decode(text);
                	if(!o.success){
                		mini.alert(o.data);
                	}else{
	                    CloseWindow("save");
                	}
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(jqXHR.responseText);
                    CloseWindow();
                }
            });
        }

        function GetData() {
            var o = form.getData();
            return o;
        }
        
        function CloseWindow(action) {            
            if (action == "close" && form.isChanged()) {
                if (confirm("数据被修改了，是否先保存？")) {
                    return false;
                }
            }
            if (window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
            else window.close();            
        }
        
        function onOk(e) {
            SaveData();
        }
        
        function onCancel(e) {
            CloseWindow("cancel");
        }
        
     	function invitSMS() {
	         mini.open({
	                url: "/fleet/invitSMSInit?phone=${fleet.phone!""}",
	                title: "邀请注册", width: 700, height: 400,
	                onload: function () {
	                    var iframe = this.getIFrameEl();
	                    var data = { action: "new"};
	                    iframe.contentWindow.SetData(data);
	                },
	                ondestroy: function (action) {
	                }
	            });
	    } 
     	
     	//显示短信发送窗口
        function sendMsgTo() {
        	var phone = ${fleet.phone};
        	mini.open({
                url: "/fleet/sendMgs?phone="+phone,
                title: "发送司机资料", 
                width: 300, 
                height: 300,
                allowDrag:false,
                allowResize:false
            });
            
//             mini.prompt("<font color=red>按手机短信收费，0.1物流币/条</font><br>请输入短信内容：", "发送短信",
//                function (action, value) {
//                    if (action == "ok") {
//                    	if(!value){
//                    		mini.alert("请输入短信内容");
//                    		return;
//                    	}
//                        
//                         var phones = [];
//                      	 for (var i = 0, l = rows.length; i < l; i++) {
//                            var r = rows[i];
//                            phones.push(r.phone);
//                       	 }
//                        var phoneStr = phones.join(',');
//                        $.jBox.tip("正在发送短信，请稍候...", 'loading');
//                        $.post("/fleet/sms",
//    			  		 {
//    			  		  phones:phoneStr,
//    			  		  content:value
//    			 		 },
//    			 		 function(response,status){
//    			 		 	if(response.success){
//    			 		 		 $.jBox.tip("发送成功");
//    			 		 	}
//    			 		 	else{
//    			 		 		 $.jBox.tip(response.data);
//    			 		 		mini.alert(response.data + '<br><a class="mini-button" href="/pay" plain="false" target="_blank" iconCls="icon-user">帐号充值</a>');
//    			 		 	}
//    			 		 });
//                    } 
//                },
//                true
//            );
        } 

</script>
<!--引用百度地图API-->
<script type="text/javascript" src="http://api.map.baidu.com/api?key=&v=1.2&services=true"></script>
<script type="text/javascript" src="/js/baiduMap/MarkerTool.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/library/TextIconOverlay/1.2/src/TextIconOverlay_min.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/library/DistanceTool/1.2/src/DistanceTool_min.js"></script>
<script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
<script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
<script>

	var long = ${driver.longitude!"116.403119"};
	var la = ${driver.latitude!"39.915156"};
	var driverName = '${fleet.driver_name!""}';

	//创建和初始化地图函数：
    function initMap(){
        createMap();//创建地图
        setMapEvent();//设置地图事件
        addMapControl();//向地图添加控件
    }

    //创建地图函数：
    function createMap(){
        var map = new BMap.Map("mapContainer");//在百度地图容器中创建一个地图
        window.map = map;//将map变量存储在全局
		var point = new BMap.Point(116.403119, 39.915156);//定义一个中心点坐标 
        map.centerAndZoom(point,6);//设定地图的中心点和坐标并将地图显示在地图容器中
       
    }
    //地图事件设置函数：
    function setMapEvent(){
        map.enableDragging();//启用地图拖拽事件，默认启用(可不写)
        map.enableScrollWheelZoom();//启用地图滚轮放大缩小
        map.enableDoubleClickZoom();//启用鼠标双击放大，默认启用(可不写)
        map.enableKeyboard();//启用键盘上下左右键移动地图
    }

    //地图控件添加函数：
    function addMapControl(){
	    //向地图中添加缩放控件
		var ctrl_nav = new BMap.NavigationControl({anchor:BMAP_ANCHOR_TOP_LEFT,type:BMAP_NAVIGATION_CONTROL_LARGE});
		map.addControl(ctrl_nav);
	    //向地图中添加缩略图控件
		var ctrl_ove = new BMap.OverviewMapControl({anchor:BMAP_ANCHOR_BOTTOM_RIGHT,isOpen:1});
		map.addControl(ctrl_ove);
	    //向地图中添加比例尺控件
		var ctrl_sca = new BMap.ScaleControl({anchor:BMAP_ANCHOR_BOTTOM_LEFT});
		map.addControl(ctrl_sca);
    }

      //初始化标点
    function initAllMarker(long ,la , address , last_time){
    		map.clearOverlays();
	    	var point = new BMap.Point(long, la);
			//创建一个标点
			var marker = new BMap.Marker(point);
			
			//标点右下角显示的LABEL
			var dataLabel = new BMap.Label(driverName, {offset: new BMap.Size(13, 23)});
		    dataLabel.setStyle({border: "solid 1px green",backgroundColor:"white"});
			var dataIcon= new BMap.Icon(
			'/images/onway.png',
			new BMap.Size(54, 47), {
    			imageOffset: new BMap.Size(0, -10)    //图片的偏移量。为了是图片底部中心对准坐标点。
	  		}
			);
		    //设置标点图标
			marker.setIcon(dataIcon);
			//设置标点LABEL
			marker.setLabel(dataLabel);
			//设置标点TITLE
			//marker.setTitle(dataTitle);
			marker.addEventListener("mouseover", function(){
			    var content = '司机：${fleet.driver_name!""}';
				content+= '<br>';
				content += '车牌：${fleet.cphm!""}';
				content+= '<br>';
				content+= '最近定位位置：' + address;
				content+= '<br>';
				content+= '最近定位时间：' + last_time;
				content+= '<br>';
				<#if regist == true>
				content+= '<a href="javascript:gpsLocation(0)">免费定位</a> ';
				</#if>
				content+= '<a href="javascript:phoneLocation()">手机定位</a> ';
				var infoWindow = new BMap.InfoWindow(content);
				this.openInfoWindow(infoWindow);
			});

			//在地图上打点
			map.addOverlay(marker);
			//marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳动的动画
			 map.centerAndZoom(point,11);
    }

    initMap();
	initAllMarker(long , la , '${driver.last_position!"暂无"}' , '${driver.last_position_time!"暂无"}' );
	
	function gpsLocation(beginTime){
        $.jBox.tip("正在定位，请稍候...", 'loading');
        $.post("/mobileLocation/freeLocation",
        {
          mobile:'${fleet.phone!""}',
          beginTime:beginTime
        },
        function(response,status){
            if(response.success){
                var address = response.data.address;
                $.jBox.tip("定位成功");
                if(address){
                    mini.alert("定位成功，当前位置：" + response.data.address);
                }
                initAllMarker(response.data.X,response.data.Y , response.data.address , response.data.timestamp);
            }
            else{
            	//服务器返回已超时，提示信息
            	if(response.data.done){
            		$.jBox.tip("免费GPS定位失败，推荐您直接使用手机定位，或是尝试再次GPS定位");
            		mini.alert("免费GPS定位失败，推荐您直接使用手机定位，或是尝试再次GPS定位");
            	}
            	else{
            		//如果服务器返回仍然在定位中，递归再次调用
            		gpsLocation(response.data.beginTime);
            	}
            }
         });
        
	}
	
	function phoneLocation(){
		 mini.confirm("手机定位是付费服务，每次定位将扣除0.2个物流币，确定定位？", "确定？",
            function (action) {            
                if (action == "ok") {
                	$.jBox.tip("正在定位，请稍候...", 'loading');
					$.post("/mobileLocation",
			  		{
			  		  mobile:'${fleet.phone!""}'
			 		 },
			 		 function(response,status){
			 		 	if(response.success){
			 		 		$.jBox.tip("定位成功");
			 		 		mini.alert("定位成功，当前位置：" + response.data.address);
			 		 		initAllMarker(response.data.X,response.data.Y , response.data.address , response.data.timestamp);
			 		 	}
			 		 	else{
			 		 		$.jBox.tip(response.data);
			 		 		mini.alert(response.data);
			 		 	}
			 		 });
                } 
            }
		);
		
		
	}
	
	function delRow() {
    	 mini.confirm("确定删除记录？", "确定？",
            function (action) {            
                if (action == "ok") {
                    $.ajax({
                        url: "/fleet/delete/${fleet.id}",
                        success: function (text) {
                           CloseWindow('OK');
                        },
                        error: function () {
                        	mini.alert("删除失败，请稍后再试");
                        	CloseWindow('OK');
                        }
                    });
                } 
            }
        );
	        
    }
        
    function edit(){
        mini.open({
            url: "/fleet/edit/${fleet.id}",
            title: "修改信息", 
            width: 700, 
            height: 400,
            ondestroy: function (action) {
                window.location.reload();
                
            }
        });
     }
     
     function CloseWindow(action) {
        if (window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
        else window.close();            
    } 
    
     //查看轨迹
    function trajectory(row_uid) {
         mini.open({
            url: "/fleet/trajectory?phone=${fleet.phone!""}",
            title: "订单轨迹", 
            width: 800, 
            height: 700
        });
    }
</script>
