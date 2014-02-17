<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <script type="text/javascript" src="/js/jBox/jquery.jBox-2.3.min.js"></script>
    <script type="text/javascript" src="/js/jBox/i18n/jquery.jBox-zh-CN.js"></script>
	<script type="text/javascript" src="/js/jquery.xmpp.js"></script>
	<script type="text/javascript" src="/js/jquery.cookie.js"></script>
    <link rel="stylesheet" href="/js/fancybox/jquery.fancybox.css" type="text/css" media="screen" />
    <script type="text/javascript" src="/js/fancybox/jquery.fancybox.pack.js"></script>
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    <script type="text/javascript" src="/js/jquery.raty.min.js"></script>
    <style type="text/css">
.conversation {
	height:150px;
	overflow: auto;
	color: #25282b;
	background-color: #FFF;
	opacity: 0.9;
	-moz-opacity: 0.9;
	filter:alpha(opacity=9);
}
.myCurMsg {	
    border: solid 1px silver;
    height: 30px;
    width: 300px;
    margin-bottom: 5px;
    margin: 5px;
}

.msgBlock {
	border-bottom: solid 1px silver;
	padding: 5px;
}
.chatter_name {
	font-weight: bold;
}
    </style>
    <link rel="stylesheet" href="/css/chat.css" type="text/css"/>
 </head>
<body>
    <div id="tabs1" class="mini-tabs" activeIndex="0" style="width:100%;height:300px;" plain="false">
        <div name="first" title="货单基本信息">
            <div class="mini-toolbar" style="padding:2px;margin-bottom:10px;">
                回单密码：${order.receipt_password!}
            </div>
            <table style="table-layout:fixed;" >
                <tr>
                    <td style="width:80px;"> 订单号：</td>
                    <td style="width:150px;">    
                        ${order.id!""}
                    </td>
                    <td style="width:80px;">路线：</td>
                    <td style="width:250px;" nowrap >      
                        ${order.start_province_name!?html}${order.start_city_name!?html}${order.start_district_name!?html} -&gt;${order.end_province_name!?html}${order.end_city_name!?html}${order.end_district_name!?html}
                    </td>
                    <td sytle="width: 100px" rowspan="8">
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
              <tr>
                    <td> 货物名称：</td>
                    <td>    
                      ${order.cargo_desc!?html}
                    </td>
                    <td>货物类别：</td>
                    <td>
                         ${order.cargo_type_name!?html}
                    </td>
                    <td></td>
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
                    <td></td>
                </tr>
                <tr>
                    <td>货物数量：</td>
                    <td>    
                        ${order.cargo_number!""}${order.cargo_unit_name!?html}
                    </td>
                    <td>总价：</td>
                    <td>
                        ${order.price?string("0")}元
                    </td>
                    <td></td>
                </tr>
                <tr >
                    
                     <td >货单状态：</td>
                    <td>   
                    	
                        <#if execute_status == -1>
                        	暂无
                        <#elseif execute_status == 1>    
                        	到达装货位置
                        <#elseif execute_status == 2>    
                        	启程
                        <#elseif execute_status == 3>    
                        	在途
                        <#elseif execute_status == 4>    
                        	到达目的地
                        <#elseif execute_status == 5>    
                        	卸货
                        <#elseif execute_status == 6>    
                        	回单密码
                        </#if>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td >
                        最近位置：
                    </td>
                    <td colspan="3" style="background:#dddd00;">
                        ${driver.last_position!""}
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <a class="mini-button " iconCls="icon-find" onclick="gpsLocation(0)" >免费定位</a>
                        <a class="mini-button " iconCls="icon-search" onclick="phoneLocation()" >手机定位</a>
                    </td>
                </tr>
            </table>
        </div>
        <div title="司机信息">
            <div class="mini-toolbar" style="padding:2px;margin-bottom:10px;">
                <a class="mini-button" onclick="gpsLocation" plain="true">提示司机汇报位置</a>
            </div>
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
                 <tr>
                    <td style="width:100px;">信誉评价：</td>
                    <td style="width:200px;">    
                       <div id="myscore"></div>
                    </td>
                    <td style="width:100px;">履约诚信度</td>
                    <td style="width:200px;">
                    	<div id="myscore1"></div>
                    </td>
                </tr>
                 <tr>
                    <td style="width:100px;">运输准时率：</td>
                    <td style="width:200px;">    
                        <div id="myscore2"></div>
                    </td>
                    <td style="width:100px;">服务态度</td>
                    <td style="width:200px;">
                    	<div id="myscore3"></div> 
                    </td>
                </tr>
            </table>
        </div>
        <div title="聊天">
            <div class="widget-body">
                <div class="widget-main no-padding">
                    <div style="position: relative; overflow-x: hidden; overflow-y: auto; width: auto; height: 200px;" class="slimScrollDiv" id="slimScrollDiv">
                        <div style="width: auto; height: 200px;" class="dialogs" id="chatContent">
                        </div>
                    </div>

                    <div class="form-actions input-append">
                        <input type="text" name="message" class="width-75" placeholder="请输入聊天内容 ..." id="txtChat">
                        <button class="btn btn-small btn-info no-radius" id="btnSend" onclick="return false">
                            <span class="hidden-phone">发送</span>
                        </button>
                    </div>
                </div>
                <!--/widget-main-->
            </div>
        </div>
    </div>
    <div id="mapContainer" style="width:100%;height:350px;"></div>
</body>


<script>
    mini.parse();
    function gpsLocation(beginTime){
        $.jBox.tip("正在定位，请稍候...", 'loading');
        $.post("/mobileLocation/freeLocation",
        {
          mobile:'${driver.phone!""}',
          beginTime:beginTime,
          order_id: '${order.get("id")}'
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
            		$.jBox.tip("免费GPS定位失败，对方手机未及时响应，推荐您直接使用手机定位，或是尝试再次GPS定位");
            		mini.alert("免费GPS定位失败，对方手机未及时响应，推荐您直接使用手机定位，或是尝试再次GPS定位");
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
                      mobile:'${driver.phone!""}'
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
                            $.jBox.tip(response.data);
                        }
                     });
                } 
            }
        );
    }
</script>

<script>
function GET_PASSWORD(){
    return "${pwd!}";
}
function log(msg){
    if(typeof console != "undefined" && console.debug && jQuery.isFunction(console.debug)){
        console.debug(msg);
    }
}
$(function(){
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

    $(".fancybox").fancybox({
        'transitionIn'  : 'elastic',
        'transitionOut' : 'elastic',
    });
});
$(function(){

    function openChat(options){
        var id = options.to;
        log("openChat to=>" + id);

        var input = $("#txtChat");

        $("#btnSend").unbind('click');
        $("#btnSend").click(function(){
            var body = input.val();
            if($.trim(body) == ''){
                return;
            }
            var props = '<properties xmlns="http://www.jivesoftware.com/xmlns/xmpp/properties">';
            props += '<property>';
            props += '<name>msgId</name>';
            props += '<value type="long">' + new Date().getTime() + '</value>';
            props += '</property>';
            props += '<property>';
            props += '<name>msgType</name>';
            props += '<value type="integer">1</value>';
            props += '</property>'
            props += '</properties>';
            $.xmpp.sendMessage({to:options.to, body: body, resource:"webchat"}, props);
            log("send to=>" + options.to);

            var fromId = $.xmpp.jid.split('@')[0];

            writeMsg('我', new Date().getTime(), body, 1, '/images/avatar_user.png');

            input.val("");

            return false;
        });
    }
    function onReceiveMessage(driver,message,jid,uid){
        var data = message.data;
        log(data);
        var msgId = parseInt(getMsgProp(data, 'msgId'));
        var msgType = getMsgProp(data, 'msgType');
        log("msgId=>" + msgId + ",msgType=>" + msgType);

        writeMsg(driver, msgId, message.body, msgType, '/images/avatar_driver.png');
    }
    function writeMsg(name, msgId, body, msgType, avatar){
        var reval  = '';
        reval += '<div class="itemdiv dialogdiv">';
        reval += '    <div class="user">';
        reval += '        <img src="' + avatar + '" alt="' + name + '"/>';
        reval += '    </div>';
        //reval += '<br />';
        reval += '    <div class="body">';
        reval += '        <div class="time">';
        reval += '            <i class="icon-time"></i>';
        reval += '            <span class="blue">' + mini.formatDate(new Date(msgId),'HH:mm:ss') + '</span>';
        reval += '        </div>';
        //reval += '<br />';
        reval += '        <div class="name">';
        reval += '            <a href="javascript:;">' + name + '</a>';
        //reval += '<span class="label label-info arrowed arrowed-in-right">司机</span>';
        reval += '        </div>';
        reval += '        <div class="text">';
        if(msgType == 1){
            reval += body;
        }else if(msgType == 2){//图片
            reval += '<a id="' + msgId + '" rel="msgimg" href="' + body + '" ><img src="' + body + '" style="width:24px;height:24px;" alt="聊天图片" /></a>';
        }else if(msgType == 3){//语音 TODO
            // reval += '语音：<embed src="' + body + '" hidden="false" autostart="false" loop="false" controls="playbutton" width="150" height="25" ></embed>';
            reval += '语音：';
            reval += '<object width="250" height="25" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"><param name="quality" value="high" /><param name="wmode" value="transparent" /><param name="src" value="/flash/mp3player.swf?mp3=' + body + '&autostart=0&bgcolor=ffffff" /><param name="pluginspage" value="http://www.macromedia.com/go/getflashplayer" /><embed width="250" height="25" type="application/x-shockwave-flash" src="/flash/mp3player.swf?mp3=' + body + '&autostart=0&bgcolor=ffffff" quality="high" wmode="transparent" pluginspage="http://www.macromedia.com/go/getflashplayer" /> </object>'
        }
        reval += '        </div>';
        reval += '    </div>';
        reval += '</div>';

        var chatContent = $("#chatContent");
        chatContent.append(reval);
        $("#" + msgId).fancybox({
            'transitionIn'  : 'elastic',
            'transitionOut' : 'elastic',
        });
        var scrollDiv = $("#slimScrollDiv");
        scrollDiv.prop('scrollTop', chatContent.prop("scrollHeight"));
    }
    function getMsgProp(data, prop){
        var data = $(data);
        var value = data.find("property").filter(function(){
           return $('name', this).text() == prop;
        }).find("value").text();
        return value;
    }
    function initChat(){
        var server_name = "@${xmppdomain}";
        var jid = 'u' + '${user.id!?js_string}' + server_name;
        var password = GET_PASSWORD();
        
        log("initChat:" + jid + ":" + password);
    
        var url ="http://${xmppserver}/http-bind";
        $.xmpp.connect({url:url, jid: jid, password: password,
            onConnect: function(){
                log("Connected");
                $.xmpp.setPresence(null);
                var driver = 'd' + '${driver.id!?js_string}' + server_name;
                openChat({to: driver});
            },
            onPresence: function(presence){
                log("onPresence");
            },
            onDisconnect: function(){
                log("Disconnected");
                initChat();
            },
            onMessage: function(message){
                log("onMessage");
                log(message);
                window.debug_message = message; //for debug
            
                var jid = message.from.split("/");
                var id = MD5.hexdigest(message.from);

                if (message.body == null) {
                    //writeMsg("${driver.name!?js_string} - 正在输入…", "输入中…");
                    return;
                }

                var uid = jid[0].split('@')[0];
                var driverJid = 'd' + '${driver.id!?js_string}';
                if(uid != driverJid){
                    log("uid=" + uid + ",driverJid=" + driverJid + ",ignore message:" + message.body);
                    return; //TODO 把消息存起来
                }
                onReceiveMessage('${driver.name!?js_string}', message, jid, uid)
            },
            onError:function(error){
                log(error.error);
                //writeMsg("error",error.error);
            }
        });
    }
    initChat();//初始化聊天

    $("#disconnectBut").click(function(){
        $.xmpp.disconnect();
    });

    $(".myCurMsg").live('keyup', function(event){
        if(event.keyCode == 13){
            $(".chatBox_curmsg .btn_sendMsg").click();
        }
    });

});


// $(document).ready(function(){

//  function writeMsg(title,msg){
//      var conversation = $("#conversation");
//      var current_message = "<div class = 'msgBlock'><span class = 'chatter_name'>"+ title +": </span><br>"  + msg +"</div>"
//      conversation.append(current_message);
//      conversation.prop('scrollTop', conversation.prop("scrollHeight"));
//  }
//  function initChat(){
//      var server_name = "@www.1yunbao.com";
//      var jid = 'u' + '${user.id!?js_string}' + server_name;
//      var password = GET_PASSWORD();
//      var contactList = $("#contacts");
        
//      log(jid + "," + password);
    
//      var url ="http://www.1yunbao.com/http-bind";
//      $.xmpp.connect({url:url, jid: jid, password: password,
//          onConnect: function(){
//              log("Connected");
//              $.xmpp.setPresence(null);
//              var driver = 'd' + '${driver.id!?js_string}' + server_name;
//              openChat({to: driver});
//          },
//          onPresence: function(presence){
//              log("onPresence");
//          },
//          onDisconnect: function(){
//              log("Disconnected");
//          },
//          onMessage: function(message){
//              log("onMessage");
//              log(message);
            
//              var jid = message.from.split("/");
//              var id = MD5.hexdigest(message.from);
//              var conversation = $("#conversation");
                
//              //conversation.find(".conversation").append("<div>"+ jid[0] +": "+ message.body +"</div>");

//              if (message.body == null) {
//                  writeMsg("${driver.name!?js_string} - 正在输入…", "输入中…");
//                  return;
//              }
                
//              var uid = jid[0].split('@')[0];
//              var driverJid = 'd' + '${driver.id!?js_string}';
//              if(uid != driverJid){
//                  log("uid=" + uid + ",driverJid=" + driverJid + ",ignore message:" + message.body);
//                  return; //TODO 把消息存起来
//              }

//              var current_message = "<div class = 'msgBlock'><span class = 'chatter_name'>"+ '${driver.name!?js_string}' +": </span><br>"  + message.body +"</div>"

//              conversation.append(current_message);
//              conversation.prop('scrollTop', conversation.prop("scrollHeight"));
            
//          },
//          onError:function(error){
//              log(error.error);
//              //writeMsg("error",error.error);
//          }
//      });
//  }
//  initChat();//初始化聊天

//  $("#disconnectBut").click(function(){
//      $.xmpp.disconnect();
//  });

//  $(".myCurMsg").live('keyup', function(event){
//      if(event.keyCode == 13){
//          $(".chatBox_curmsg .btn_sendMsg").click();
//      }
//  });
    
//          $.fn.raty.defaults.path = '/images/rate';
//      $('#myscore1').raty({
//          score : ${driver.score1},
//          readOnly : true
//      });
//      $('#myscore2').raty({
//          score : ${driver.score2},
//          readOnly : true
//      });
//      $('#myscore3').raty({
//          score : ${driver.score3},
//          readOnly : true
//      });
//      $('#myscore').raty({
//          score : ${driver.score},
//          readOnly : true
//      });

//         $(".fancybox").fancybox({
//             'transitionIn'  : 'elastic',
//             'transitionOut' : 'elastic',
//         });

// });


// function openChat(options){
//  //var id = MD5.hexdigest(options.to);
//  var id = options.to;
//  log("openChat " + id);

//  var chat = $("#chatWindow");
//  var input = chat.find("input");
//  var sendBut = chat.find("button.btn_sendMsg");
//  var conversation = chat.find("#conversation");
//  sendBut.click(function(){
//      var props = '<properties xmlns="http://www.jivesoftware.com/xmlns/xmpp/properties">';
//      props += '<property>';
//      props += '<name>msgId</name>';
//      props += '<value type="long">' + new Date().getTime() + '</value>';
//      props += '</property>';
//      props += '<property>';
//      props += '<name>msgType</name>';
//      props += '<value type="integer">1</value>';
//      props += '</property>'
//      props += '</properties>';
//      $.xmpp.sendMessage({to:options.to, body: input.val(), resource:"webchat"}, props);
//      log("to:" + options.to);
//      //conversation.append("<div>"+ $.xmpp.jid +": "+ input.val() +"</div>");
//      var fromId = $.xmpp.jid.split('@')[0];

//      var current_message = "<div class = 'msgBlock'><span class = 'chatter_name'>"+ '${user.name!?js_string}' +": </span><br>"  + input.val() +"</div>"

//      conversation.append(current_message);
//      conversation.prop('scrollTop', conversation.prop("scrollHeight"));
//      input.val("");
//  });

//  //$(chat).css('position', 'absolute');
//  //$(chat).css('z-index', 1000);
//  //$(chat).css('top', $(window).height() - 220);
//  $(chat).css('float', 'left');
//  $(chat).css('margin-left', '10px');

//  $(chat).show();
// }
</script>
<!--引用百度地图API-->
<script type="text/javascript" src="http://api.map.baidu.com/api?key=&v=1.2&services=true"></script>
<script type="text/javascript" src="/js/baiduMap/MarkerTool.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/library/TextIconOverlay/1.2/src/TextIconOverlay_min.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/library/DistanceTool/1.2/src/DistanceTool_min.js"></script>
<script>

    var long = ${driver.longitude!""};
    var la = ${driver.latitude!""};
    var driverName = '${driver.name!""}';

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
                var content = "<table>"
                content += "<tr><td>单号：${order.id!""}</td></td>";
                content += "<tr><td>司机姓名：${driver.name!""}</td></tr>";
                content += "<tr><td>司机电话：${driver.phone!""}</td></tr>";
                content += "<tr><td>车牌号码：${driver.plate_number!""}</td></tr>";
                content+= '<tr><td>最近定位位置：' + address + "</td></tr>";
                content+= '<tr><td>最近定位时间：' + last_time + "</td></tr>";
                content+= '<tr><td><a href="javascript:gpsLocation()">免费定位</a> ';
                content+= '<a href="javascript:phoneLocation()">手机定位</a></td></tr>';
                content += "</table>";
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
</script>
</html>