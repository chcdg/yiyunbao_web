<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
   
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
 </head>
<body>
        <div class="mini-panel" title="基本信息" style="width:100%;" showCollapseButton="true">
            <table style="table-layout:fixed;" >
                <tr>
                    <td style="width:100px;">手机号码：</td>
                    <td style="width:200px;">
                        ${driver.phone!?html}
                    </td>
                    <td style="width:100px;">姓名：</td>
                    <td style="width:200px;">
                        ${driver.name!?html}
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">随车手机：</td>
                    <td style="width:200px;">
                        ${driver.car_phone!?html}
                    </td>
                    <td style="width:100px;"></td>
                    <td style="width:200px;">
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">身份证：</td>
                    <td style="width:200px;">
                        ${driver.id_card!?html}
                    </td>
                     <td style="width:100px;">车主电话：</td>
                    <td style="width:200px;">
                       ${driver.owner_phone!?html}
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">驾驶证姓名：</td>
                    <td style="width:200px;">
                        ${driver.license_name!?html}
                    </td>
                     <td style="width:100px;">驾驶证号码：</td>
                    <td style="width:200px;">
                       ${driver.license!?html}
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">行驶证姓名：</td>
                    <td style="width:200px;">
                        ${driver.registration_name!?html}
                    </td>
                     <td style="width:100px;">行驶证号码：</td>
                    <td style="width:200px;">
                       ${driver.registration!?html}
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">车牌号：</td>
                    <td style="width:200px;">
                        ${driver.plate_number!?html}
                    </td>
                     <td style="width:100px;">车长：</td>
                    <td style="width:200px;">
                       ${driver.car_length!?html}米
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">车型：</td>
                    <td style="width:200px;">
                         ${driver.car_type_str!?html}
                    </td>
                     <td style="width:100px;">载重：</td>
                    <td style="width:200px;">
                        ${driver.car_weight!?html}吨
                    </td>
                </tr>
            </table>
        </div>
        <div class="mini-panel" title="照片信息" style="width:100%;" showCollapseButton="true">
            <table style="table-layout:fixed;" >
                <tr>
                	 <td style="width:100px;">车辆照片：</td>
                    <td style="width:200px;">
                    	<a href="${driver.car_photo1!""}" target="_blank"><img src="${driver.car_photo1!""}" width="50" height="50"></a>
                    	<a href="${driver.car_photo2!""}" target="_blank"><img src="${driver.car_photo2!""}" width="50" height="50"></a>
                    	<a href="${driver.car_photo3!""}" target="_blank"><img src="${driver.car_photo3!""}" width="50" height="50"></a>
                    </td>
                    <td style="width:100px;">身份证照片：</td>
                    <td style="width:200px;">
                    	<a href="${driver.id_card_photo!""}" target="_blank"><img src="${driver.id_card_photo!""}" width="50" height="50"></a>
                    </td>
                    
                </tr>
                 <tr>
                 	 <td style="width:100px;">驾驶证照片：</td>
                    <td style="width:200px;">
                    	<a href="${driver.license_photo!""}" target="_blank"><img src="${driver.license_photo!""}" width="50" height="50"></a>
                    </td>
                    <td style="width:100px;">行驶证照片：</td>
                    <td style="width:200px;">
                    	<a href="${driver.registration_photo!""}" target="_blank"><img src="${driver.registration_photo!""}" width="50" height="50"></a>
                    </td>
                    
                </tr>
            </table>
        </div>
        <div class="mini-panel" title="司机信誉" style="width:100%;" showCollapseButton="true">
            <table style="table-layout:fixed;" >
                <tr>
                	 <td style="width:100px;">信誉评价：</td>
                    <td style="width:200px;">
                    	<div id="myscore"></div>
                    </td>
                    <td style="width:100px;">履约诚信度：</td>
                    <td style="width:200px;">
                    	<div id="myscore1"></div>
                    </td>
                    
                </tr>
                 <tr>
                 	 <td style="width:100px;">运输准时率：</td>
                    <td style="width:200px;">
                    	<div id="myscore2"></div>
                    </td>
                    <td style="width:100px;">服务态度：</td>
                    <td style="width:200px;">
                    	<div id="myscore3"></div>
                    </td>
                    
                </tr>
                 <tr>
                 	 <td colspan="4" align="center" height="50">
                 	 	<a class="mini-button" onclick="showDriverReply('${driver.id}')" plain="false" iconCls="icon-user">查看信誉详情</a>
                 	 	<a class="mini-button" onclick="accept_order('${driver.id}')" plain="false" iconCls="icon-ok">确认抢单</a>
                 	 </td>
                </tr>
            </table>
        </div>
</body>
</html>
 <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
    <script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
     <script type="text/javascript" src="/js/jquery.raty.min.js"></script>
<script>
    mini.parse();
	
	 function showDriverReply(id) {
	         mini.open({
                url: "/driverReply/" + id,
                title: "详细评价", 
                width: 800, 
                height: 460
            });
        }
        
    function accept_order(driverId) {
        	 mini.confirm("确定要由该司机承接货单吗？", "确认",
	            function (action, value) {
	                if (action == "ok") {
	                    $.ajax({
			                url: "/order/accept_order",
			                data: {order_id: ${orderId}, driver_id: driverId},
			                cache: false,
                            dataType: 'json',
			                success: function (text) {
			                	if(text.success){
				                    mini.alert("已接受投标,订单交易成功.");
				                    parent.window.location.reload();
				                    //CloseWindow("save");
			                	}
			                	else{
			                		mini.alert(text.data || "操作失败，请联系管理员");
			                	}
			                },
			                error: function (jqXHR, textStatus, errorThrown) {
			                    mini.alert(jqXHR.responseText);
			                    //CloseWindow();
			                }
			            });
			            
	                } 
	            }
	        );
    }
    
    function CloseWindow(action) {
        if (window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
        else window.close();            
    }
    
    $(function() {
   	 	$.fn.raty.defaults.path = '/images/rate';
    	$('#myscore1').raty({
    		score : ${driver.score1},
    		readOnly : true
    	});
    	$('#myscore2').raty({
    		score : ${driver.score2},
    		readOnly : true
    	});
    	$('#myscore3').raty({
    		score : ${driver.score3},
    		readOnly : true
    	});
    	$('#myscore').raty({
    		score : ${driver.score},
    		readOnly : true
    	});
    });
</script>