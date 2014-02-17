<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
 </head>
<body >
		<div id="mapContainer" style="width:100%;height:100%;"></div>
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
        initAllMarker();
    }
    
    //创建地图函数：
    function createMap(){
        var map = new BMap.Map("mapContainer");//在百度地图容器中创建一个地图
		var point = new BMap.Point(107.404, 39.915);//定义一个中心点坐标 <成都>
        map.centerAndZoom(point,5);//设定地图的中心点和坐标并将地图显示在地图容器中
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
    
      //初始化标点
    function initAllMarker(){
    	<#list orders as order>
	    	var point = new BMap.Point(${order.longitude?string(",##0.000000")},${order.latitude?string(",##0.000000")});
			//创建一个标点
			var marker = new BMap.Marker(point);
			//标点右下角显示的LABEL
			var dataLabel = new BMap.Label('${order.driver_name!""}', {offset: new BMap.Size(13, 23)});
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
			    var content = "<table>"
				content += "<tr><td>单号：${order.id!""}</td></td>";
				content += "<tr><td>司机姓名：${order.driver_name!""}</td></tr>";
		    	content += "<tr><td>司机电话：${order.driver_phone!""}</td></tr>";
		    	content += "<tr><td>车牌号码：${order.plate_number!""}</td></tr>";
		    	content += "</table>";
				var infoWindow = new BMap.InfoWindow(content);
				this.openInfoWindow(infoWindow);
			});
			
			//在地图上打点
			map.addOverlay(marker);
		</#list>
		
		
		
    }
    
    initMap();
    
</script>