<html xmlns="http://www.w3.org/1999/xhtml">
 	<head>
    	<script src="js/boot.js"></script>
    	<link href="css/style.css" rel="stylesheet" type="text/css" /> 
		<title>易运宝--随时随地随您挑！</title>
 	</head>
	<body style="background:url(images/bg2.png) ; " scrolling="no">
		<div title="center" region="south" showSplit="false" showHeader="false" height="30" >
	        <div class="mini-splitter" style="width:100%;height:680;" handlerSize="10">
				<div size="190" showCollapseButton="true">
			    	<div id="menu" class="bleft fl" style="margin-left:0px;margin-top:-5px;">
						<ul>
							<li class="active"><a class="onway" href="/order/dealList" target="mainframe">在途货单</a></li>
							<li><a class="pending" href="/order/pendingList" target="mainframe">待定货单</a></li>
							<li><a class="history" href="/order/historyList" target="mainframe">历史货单</a></li>
							<li><a class="cars"  href="/fleet" target="mainframe">网上车场</a></li>
							<li><a class="cars"  href="/fleet/myFleetList" target="mainframe">我的车队</a></li>
							<li><a class="account" href="/account" target="mainframe">我的易运宝</a></li>
							<li><a class="info" href="/msg" target="mainframe">信息中心<span id="spanInfo"></span></a></li>
							<li><a class="other" href="/other" target="mainframe">其他</a></li>
						</ul>
			    	</div>
		 		</div>
				<div showCollapseButton="false">
					<div class="mini-fit" >
						<iframe  src="order/dealList" id="mainframe" name="mainframe" frameborder="0" name="main" style="width:100%;height:99%;" border="0" scrolling="no"></iframe>
					</div>
		 		</div>
			</div>
	    </div>
<script>
	function getUnReadMsgCount(){
		$.get("/msg/getUnReadCount",
		 { },
		function(response,status){
			var content = "" ;
			if(response.data != '0' ){
				content = "<font color='red'>(" + response.data + ")</font>" ;
			}
		 $("#spanInfo").html(content);
		});
	}
	jQuery(function($){
		$("#menu li").click(function(){
			$("#menu li").removeClass("active");
			$(this).addClass("active");
			getUnReadMsgCount();
		});
		getUnReadMsgCount();
		setInterval(getUnReadMsgCount,60000);
	});
</script>
	</body>
</html>