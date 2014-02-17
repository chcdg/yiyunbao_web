<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
    <script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
	<script type="text/javascript" src="/js/jquery.xmpp.js"></script>
	<script type="text/javascript" src="/js/jquery.cookie.js"></script>
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    
 </head>
<body>
    <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:250px;" plain="false">
        <div name="first" title="保单基本信息">
            <table style="table-layout:fixed;" >
                <tr>
                    <td style="width:100px;"> 订单号：</td>
                    <td style="width:200px;">    
                        ${order.id!""}
                    </td>
                    <td style="width:100px;">路线：</td>
                    <td style="width:200px;">      
                        ${order.start_province_name!?html}${order.start_city_name!?html}${order.start_district_name!?html} -&gt;${order.end_province_name!?html}${order.end_city_name!?html}${order.end_district_name!?html}
                    </td>
                </tr>
              <tr>
                    <td style="width:100px;"> 货物名称：</td>
                    <td style="width:200px;">    
                      ${order.cargo_desc!?html}
                    </td>
                    <td style="width:100px;">货物类别：</td>
                    <td style="width:200px;">
                         ${order.cargo_type_name!?html}
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">车型：</td>
                    <td style="width:200px;">    
                        ${order.car_type!?html}
                    </td>
                    <td style="width:100px;">车长：</td>
                    <td style="width:200px;">      
                        ${order.car_length!?html}米
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">货物数量：</td>
                    <td style="width:200px;">    
                        ${order.cargo_number!""}${order.cargo_unit_name!?html}
                    </td>
                    <td style="width:100px;"></td>
                    <td style="width:200px;">
                    </td>
                    
                </tr>
                 <tr>
                    <td style="width:100px;">单价：</td>
                    <td style="width:200px;">
                        ${order.unit_price!"0"}元/每${order.cargo_unit_name!?html}
                    </td>
                    <td style="width:100px;">总价：</td>
                    <td style="width:200px;">
                        ${order.price?string("0")}元
                    </td>
                </tr>
                <tr>
                    <td style="width:120px;">信息已推送给：</td>
                    <td style="width:200px;">    
                        ${order.push_drvier_count!"0"} 位司机
                    </td>
                    <td style="width:100px;">共有：</td>
                    <td style="width:200px;">     
                        ${order.vie_driver_count!"0"}位司机抢单
                    </td>
                </tr>
                <tr >
                 <td >备注：</td>
                    <td colspan=3>   
                        ${order.remark!?html}    
                    </td>
                </tr>
            </table>
        </div>
        <#if (driver?? && order.status == 99)>
        <div title="司机信息">
            <table style="table-layout:fixed;" >
                <tr>
                    <td style="width:100px;">司机姓名：</td>
                    <td style="width:200px;">    
                        ${driver.name!?html}
                    </td>
                    <td style="width:100px;">手机号码：</td>
                    <td style="width:200px;">
                        ${driver.phone!?html}
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">车牌号：</td>
                    <td style="width:200px;">    
                        ${driver.plate_number!?html}
                    </td>
                    <td style="width:100px;"></td>
                    <td style="width:200px;">
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">车型：</td>
                    <td style="width:200px;">    
                        ${driver.car_type_name!?html}
                    </td>
                    <td style="width:100px;">车长：</td>
                    <td style="width:200px;">
                        ${driver.car_length!?html}
                    </td>
                </tr>
                <tr>
                    <td style="width:100px;">载重：</td>
                    <td style="width:200px;">    
                        ${driver.car_weight!?html}吨
                    </td>
                    <td style="width:100px;"></td>
                    <td style="width:200px;">
                    </td>
                </tr>
            </table>
        </div>
        </#if>
        <div title="变更记录">
            <div class="mini-fit">
                <div id="datagrid" class="mini-datagrid" style="width:100%;height:100%;"  url="/order/queryOrderLog/${order.id}" allowResize="true" idField="id" multiSelect="true" allowAlternating="true" showPager="false">
                    <div property="columns">
                        <div field="id" allowSort="true" width="40">
                            编号
                        </div>
                        <div field="operator" width="80">
                            人员
                        </div>
                        <div field="operation">
                            操作
                        </div>
                        <div field="create_time">
                            时间
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<script>
    mini_debugger = false;
    mini.parse();
    var grid = mini.get("datagrid");
    grid.load();
</script>
</body>
</html>