<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
 </head>
<body>
         
        <input name="id" class="mini-hidden" />
        <div style="padding-left:11px;padding-bottom:5px;">
            
        </div>
           
        <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:280px;" plain="false">
   		  <div title="中国人保" closable="false">
   		    <br>
   		  	本账号购买人保货运险： <br><br>
			运输损失基本险-普通货物:万分之<font color="red">4.0 </font><br>
			运输损失综合险-普通货物:万分之<font color="red">4.5 </font><br>
			运输损失基本险-鲜活货物:万分之<font color="red">10.0 </font><br><br>
   		  	<a href="javascript:zgrb()"><font size="5">立即购买</font></a>
    	  </div>
  	  <div title="太平洋保险"  closable="false">
        	 <br>
   		  	本账号购买太平洋货运险： <br><br>
			运输损失基本险-普通货物:万分之<font color="red">3.0 </font><br>
			运输损失综合险-普通货物:万分之<font color="red">4.0 </font><br>
			运输损失综合险-附加被盗险:万分之<font color="red">5.0 </font><br><br>

   		  	<a href="javascript:tpybx()"><font size="5">立即购买</font></a>
    	</div>
   	 <div title="中国平安"  closable="false">
   	 	 <br>
   	 	本账号购买中国平安货运险： <br><br>
		运输损失基本险-普通货物:万分之<font color="red">10.0 </font><br>
		运输损失综合险-普通货物:万分之<font color="red">12.0 </font><br>
		运输损失基本险-鲜活货物:万分之<font color="red">15.0 </font><br>
		整车失踪险：<font color="red">100</font>元/车 <br>
		碰撞颠覆险：<font color="red">150</font>元/车 <br> <br>
   	 	<a href="javascript:zgpa();"><font size="5">立即购买</font></a>
    </div>
</div>   
    

</body>

</html>
<script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
<script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
<script>
    mini.parse();

    function zgrb() {
		$.jBox.tip('接口还未开通');
    }
    
    function tpybx() {
      mini.open({
          url: "/insurance/cpic",
          title: "中国太平洋国内货运险投保系统", width: 900, height: 650,
          onload: function () {
              var iframe = this.getIFrameEl();
              var data = { action: "new"};
              //iframe.contentWindow.SetData(data);
          },
          ondestroy: function (action) {
              //grid.reload();
          }
      });
		  //$.jBox.tip('接口还未开通');
    }
    
     function zgpa() {
		    $.jBox.tip('接口还未开通');
    }

   
</script>