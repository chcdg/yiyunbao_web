<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="../js/boot.js"></script>
	<style type="text/css">
		html, body
	    {
	        font-size:12px;
	        padding:0;
	        margin:0;
	        border:0;
	        height:100%;
	        overflow:hidden;
	    }
        .area {
            padding:5px;
        }
        .area li{
            list-style: none;
            float: left;
            margin: 3px;
        }
        table.form-table{
            table-layout:fixed;
        }
        table.form-table,
        table.form-table tbody,
        table.form-table tr,
        table.form-table td{
            padding: 0;
            margin: 0;
        }
        
        #xuan_tian_div{
       		cursor: hand; 
       		cursor:pointer;
       	}
        
        /*去除ie10下的placeholder重影*/
        input:-ms-input-placeholder {
            color:#fff;
        }
       	.a_name {text-decoration: none;} 
       	.a_name {color:#990033;}
       	.m_name {color:#666633}
	</style>
 </head>
<body>
<form id="form1" action="/order/doPublishOrder"  method="post" enctype="multipart/form-data">
		<div id="tip_div" class="mini-toolbar" style="height:20px;margin-top:10px;color:#CC00FF;font-size:14px;border:0px solid;" align="center">
			模板发货更轻松：填完信息后点击下方 设为模板 按钮，下次发货自动填写货单！
		</div>
        <fieldset style="border:solid 1px #aaa;padding:10px;">
                <legend>货单信息</legend>
                <table  style="line-height:25px;" border="0" width="100%">
                    <tr>
                        <td align="right">
                        	<b>出发地：</b>
                            <input id="start_point" name="start_point" class="mini-hidden"/>
                        </td>
                        <td>
                            <input id="start_province" name="start_province" class="mini-textbox" onfocus="onSelectStartProvince" emptyText="省/直辖市" required="false"/>
                            <input id="start_province_id" name="start_province_id" class="mini-hidden"/>
                        </td>
                        <td>
                            <input id="start_city" class="mini-textbox" onfocus="onSelectStartCity" emptyText="地市" />
                            <input id="start_city_id" name="start_city_id" class="mini-hidden"/>
                        </td>
                        <td >
                            <input id="start_district" class="mini-textbox" onfocus="onSelectStartDistrict" emptyText="区县"/>
                            <input id="start_district_id" name="start_district_id" class="mini-hidden"/>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                        	<b>目的地：</b>
                            <input id="end_point" name="end_point" class="mini-hidden"/>
                        </td>
                        <td>
                            <input id="end_province" class="mini-textbox" onfocus="onSelectEndProvince" emptyText="省/直辖市" required="false"/>
                            <input id="end_province_id" name="end_province_id" class="mini-hidden"/>
                        </td>
                        <td>
                            <input id="end_city" class="mini-textbox" onfocus="onSelectEndProvince" emptyText="地市" />
                            <input id="end_city_id" name="end_city_id" class="mini-hidden"/>
                        </td>
                        <td>
                            <input id="end_district" class="mini-textbox" onfocus="onSelectEndDistrict" emptyText="区县" />
                            <input id="end_district_id" name="end_district_id" class="mini-hidden"/>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>货物名称/类型：</b></td>
                        <td >
                            <input id="cargo_desc" name="cargo_desc" class="mini-textbox"  emptyText="请输入货物名称"/>
                        </td>
                        <td>
                            <input id="cargo_type" name="cargo_type" class="mini-combobox" textField="name" 
                            valueField="id" emptyText="请选择货物类型" url="/dict/getAllCargoType" showNullItem="false" />
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="5">
                    		<div onclick="change_div_show('content_id','show_text')" id="xuan_tian_div" style="width:auto; height:30px;;border:1px solid gray;background-color:#229FCE;" align="center">
                    			<a id="show_text"  style="color:blue">打开 > 发货详情（选填）</a>
                    		</div>
                    	</td>
                    </tr>
                    <tr>
                    	<td colspan="5">
                    		<!--隐藏div 发货详情选填字段 -->
                    		<div style="border: 1px solid #ccc;display:block;" id="content_id" >
                    			<table border="0" width="100%"  style="line-height:25px;">
                    				<tr>
			                        <td align="right">运输方式：</td>
			                        <td>
			                            <input id="ship_type" name="ship_type" class="mini-hidden"/>
			                            <a checkOnClick="true" groupName="ship_type" class="mini-button" onclick="onShipChanged"  value="57" checked="true">整车</a>
			                            <a id="ship_type_58" checkOnClick="true" groupName="ship_type" class="mini-button" onclick="onShipChanged"  value="58">零担</a>
			                        </td>
			                    </tr>
			                    <tr>
			                        <td align="right">体积重量：</td>
			                        <td >
			                            <input id="cargo_unit" name="cargo_unit" class="mini-hidden"/>
			                            <table stle="table-layout:fixed;" class="form-table">
			                                <tr>
			                                    <td>
			                                        <input id="cargo_number" name="cargo_number" class="mini-spinner" value="0"  maxValue="20000" decimalPlaces="2" onvaluechanged="updateTotalPrice"/>
			                                    </td>
			                                    <td>
			                                        <a checkOnClick="true" groupName="cargo_unit_group" class="mini-button" oncheckedchanged="onCargoUnitChanged" value="2" checked="true">吨</a>
			                                        <a checkOnClick="true" groupName="cargo_unit_group" class="mini-button" oncheckedchanged="onCargoUnitChanged" value="3">方</a>
			                                        <a checkOnClick="true" groupName="cargo_unit_group" class="mini-button" oncheckedchanged="onCargoUnitChanged" value="1">车</a>
			                                    </td>
			                                </tr>
			                            </table>
			                        </td>
			                        <td align="right">运输价格：</td>
			                        <td>
			                            <table stle="table-layout:fixed;" class="form-table">
			                                <tr>
			                                    <td>
			                                        <input id="unit_price" name="unit_price" class="mini-spinner"  value="0"  maxValue="5000000" decimalPlaces="2" onvaluechanged="updateTotalPrice"/>
			                                    </td>
			                                    <td>元/<span id="cargo_unit_div">吨</span></td>
			                                </tr>
			                            </table>
			                        </td>
			                    </tr>
			                    <tr>
			                        <td align="right">车长：</td>
			                        <td>
			                            <table stle="table-layout:fixed;">
			                                <tr>
			                                    <td>
			                                        <input id="car_length" name="car_length" class="mini-spinner" value="0" required="true" maxValue="200" decimalPlaces="2"/>
			                                    </td>
			                                    <td>米</td>
			                                </tr>
			                            </table>
			                        </td>
			                        <td align="right">车型：</td>
			                        <td>
			                            <input id="car_type" name="car_type" class="mini-combobox" textField="name" 
			                            valueField="id" emptyText="请选择货车车型" url="/dict/getAllCarType"  showNullItem="false"/>
			                        </td>
			                    </tr>
			                    <tr>
			                        <td align="right">装车时间：</td>
			                        <td colspan="1">
			                            <input id="loading_time" name="loading_time" class="mini-datepicker" format="yyyy-MM-dd HH:mm:ss" timeFormat="H:mm" showTime="true"  emptyText="请选择日期" />
			                                &nbsp;之前
			                        </td>
			                        <td align="right">货物照片：</td>
			                        <td>
			                            <input id="cargo_photo1_upload" name="cargo_photo1" class="mini-htmlfile"/>
			                        </td>
			                    </tr>
			                    <tr>
			                        <td align="right">保证金：</td>
			                        <td>
			                            <input id="user_bond" name="user_bond" class="mini-spinner" value="0" minValue="0" maxValue="10000"   vtype="int" increment="1" /> 元
			                        	&nbsp;&nbsp;<label style="color:#FF4000;">当前余额<span id="gold">${user.gold!?string("0.00")}</span>元</label>
			                        </td>
			                    </tr>
                    			</table>
                    		</div>
                    	</td>
                    </tr>
                    <tr>
                        <td align="right"><b>货单说明：</b></td>
                        <td colspan="4">
                            <input id="cargo_remark" name="cargo_remark" class="mini-textarea" style="width:450px;" />
							<br><font color="green" size="2">(温馨提示：货单信息越完整，越容易获得车主及司机的信赖！)</font>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><b>联系人：</b></td>
                        <td>
                            <input id="cargo_user_name" name="cargo_user_name" class="mini-textbox" id="concat" emptyText="${user.name!user.company_name!?html}"/>
                        </td>
                        <td align="right"><b>联系手机：</b></td>
                        <td>
                            <input id="cargo_user_phone" name="cargo_user_phone" class="mini-textbox" id="concat_telphone" emptyText="${user.phone!?html}"/>
                        </td>
                    </tr>
                    <td align="right"><b>货单有效时间：</b></td>
                        <td colspan="4">
                            <table stle="table-layout:fixed;">
                                <tr>
                                    <td>
                                        <input id="validate_day" class="mini-spinner" style="width:50px;" value="0" minValue="0" maxValue="60" />
                                    </td>
                                    <td>天</td>
                                    <td>
                                        <input id="validate_hour" class="mini-spinner" style="width:50px;" value="10" minValue="0" maxValue="24" />
                                        <input id="validate_time" name="validate_time" class="mini-hidden"/>
                                    </td>
                                    <td>小时</td>
                                </tr>
                            </table>
                        </td>
                </table>
        </fieldset>
        <div style="text-align:center;padding:15px;">               
        	<label id="lab1"><a class="mini-button" iconCls="icon-goto" onclick="setTemplet" style="width:100px;margin-right:10px;display:inline">设为模板</a></label>
        	<a class="mini-button" iconCls="icon-ok" onclick="onOk" style="width:100px;margin-right:10px;">发布货单</a>
        	<a class="mini-button" iconCls="icon-cancel" onclick="onCancel" style="width:100px;">取消</a>
        </div>        
    </form>
    <div id="areaWindow" class="mini-window" title="地区选择" style="width:430px;height:320px;" showFooter="true" 
    showModal="true" allowResize="false" allowDrag="false">
        <ul class="area">
        </ul>
        <div property="footer" style="text-align:right;padding:5px;padding-right:15px;">
            <input type="button" value='清除选择' onclick="clearArea()" style='vertical-align:middle;'/>
            <input type='button' value='关闭' onclick="hideWindow()" style='vertical-align:middle;'/>
        </div>
    </div>
    <script type="text/javascript">
	    mini_debugger = false;
	    mini.parse();
	    var form = new mini.Form("form1");
	    var areaWindow = mini.get("areaWindow");
	
	
	    function hideWindow(){
	        areaWindow.hide();
	    }
    	
    
		/**解决图片上传按钮页面加载不显示的问题*/
    	window.onload = function(){
    		var div = document.getElementById("content_id");
    		div.style.display = "none";
    		
    		initTempletName();
    	}
    	
        /**显示 隐藏选填字段*/
        function change_div_show(targetId,obj){
	      	var target_id = document.getElementById(targetId);
	      	var content = document.getElementById(obj)
	      	content.style.color="blue";
	      		
            if (target_id.style.display=="block"){
                target_id.style.display="none";
                content.innerText="打开 > 发货详情（选填）";
            } else {
                target_id.style.display="block";
                content.innerText="关闭 > 发货详情（选填）";
            }
		}
        
        /**初始化模板名称，如果登录用户没有模板则显示提示语句*/
        function initTempletName(){
        	$.ajax({
                url: "/order/findOrderTempletByUserId",
                success: function (data) {
        			var tip_div = document.getElementById("tip_div");
        			if("" != data && null != data){
        				tip_div.innerHTML = "<b style='color:red;'>最新模板：</b>";
//        				var name = "";
        				for(var i=0;i<data.length;i++){
        					var name = data[i];
        		        	tip_div.innerHTML += "<span  style='border:0px solid gray;width:10px;'>" +
        		        			"<a class='a_name' href=javascript:showProperties('"+name+"')>"+name+"</a>" +
        		        					"<img name='"+name+"' id='del_img' src='/images/del.png' style='display:none' onclick='del(this.name)' />" +
        		        							"</span>&nbsp;&nbsp;&nbsp;";
        				}
        				tip_div.innerHTML += "<a class='m_name' href='#'  onclick='manage()' style='width:80px;'><模板管理></a>";
        			}
        			else{
        				tip_div.innerHTML = "模板发货更轻松：填完信息后点击下方 设为模板 按钮，下次发货自动填写货单！";
        			}
                }
            });
        }
        
        /**模板管理*/
        function manage(){
        	var tip_div = document.getElementById("tip_div");
        	var del_img = document.getElementById("del_img");
        	var span = tip_div.getElementsByTagName('span');
        	var a = tip_div.getElementsByTagName('a');
        	var img = tip_div.getElementsByTagName('img');
        	if(del_img.style.display == "inline"){
        		for(var i=0;i<span.length;i++){
            		span[i].style.border = "0px solid gray";
            		a[i].setAttribute("className","a_name");
            		img[i].style.display = "none";
            	}
        	}else{
        		for(var i=0;i<span.length;i++){
            		span[i].style.border = "1px solid gray";
            		a[i].setAttribute("className","a_name");
            		img[i].style.display = "inline";
            	}
        	}
        }
        
        /**删除模板*/
        function del(tem_name){
        	$.ajax({
        		type: "POST",
                url: "/order/delOrderTempletByName?tem_name="+encodeURIComponent(tem_name),
                success: function (text) {
        			$("#tip_div").html();
        			initTempletName();
                },
                error: function (text) {
                	mini.alert("删除失败，请稍后再试");
                }
            });
        }
        
        /**用户点击名称，把模板的内容覆盖页面的表单*/
        function showProperties(tem_name){
        	var btnLab = document.getElementById("lab1");
        	btnLab.style.display = "none";
        	
        	$.ajax({
                url: "/order/findOrderTempletByName?tem_name="+encodeURIComponent(tem_name),
                success: function (data) {
        			//出发地 省
        			mini.get("start_province").setValue(data.start_province_name);
        			mini.get("start_province_id").setValue(data.start_province);
        			//出发地 市
        			mini.get("start_city").setValue(data.start_city_name);
        			mini.get("start_city_id").setValue(data.start_city);
        			//出发地 区县
        			mini.get("start_district").setValue(data.start_district_name);
        			mini.get("start_district_id").setValue(data.start_district);
        			//目的地 省
        			mini.get("end_province").setValue(data.end_province_name);
        			mini.get("end_province_id").setValue(data.end_province);
        			//目的地 市
        			mini.get("end_city").setValue(data.end_city_name);
        			mini.get("end_city_id").setValue(data.end_city);
        			//目的地 区县
        			mini.get("end_district").setValue(data.end_district_name);
        			mini.get("end_district_id").setValue(data.end_district);
        			
        			mini.get("cargo_desc").setValue(data.cargo_desc);
        			mini.get("cargo_type").setValue(data.cargo_type);
        			mini.get("ship_type").setValue(data.ship_type);
        			if(data.ship_type == 58){
//        				mini.get("ship_type_58").setValue(checked="true");
        			}
        			mini.get("cargo_number").setValue(data.cargo_number);
        			mini.get("unit_price").setValue(data.unit_price);
        			mini.get("car_length").setValue(data.car_length);
        			mini.get("car_type").setValue(data.car_type);
        			mini.get("loading_time").setValue(data.loading_time);
        			mini.get("cargo_remark").setValue(data.cargo_remark);
        			mini.get("user_bond").setValue(data.user_bond);
        			mini.get("cargo_user_name").setValue(data.cargo_user_name);
        			mini.get("cargo_user_phone").setValue(data.cargo_user_phone);
                }
            });
        }
        
        /**设置模板*/
        function setTemplet(){
        	//出发地（省市区）
        	var start_province = mini.get("start_province_id").getValue();
        	var start_province_name = mini.get("start_province").getValue();
        	var start_city = mini.get("start_city_id").getValue();
        	var start_city_name = mini.get("start_city").getValue();
        	var start_district = mini.get("start_district_id").getValue();
        	var start_district_name = mini.get("start_district").getValue();
        	//目的地（省市区）
        	var end_province = mini.get("end_province_id").getValue();
        	var end_province_name = mini.get("end_province").getValue();
        	var end_city = mini.get("end_city_id").getValue();
        	var end_city_name = mini.get("end_city").getValue();
        	var end_district = mini.get("end_district_id").getValue();
        	var end_district_name = mini.get("end_district").getValue();
        	if(start_province == ""){
                mini.alert("设置模板，请选择起始地点.");
                return;
            }
            if(end_province == ""){
                mini.alert("设置模板，请选择目的地点.");
                return;
            }
            //货物名称
            var cargo_desc = mini.get("cargo_desc").getValue();
            //货物类型
            var cargo_type = mini.get("cargo_type").getValue();
            //运输方式
            ship_type = mini.get("ship_type").getValue();
            if(ship_type == ""){
            	var ship_type = 57;
            }
            //体积重量
            var cargo_number = mini.get("cargo_number").getValue();//数量
            var cargo_unit = mini.get("cargo_unit").getValue();//单位
            //运输价格
            var unit_price = mini.get("unit_price").getValue();
            //车长
            var car_length = mini.get("car_length").getValue();
            //车型
            var car_type = mini.get("car_type").getValue();
            //装车时间
            var loading_time = mini.get("loading_time").getValue();
            //货物照片
            
            //保证金
            var user_bond = mini.get("user_bond").getValue();
            //货单说明
            var cargo_remark = mini.get("cargo_remark").getValue();
            //联系人
            var cargo_user_name = mini.get("cargo_user_name").getValue();
            //联系电话
            var cargo_user_phone = mini.get("cargo_user_phone").getValue();
            var str = /^1[34589]\d{9}$/;
            if(null != cargo_user_phone && "" != cargo_user_phone){
            	if(!(str.test(cargo_user_phone))){
	             	mini.alert("手机号码格式不正确.");
	            	return;
            	}
            }
            //订单有效时间
            var validate_day = parseInt(mini.get("validate_day").getValue());
            var validate_hour = parseInt(mini.get("validate_hour").getValue());
            var validate_time = new Date().getTime() + (validate_day*24 + validate_hour)*60*60*1000;//将当前时间+有效的天数+有效小时
            
            var o = form.getData();
            
            //把地区名称和省市区对应的ID赋值给表单对象
            o.start_province_name = start_province_name;
            o.start_province = start_province;
            o.start_city_name = start_city_name;
            o.start_city = start_city;
            o.start_district_name = start_district_name;
            o.start_district = start_district;
            
            o.end_province_name = end_province_name;
            o.end_province = end_province;
            o.end_city_name = end_city_name;
            o.end_city = end_city;
            o.end_district_name = end_district_name;
            o.end_district = end_district;
            
            o.ship_type = ship_type;
            o.loading_time = loading_time;
            o.validate_time = validate_time;
            var json = mini.encode([o]);
            
            mini.prompt("模板名称(不超过5个汉字)：", "提醒 ",
                    function (action, value) {
                        if (action == "ok") {
                        	$.ajax({
                        		type: "POST",
                                url: "/order/addOrderTemplet?templetName="+encodeURIComponent(value),
                                data: { data: json},
                                cache: false,
                                success: function (text) {
                                	mini.alert(text);
                                	initTempletName();
                                },
                                error: function (text) {
                                	
                                	mini.alert("添加模板失败，请稍后再试");
                                }
                            });
                        }
                    }
                );
        }
        
        function SaveData() {
        	var o = form.getData();
        	
        	o.start_province = mini.get("start_province_id").getValue();
        	o.start_city = mini.get("start_city_id").getValue();
        	o.start_district = mini.get("start_district_id").getValue();
        	o.end_province = mini.get("end_province_id").getValue();
        	o.end_city = mini.get("end_city_id").getValue();
        	o.end_district = mini.get("end_district_id").getValue();
        	
        	if(o.start_province == ""){
        		mini.alert("请选择起始地点.");
        		return;
        	}
        	if(o.end_province == ""){
        		mini.alert("请选择目的地点.");
        		return;
        	}
        	//联系电话
        	var str =  /^0?(13[0-9]|15[012356789]|18[0236789]|14[57])[0-9]{8}$/;
        	var phone = o.cargo_user_phone;
        	if(null != phone && "" != phone){
        		if(!(str.test(phone))){
        			mini.alert("手机号码格式不正确.");
        			return;
        		}
        	}
        	var validate_day = parseInt(mini.get("validate_day").getValue());
        	var validate_hour = parseInt(mini.get("validate_hour").getValue());
        	var validate_time = new Date().getTime() + (validate_day*24 + validate_hour)*60*60*1000;//将当前时间+有效的天数+有效小时
        	o.validate_time = validate_time;
        	$("#validate_time").val(validate_time);
        	
        	if(o.cargo_unit == 1){
        		o.price = o.unit_price;
        	}else{
        		o.price = o.unit_price * o.cargo_number;
        	}
        	var gold = $("#gold").text();
        	if(o.user_bond > gold){
        		mini.confirm("当前保证金余额不足，余额总数:" + gold + "，要充值吗?", "温馨提示", function(action){
        			if(action == "ok"){
        				window.open("/pay");
        			}
        		});
        		return;
        	}
        	$("#form1").submit();
        }

        //清除所选地区
        function clearArea(){
            //hideWindow();       
            mini.get("start_point").setValue("");
            mini.get("start_province").setValue("");
            mini.get("start_province_id").setValue("");
            mini.get("start_city").setValue("");
            mini.get("start_city_id").setValue("");
            mini.get("start_district").setValue("");
            mini.get("start_district_id").setValue("");
            mini.get("end_point").setValue("");
            mini.get("end_province").setValue("");
            mini.get("end_province_id").setValue("");
            mini.get("end_city").setValue("");
            mini.get("end_city_id").setValue("");
            mini.get("end_district").setValue("");
            mini.get("end_district_id").setValue("");
            updateDistance();
        }

        /**开始地点*/
        function onSelectStartProvince(){
            areaWindow.showAtEl(document.getElementById("start_province"), {
                xAlign: "center",
                yAlign: "below"
            });
            var el = areaWindow.getBodyEl();
            var ul = $(el).find("ul");
            $.ajax({
                url: "/dict/getProvinceList",
                dataType: "json",
                success: function(json){
                    ul.empty();
                    var str = [];
                    for(var i = 0; i < json.length; i++){
                        var province = json[i];
                        str.push('<li><a class="mini-button start_province_btn" style="width:70px;" href="javascript:;" area_id="' + province.id + '"><span class="mini-button-text">' + province.short_name + '</span></a></li>');
                    }
                    ul.append(str.join("\n"));
                }
            });
        }

        function onSelectStartCity(){
            var province_id = mini.get("start_province_id").getValue() || 0;
            if(!province_id){
                onSelectStartProvince();
                return;
            }
            areaWindow.showAtEl(document.getElementById("start_city"), {
                xAlign: "center",
                yAlign: "below"
            });
            var el = areaWindow.getBodyEl();
            var ul = $(el).find("ul");
            $.ajax({
                url: "/dict/getCityList",
                dataType: "json",
                data: {province_id: province_id},
                success: function(json){
                    ul.empty();
                    var str = [];
                    for(var i = 0; i < json.length; i++){
                        var area = json[i];
                        str.push('<li><a class="mini-button start_city_btn" href="javascript:;" area_id="' + area.id + '"><span class="mini-button-text">' + area.short_name + '</span></a></li>');
                    }
                    ul.append(str.join("\n"));
                }
            });
        }

        function onSelectStartDistrict(){
            var city_id = mini.get("start_city_id").getValue() || 0;
            if(!city_id){
                onSelectStartCity();
                return;
            }
            areaWindow.showAtEl(document.getElementById("start_district"), {
                xAlign: "center",
                yAlign: "below"
            });
            var el = areaWindow.getBodyEl();
            var ul = $(el).find("ul");
            $.ajax({
                url: "/dict/getDistrictList",
                dataType: "json",
                data: {city_id: city_id},
                success: function(json){
                    ul.empty();
                    if(json.length == 0){
                        areaWindow.hide();
                        mini.get("start_district").setValue("");
                        mini.get("start_district_id").setValue("");
                        return;
                    }
                    var str = [];
                    for(var i = 0; i < json.length; i++){
                        var area = json[i];
                        str.push('<li><a class="mini-button start_district_btn" href="javascript:;" area_id="' + area.id + '"><span class="mini-button-text">' + area.short_name + '</span></a></li>');
                    }
                    ul.append(str.join("\n"));
                }
            });
        }


        $(function(){
            $(".start_province_btn").live("click",function(){
                var text = $(this).text();
                var start_point = $(this).attr("area_id");
                mini.get("start_province").setValue(text);
                mini.get("start_province_id").setValue(start_point);
                mini.get("start_point").setValue(start_point);
                //updateDistance();
                setTimeout(function(){
                    onSelectStartCity();
                },100);
            });

            $(".start_city_btn").live("click",function(){
                var text = $(this).text();
                var start_point = $(this).attr("area_id");
                mini.get("start_city").setValue(text);
                mini.get("start_city_id").setValue(start_point);
                mini.get("start_point").setValue(start_point);
                //updateDistance();
                setTimeout(function(){
                    onSelectStartDistrict();
                },100);
            });

            $(".start_district_btn").live("click",function(){
                var text = $(this).text();
                var start_point = $(this).attr("area_id");
                mini.get("start_district").setValue(text);
                mini.get("start_district_id").setValue(start_point);
                mini.get("start_point").setValue(start_point);
                //updateDistance();
                areaWindow.hide();
            });
        });

        /**目的地点*/
        function onSelectEndProvince(){
            areaWindow.showAtEl(document.getElementById("end_province"), {
                xAlign: "center",
                yAlign: "below"
            });
            var el = areaWindow.getBodyEl();
            var ul = $(el).find("ul");
            $.ajax({
                url: "/dict/getProvinceList",
                dataType: "json",
                success: function(json){
                    ul.empty();
                    var str = [];
                    for(var i = 0; i < json.length; i++){
                        var province = json[i];
                        str.push('<li><a class="mini-button end_province_btn" style="width:70px;" href="javascript:;" area_id="' + province.id + '"><span class="mini-button-text">' + province.short_name + '</span></a></li>');
                    }
                    ul.append(str.join("\n"));
                }
            });
        }

        function onSelectEndCity(){
            var province_id = mini.get("end_province_id").getValue() || 0;
            if(!province_id){
                onSelectEndProvince();
                return;
            }
            areaWindow.showAtEl(document.getElementById("end_city"), {
                xAlign: "center",
                yAlign: "below"
            });
            var el = areaWindow.getBodyEl();
            var ul = $(el).find("ul");
            $.ajax({
                url: "/dict/getCityList",
                dataType: "json",
                data: {province_id: province_id},
                success: function(json){
                    ul.empty();
                    var str = [];
                    for(var i = 0; i < json.length; i++){
                        var area = json[i];
                        str.push('<li><a class="mini-button end_city_btn" href="javascript:;" area_id="' + area.id + '"><span class="mini-button-text">' + area.short_name + '</span></a></li>');
                    }
                    ul.append(str.join("\n"));
                }
            });
        }

        function onSelectEndDistrict(){
            var city_id = mini.get("end_city_id").getValue() || 0;
            if(!city_id){
                onSelectEndCity();
                return;
            }
            areaWindow.showAtEl(document.getElementById("end_district"), {
                xAlign: "center",
                yAlign: "below"
            });
            var el = areaWindow.getBodyEl();
            var ul = $(el).find("ul");
            $.ajax({
                url: "/dict/getDistrictList",
                dataType: "json",
                data: {city_id: city_id},
                success: function(json){
                    ul.empty();
                    if(json.length == 0){
                        areaWindow.hide();
                        mini.get("end_district").setValue("");
                        mini.get("end_district_id").setValue("");
                        return;
                    }
                    var str = [];
                    for(var i = 0; i < json.length; i++){
                        var area = json[i];
                        str.push('<li><a class="mini-button end_district_btn" href="javascript:;" area_id="' + area.id + '"><span class="mini-button-text">' + area.short_name + '</span></a></li>');
                    }
                    ul.append(str.join("\n"));
                }
            });
        }


        $(function(){
            $(".end_province_btn").live("click",function(){
                var text = $(this).text();
                var end_point = $(this).attr("area_id");
                mini.get("end_province").setValue(text);
                mini.get("end_province_id").setValue(end_point);
                mini.get("end_point").setValue(end_point);
                //updateDistance();
                setTimeout(function(){
                    onSelectEndCity();
                },100);
            });
            
            $(".end_city_btn").live("click",function(){
                var text = $(this).text();
                var end_point = $(this).attr("area_id");
                mini.get("end_city").setValue(text);
                mini.get("end_city_id").setValue(end_point);
                mini.get("end_point").setValue(end_point);
                //updateDistance();
                setTimeout(function(){
                    onSelectEndDistrict();
                },100);
            });

            
            $(".end_district_btn").live("click",function(){
                var text = $(this).text();
                var end_point = $(this).attr("area_id");
                mini.get("end_district").setValue(text);
                mini.get("end_district_id").setValue(end_point);
                mini.get("end_point").setValue(end_point);
                //updateDistance();
                areaWindow.hide();
            });
        });
        //货物单位变化
        function onCargoUnitChanged(e) {
            var btn = e.sender;
            var checked = btn.getChecked();
            var text = btn.getText();
            var value = btn.getValue();
            if(checked){
                if(value == 1){//整车
                    window.cargo_number_old = mini.get("cargo_number").getValue();
                    mini.get("cargo_number").setValue(1);
//                    mini.get("cargo_number").disable();
                    mini.get("cargo_number").decimalPlaces=0;//当单位是车的时候，数量不能为小数
                }else{
                	mini.get("cargo_number").decimalPlaces=2;//当单位不是车的时候，数量可以为小数
                    mini.get("cargo_number").enable();
                    if(mini.get("cargo_number").getValue() == 1 && window.cargo_number_old){
                        mini.get("cargo_number").setValue(window.cargo_number_old);
                    }
                }
                $("#cargo_unit_div").text(text);
                mini.get("cargo_unit").setValue(value);
                //更新总价格
                updateTotalPrice();
            }
        }
        //更新总价格
        function updateTotalPrice(){
            if(!mini.get("unit_price") || !mini.get("cargo_number") || !mini.get("cargo_unit")){
                return;
            }
            var unit_price = mini.get("unit_price").getValue();
            var cargo_number = mini.get("cargo_number").getValue();
            var cargo_unit = mini.get("cargo_unit").getValue();
            var totalPrice = 0;
            if(cargo_unit == 1){//整车
                totalPrice = unit_price;
            }else{
                totalPrice = accMul(unit_price , cargo_number);
            }
            //mini.get("price").setValue(totalPrice);
        }
        //运输方式变化
        function onShipChanged(e) {
            var btn = e.sender;
            var checked = btn.getChecked();
            var text = btn.getText();
            var value = btn.getValue();
            if(checked){
            	mini.get("ship_type").setValue(value);
            }
        }

        function getDistance(city1,city2,callback) {
            var myGeocoder = new BMap.Geocoder();
            myGeocoder.getPoint(city1, function(point1) {
                myGeocoder.getPoint(city2, function(point2) {
                
                    //在页面增加临时div,用来解决map初始化的问题,因为要用到Map类的getDistance方法，
                    //而百度地图API的Map类的初始化必须要有一个容器
                    var bufDiv = document.createElement("div");
                    document.body.appendChild(bufDiv);
                    bufDiv.setAttribute("id", "mapContainer");
                    bufDiv.setAttribute("style", "display:none");

                    var map = new BMap.Map('mapContainer');
                    map.centerAndZoom("北京", 12);
                    var distance = map.getDistance(point1, point2);
                    var distanceBuf = (distance / 1000).toFixed(2).split(".");
                    var mileage = distanceBuf[0] + "." + distanceBuf[1];
                    //alert(city1 + "与" + city2 + "距离为" + mileage + "公里");

                
                    //删除临时div
                    var a = document.getElementById("mapContainer");
                    a.parentNode.removeChild(a);
                    //回调函数,返回原始的number类型的距离给回调函数处理
                    callback(mileage);
                }, city2);
            }, city1);
        }
        //更新地理距离
        function updateDistance(){
            var sp = mini.get("start_province").getFormValue();
            var sc = mini.get("start_city").getFormValue();
            var sd = mini.get("start_district").getFormValue();
            var ep = mini.get("end_province").getFormValue();
            var ec = mini.get("end_city").getFormValue();
            var ed = mini.get("end_district").getFormValue();
            //从区县开始选到省
            var start = sd || sc || sp;
            var end = ed || ec || ep;
            if(!start || !end){
                $("#totalDistance").text("--");
                return;
            }
            getDistance(start,end, function(dis){
                if(!isNaN(dis)){
                    $("#totalDistance").text(dis);
                }
            });
        }


        function CloseWindow(action) {
            if (action == "close" && form.isChanged()) {
                if (confirm("数据被修改了，是否先保存？")) {
                    return false;
                }
            }
            if (window.CloseOwnerWindow) return window.CloseOwnerWindow(action);
            else window.close();            
        }
        function onOk(e) {
            SaveData();
        }
        function onCancel(e) {
            CloseWindow("cancel");
        }

        function onFileSelect(e) {
            alert("选择文件");
            //var fileupload = mini.get("cargo_photo1_upload");
            //fileupload.startUpload();
        }
        function onUploadSuccess(e) {

            alert("上传成功：" + e.serverData);

            this.setText("");
            mini.get("cargo_photo1").setValue(e.serverData);
        }
        function onUploadError(e) {
            alert("上传失败.");
        }
        function startUpload() {
            var fileupload = mini.get("cargo_photo1_upload");
            alert("开始上传")
            fileupload.startUpload();
        }

	function accMul(arg1,arg2) 
	{ 
		var m=0,s1=arg1.toString(),s2=arg2.toString(); 
		try{m+=s1.split(".")[1].length}catch(e){} 
		try{m+=s2.split(".")[1].length}catch(e){} 
		return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m) 
	} 
    </script>
</body>
</html>