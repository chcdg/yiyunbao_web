<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
    <script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    <script type="text/javascript" src="/js/jquery.raty.min.js"></script>
 </head>
<body>
        <div style="padding-left:11px;padding-bottom:5px;">
            
        </div>
        <div class="mini-panel" title="货单信息" style="width:600px;" showCollapseButton="true">
            <table style="table-layout:fixed;" >
                <tr>
                    <td style="width:100px;"> 订单号：</td>
                    <td style="width:200px;">    
                        ${order.id!""}
                    </td>
                    <td style="width:100px;">线路：</td>
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
                    <td style="width:100px;">货物数量：</td>
                    <td style="width:200px;">    
                        ${order.cargo_number!}${order.cargo_unit_name!?html}
                    </td>
                    <td style="width:100px;"></td>
                    <td style="width:200px;">
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">单价：</td>
                    <td style="width:200px;">
                        ${order.unit_price?string("0")}元/每${order.cargo_unit_name!?html}
                    </td>
                    <td style="width:100px;">总价：</td>
                    <td style="width:200px;">
                        ${order.price?string("0")}元
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
        <div class="mini-panel" title="司机信誉评价" style="width:600px;" showCollapseButton="true">
            <form id="form1" method="post">
                <input name="order_id" class="mini-hidden" value="${order.id}"/>
                <table style="table-layout:fixed;" >
                    <tr>
                        <td style="width:100px;">履约诚信度：</td>
                        <td style="width:200px;">
                            <#-- <div id="myscore1"></div>
                            <input id="score1" name="score1" class="mini-hidden"/> -->
                            <div name="score1" class="mini-radiobuttonlist" repeatItems="5" repeatLayout="table" repeatDirection="horizontal"
                                textField="text" valueField="id" value="5"
                                data="[{id:1, text:'1'},{id:2, text:'2'},{id:3, text:'3'},{id:4, text:'4'},{id:5, text:'5'}]">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:100px;">运输准时率：</td>
                        <td style="width:200px;">
                            <#-- <div id="myscore2"></div>
                            <input id="score2" name="score2" class="mini-hidden"/> -->
                            <div name="score2" class="mini-radiobuttonlist" repeatItems="5" repeatLayout="table" repeatDirection="horizontal"
                                textField="text" valueField="id" value="5"
                                data="[{id:1, text:'1'},{id:2, text:'2'},{id:3, text:'3'},{id:4, text:'4'},{id:5, text:'5'}]">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:100px;">服务态度：</td>
                        <td style="width:200px;">
                            <#-- <div id="myscore3"></div>
                            <input id="score3" name="score3" class="mini-hidden"/> -->
                            <div name="score3" class="mini-radiobuttonlist" repeatItems="5" repeatLayout="table" repeatDirection="horizontal"
                                textField="text" valueField="id" value="5"
                                data="[{id:1, text:'1'},{id:2, text:'2'},{id:3, text:'3'},{id:4, text:'4'},{id:5, text:'5'}]">
                            </div>
                        </td>
                    </tr>
                    <tr>
                         <td colspan="2">
                            <textarea class="mini-textarea" emptyText="详细评价" name="reply_content" style="width:100%;height:80px;"></textarea>
                         </td>
                    </tr>
                    <tr>
                         <td colspan="2">
                            <a class="mini-button" onclick="rating()" plain="false" iconCls="icon-edit">评价</a>
                         </td>
                      </tr>
                </table>
            </form>
        </div>
    </div>


<script>
    mini_debugger = false;
    mini.parse();
    var form1 = new mini.Form("form1");

    function rating() {
        var o = form1.getData();
        form1.validate();
        if (form1.isValid() == false) return;

        $.jBox.tip("正在评论，请稍候...", 'loading');
        
        $.ajax({
            url: "/order/do_rating_to_driver",
            type: "POST",
            dataType: "json",
            data: o,
            success: function(response,status){
                if(!response.success){
                    $.jBox.tip(response.data);
                }
                else{
                    $.jBox.tip('评价成功.');
                    CloseWindow();
                }
            },
            error: function(response){
                $.jBox.tip('评价失败:' + response.responseText);
            }
        });
    }
    function CloseWindow(action) {
        if (window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
        else window.close();            
    }

    $(function() {
        //评价插件有问题，暂不使用
        $.fn.raty.defaults.path = '/images/rate';
        // $('#myscore1').raty({
        //     score : 0,
        //     click: function(score, evt) {
        //         //alert('ID: ' + $(this).attr('id') + "\nscore: " + score + "\nevent: " + evt);
        //         //mini.get("score1").setValue(score);
        //     }
        // });
        // $('#myscore2').raty({
        //     score : 0,
        //     click: function(score, evt) {
        //         //mini.get("score2").setValue(score);
        //     }
        // });
        // $('#myscore3').raty({
        //     score : 0,
        //     click: function(score, evt) {
        //         //mini.get("score3").setValue(score);
        //     }
        // });
    });

</script>
</body>
</html>