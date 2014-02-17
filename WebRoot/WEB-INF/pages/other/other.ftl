<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    <link href="/css/style.css" rel="stylesheet">
 </head>
<body>
         
        <input name="id" class="mini-hidden" />
        <div style="padding-left:11px;padding-bottom:5px;">
            
        </div>
           
        <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:660px;" plain="false">
   		  <div title="里程计算器" closable="false">
   		  	 <div class="mini-toolbar" style="border-bottom:0;padding:0px;">
	            <table style="width:100%;">
	                <tr>
	                    <td style="width:100%;">
	                    	<a class="mini-button" iconCls="icon-filter" onclick="dis()">测距</a>
	                    </td>
	                    <td style="white-space:nowrap;">
	                        <input id="mapSearchValue" name="mapSearchValue" class="mini-textbox" emptyText="地名" style="width:150px;" onenter="search"/>  
	                        <a class="mini-button" onclick="mapSearch()" plain="true" iconCls="icon-search">查找</a>
	                    </td>
	                </tr>
	            </table>           
	        </div>
	        <div id="results"></div>
   		  	<div id="mapContainer" style="width:100%;height:585px;"></div>
          </div>
    <div title="帮助"  closable="false">
     	帮助文档即将上线
    </div>
</div>   
    

</body>

</html>
<script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
<script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
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
        window.map = map;//将map变量存储在全局
		var point = new BMap.Point(108.403119, 37.915156);//定义一个中心点坐标 
        map.centerAndZoom(point,5);//设定地图的中心点和坐标并将地图显示在地图容器中
       
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
		
		map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT}));    //左上角，默认地图控件
    }

    initMap();
    
    function dis(){
	 	  var myDis = new BMapLib.DistanceTool(map);
	 	  myDis.open();
	 }
	 
  	function mapSearch(){
 		var local = new BMap.LocalSearch(map, {
		  renderOptions: {map: map, panel: "results"}
		});
		local.search(mini.get("mapSearchValue").value);
	 }
</script>
<script>
    mini.parse();

</script>
