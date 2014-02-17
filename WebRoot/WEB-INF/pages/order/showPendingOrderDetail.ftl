<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
    <script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    <link rel="stylesheet" href="/js/fancybox/jquery.fancybox.css" type="text/css" media="screen" />
    <script type="text/javascript" src="/js/fancybox/jquery.fancybox.pack.js"></script>
    <style type="text/css">
        .fancybox img{
            width:100px;
            height: 100px;
        }
    </style>
 </head>
<body>
        <input name="id" class="mini-hidden" />
        <div style="padding-left:11px;padding-bottom:5px;">
            
        </div>
    <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:450px;" plain="false">
    	<div title="货单信息" closable="false">
        	<table style="table-layout:fixed;" >
                <tr>
                    <td style="width:120px;"> 订单号：</td>
                    <td style="width:200px;">
                    	${order.id!""}
                    </td>
                    <td style="width:120px;">路线：</td>
                    <td style="width:200px;">      
                    	${order.start_province_name!?html}${order.start_city_name!?html}${order.start_district_name!?html} -&gt;${order.end_province_name!?html}${order.end_city_name!?html}${order.end_district_name!?html}
                    </td>
                </tr>
                <tr>
                    <td> 货物名称：</td>
                    <td>    
                  	  ${order.cargo_desc!?html}
                    </td>
                    <td>货物类别：</td>
                    <td>
                    	 ${order.cargo_type_name!?html}
                    </td>
                </tr>
                <tr>
                    <td>车型：</td>
                    <td>    
                    	${order.car_type_name!?html}
                    </td>
                    <td>车长：</td>
                    <td>      
                    	${order.car_length!?html}米
                    </td>
                </tr>
                <tr>
                    <td>货物数量：</td>
                    <td>    
                    	${order.cargo_number!}${order.cargo_unit_name!?html}
                    </td>
                    <td></td>
                    <td>
                    </td>
                </tr>
                 <tr>
                    <td>运输单价：</td>
                    <td nowrap="true">
                        <form id="form1" method="post">
                            <input name="order_id" class="mini-hidden" id="order_id" value="${order.id}"/>
                            <input id="unit_price" name="unit_price" class="mini-spinner" required="true" value="${order.unit_price}" maxValue="5000000" decimalPlaces="2" onvaluechanged="onUnitPriceChanged" style="width:60px;" <#if (order.vie_driver_count > 0)>readonly="true"</#if>/>元/${order.cargo_unit_name!?html}
                            <#-- <#if order.vie_driver_count == 0> -->
                            <a class="mini-button" onclick="adjustPrice()" style="width:60px;margin-right:20px;">调价</a>
                            <#-- </#if> -->
                        </form>
                    </td>
                    <td>总价：</td>
                    <td>
                        <span id="totalPrice">${order.price}</span>元
                    </td>
                </tr>
                <tr>
                    <td>信息已推送给：</td>
                    <td>
                    	${order.push_drvier_count!"0"} 位司机
                    </td>
                    <td>已有：</td>
                    <td>     
                        ${order.vie_driver_count!"0"}位司机抢单
                    </td>
                </tr>
                <#if (order.push_drvier_count > 0 && order.vie_driver_count==0)>
                <tr>
                    <td colspan="4">
                        <div class="mini-toolbar" style="padding:5px;margin-bottom:5px; background:#15487E;color:#fff;">
                            目前无人抢单，可能运输单价过低，建议您适当提高运输单价，再次发布消息
                        </div>
                    </td>
                </tr>
                </#if>
                <tr>
               	    <td >备注：</td>
                    <td colspan=3>   
                    	${order.cargo_remark!"暂无"?html}    
                    </td>
                </tr>
                <tr>
                    <td >货物图片：</td>
                    <td colspan=3>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <#if order.cargo_photo1?has_content>
                        <a class="fancybox" rel="group" href="${order.cargo_photo1}" ><img src="${order.cargo_photo1}" alt="货物照片" /></a>
                        </#if>
                        <#if order.cargo_photo2?has_content>
                        <a class="fancybox" rel="group" href="${order.cargo_photo2}"><img src="${order.cargo_photo2}" alt="货物照片" /></a>
                        </#if>
                        <#if order.cargo_photo3?has_content>
                        <a class="fancybox" rel="group" href="${order.cargo_photo3}"><img src="${order.cargo_photo3}" alt="货物照片" /></a>
                        </#if>
                    </td>
                </tr>
            </table>
        </div>
    </div>


<script>
    mini.parse();
    var form1 = new mini.Form("form1");

    function adjustPrice() {
        var o = form1.getData();            
        form1.validate();
        if (form1.isValid() == false) return;
        mini.confirm("确定调价吗","温馨提示", function(action){
            if (action != "ok"){
                return;
            }
            $.jBox.tip("正在保存价格，请稍候...", 'loading');
            
            $.ajax({
                url: "/order/adjustPrice",
                type: "POST",
                data: o,
                success: function(response,status){
                    if(!response.success){
                        $.jBox.tip(response.data);
                    }
                    else{
                        $.jBox.tip('保存价格成功.');
                        window.location.reload();
                    }
                }
            });
        });
        //console.debug(o)
    }
    function CloseWindow(action) {
        if (window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
        else window.close();            
    }

    function onUnitPriceChanged(){
        var unit_price = mini.get("unit_price").getValue();
        var cargo_number = ${order.cargo_number!"0"};
        var totalPrice = unit_price * cargo_number;
        $("#totalPrice").text(totalPrice);

        var originalUnitPrice = '${order.unit_price?string("0")}';
        if(originalUnitPrice != unit_price){
            $("#totalPrice").css("color", "red");
            $(mini.get("unit_price").getEl()).find("input").css("color", "red");
        }else{
            $("#totalPrice").css("color", "");
            $(mini.get("unit_price").getEl()).find("input").css("color", "");
        }
    }

    $(function(){
        $(".fancybox").fancybox({
            'transitionIn'  : 'elastic',
            'transitionOut' : 'elastic',
        });
    })

</script>

</body>

</html>