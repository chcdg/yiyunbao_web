<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
 </head>
<body >
<a id="replay" class="mini-button" onclick="run()" plain="false" iconCls="icon-filter">回放</a>
		<div id="mapContainer" style="width:100%;height:97%;"></div>
</div>
		
		
		
</body>

</html>
<script>
    mini.parse();
    
                 
</script>
<!--引用百度地图API-->
<script type="text/javascript" src="http://api.map.baidu.com/api?key=&v=1.2&services=true"></script>
<script type="text/javascript" src="/js/baiduMap/MarkerTool.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/library/TextIconOverlay/1.2/src/TextIconOverlay_min.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/library/DistanceTool/1.2/src/DistanceTool_min.js"></script>
<script>

		//创建和初始化地图函数：
    function initMap(){
        createMap();//创建地图
        setMapEvent();//设置地图事件
        addMapControl();//向地图添加控件
    }
    
    //创建地图函数：
    function createMap(){
        var map = new BMap.Map("mapContainer");//在百度地图容器中创建一个地图
		 var point = new BMap.Point(116.403119, 39.915156);
        map.centerAndZoom(point,12);//设定地图的中心点和坐标并将地图显示在地图容器中
        window.map = map;//将map变量存储在全局
        
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
    
    initMap();
    var timeArray = new Array();
    var locationArray = new Array();
    <#list list as record>
    	timeArray.push("${record.create_time}");
    	locationArray.push("${record.location}");
    </#list>
    <#if points??>
    var pts = [${points}]; 
	 map.centerAndZoom(pts[0],12);
	var myIcon = new BMap.Icon("/images/onway.png", new BMap.Size(54, 47), {    //小车图片
	    //offset: new BMap.Size(0, -5),    //相当于CSS精灵
	    imageOffset: new BMap.Size(0, -10)    //图片的偏移量。为了是图片底部中心对准坐标点。
	  });
	 var carMk = new BMap.Marker(pts[0],{icon:myIcon});
	 carMk.addEventListener("mouseover", function(){
			    var content = "<table>"
				content += "<tr><td>时间：" + timeArray[0] + "</td></td>";
				content += "<tr><td>地点：" + locationArray[0] + "</td></tr>";
		    	content += "</table>";
				var infoWindow = new BMap.InfoWindow(content);
				this.openInfoWindow(infoWindow);
			});
	map.addOverlay(carMk);
	<#else>
	alert('轨迹信息不存在或已删除');
	</#if>
	var myIcon = new BMap.Icon("/images/onway.png", new BMap.Size(54, 47), {    //小车图片
	    //offset: new BMap.Size(0, -5),    //相当于CSS精灵
	    imageOffset: new BMap.Size(0, -10)    //图片的偏移量。为了是图片底部中心对准坐标点。
	  });
	var pointIcon = new BMap.Icon("/images/cd_32x32.png", new BMap.Size(12, 12), {    //小车图片
	    //offset: new BMap.Size(0, 0),    //相当于CSS精灵
	    imageOffset: new BMap.Size(0, 0)    //图片的偏移量。为了是图片底部中心对准坐标点。
	  });
	window.run = function (){
		map.clearOverlays();
		var polyline = new BMap.Polyline(pts, {strokeColor:"green", strokeWeight:5, strokeOpacity:0.5 });
		map.addOverlay(polyline);
		 <#list list as record>
	    	var markerPoint${record_index} = new BMap.Marker(pts[${record_index}],{icon:pointIcon});
			markerPoint${record_index}.addEventListener("mouseover", function(){
			    var content = "<table>"
				content += "<tr><td>时间：${record.create_time}</td></td>";
				content += "<tr><td>地点：${record.location}</td></tr>";
		    	content += "</table>";
				var infoWindow = new BMap.InfoWindow(content);
				this.openInfoWindow(infoWindow);
			});
 			map.addOverlay(markerPoint${record_index});
	    </#list>
		//$("#replay").attr("disabled" , true);
        var paths = pts.length;    //获得有几个点
		
		if(!carMk){
	        var carMk = new BMap.Marker(pts[0],{icon:myIcon});
	         carMk.addEventListener("mouseover", function(){
			    var content = "<table>"
				content += "<tr><td>时间：<span id='nowTime'>" + timeArray[0] + "</span></td></td>";
				content += "<tr><td>地点：<span id='nowLocation'>" + locationArray[0] + "</span></td></tr>";
		    	content += "</table>";
				var infoWindow = new BMap.InfoWindow(content);
				this.openInfoWindow(infoWindow);
			});
	        map.addOverlay(carMk);
        }
        i=0;
        
        function resetMkPoint(i){
            carMk.setPosition(pts[i]);
            $("#nowTime").html(timeArray[i]);
            $("#nowLocation").html(locationArray[i]);
            if(i < paths){
                setTimeout(function(){
                    i++;
                    resetMkPoint(i);
                },1000);
            }else{
          //  	$("#replay").attr("disabled" , false);
            }
        }
        setTimeout(function(){
            resetMkPoint(1);
        },1000)

	}
function dis(){
	 	  var myDis = new BMapLib.DistanceTool(map);
	 	  myDis.open();
	 }
    
</script>