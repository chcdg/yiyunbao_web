<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <style type="text/css">
        .area {
            padding:5px;
        }
        .area li{
            list-style: none;
            float: left;
            margin: 3px;
        }
        /*去除ie10下的placeholder重影*/
        input:-ms-input-placeholder {
            color:#fff;
        }
    </style>
 </head>
<body>
         <form id="form1" method="post">
            <div class="mini-panel" title="基本信息" style="width:850px;">
                <table style="table-layout:fixed;">
                    <tr>
                        <td style="width:150px;">投保人名称：</td>
                        <td style="width:200px;">    
                            <input name="insurer_name" class="mini-textbox" required="true" emptyText="请填完整的公司或个人名称"/>
                        </td>
                        <td style="width:100px;">联系电话：</td>
                        <td style="width:200px;">    
                            <input name="insurer_phone" class="mini-textbox" required="true" emptyText="请填写联系方式"/>
                        </td>
                        <td style="width:100px;"></td>
                        <td style="width:200px;"></td>
                    </tr>
                    <tr>
                        <td>被保险人名称：</td>
                        <td>    
                            <input name="insured_name" class="mini-textbox" required="true" value="" emptyText="请填完整的公司或个人名称"/>
                        </td>
                        <td>联系电话：</td>
                        <td >    
                            <input name="insured_phone" class="mini-textbox" required="true"  value="" emptyText="请填写联系方式"/>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>  
                </table>
            </div>

            <div class="mini-panel" title="货运信息" style="width:850px;">
                <table style="table-layout:fixed;">
                    <tr>
                        <td>
                            <table style="table-layout:fixed;">
                                <tr>
                                    <td colspan="2">标记/发票号码/运单号</td>
                                </tr>
                                <tr>
                                	<td colspan="2">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <textarea name="shiping_number"  class="mini-textarea" required="true" style="width:250px;height:50px;"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap">运输方式：</td>
                                    <td><input name="ship_type" class="mini-textbox" required="true"  value="公路" emptyText="默认公路"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap">起运地：</td>
                                    <td>
                                        	<input id="start_area" name="start_area" class="mini-textbox" required="true" >
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <table style="table-layout:fixed;">
                               <tr>
                                    <td colspan="2">包装及数量</td>
                                </tr>
                               <tr>
                                    <td colspan="2">包装代码：
                                   		<input id="package_type" name="package_type" class="mini-combobox"  url="/dict/getAllInsurancePackageType" textField="name" 
                            valueField="id" required="true" style="width:150px;"	 />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <textarea name="packet_number"  class="mini-textarea" required="true" style="width:250px;height:50px;" emptyText="例如88件"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap">运输工具：</td>
                                    <td><input name="ship_tool" class="mini-textbox" required="true"  value="汽车" emptyText="默认汽车"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>目的地：</td>
                                    <td>
                                        <input id="end_area" name="end_area" class="mini-textbox" required="true" >
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <table style="table-layout:fixed;">
                            	 <tr>
                                    <td colspan="2">货物名称及类型</td>
                                </tr>
                            	 <tr>
                                    <td colspan="2">
                                    	<input id="cargo_type1" name="cargo_type1" class="mini-combobox"  url="/insurance/getFirstCargoType" textField="name"  valueField="id" required="true"   onvaluechanged="onCargoChanged" />
							            <input id="cargo_type2" name="cargo_type2" class="mini-combobox"   textField="name"  valueField="id" required="true"  />
									</td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <textarea name="cargo_desc"  class="mini-textarea" required="true" style="width:250px;height:50px;"></textarea>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td nowrap="nowrap">车牌号：</td>
                                    <td><input name="plate_number" class="mini-textbox" required="true"  value="" emptyText=""/>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap">起运日期：</td>
                                    <td>
                                        <input id="start_date" name="start_date" class="mini-datepicker" required="true" format="yyyy-MM-dd" timeFormat="HH:mm:ss" showTime="true" emptyText="请选择日期" style="width:160px;"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>     
                </table>
            </div>
            <div class="mini-panel" title="保险信息" style="width:850px;">
                <table style="table-layout:fixed;">
                    <tr>
                        <td style="width:100px;">主险条款内容：</td>
                        <td style="width:200px;">    
                            <input id="policy_content" class="mini-textbox" readonly="true" value=""/>
                            <input id="insurance_type" name="insurance_type" class="mini-hidden"/>
                        </td>
                        <td colspan="4">
                            <a class="mini-button" plain="false" checkOnClick="true" groupName="insuranceType" checked="true" oncheckedchanged="onInsuranceTypeChanged" value="1">基本险</a>
                            <a class="mini-button" plain="false" checkOnClick="true" groupName="insuranceType" oncheckedchanged="onInsuranceTypeChanged" value="2" >综合险</a>
                            <a class="mini-button" plain="false" checkOnClick="true" groupName="insuranceType" oncheckedchanged="onInsuranceTypeChanged" value="3" >综合险附加被盗险</a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <div class="mini-toolbar" style="">
                                <div>
                                基本险 费率0.03%，主要承保运输途中因火灾及其他灾害事故造成的损失；
                                </div>
                                <div>
                                    综合险 费率0.04%，除了基本险责任外，还承保破碎、弯曲、凹瘪、折断、开裂、渗漏以及被盗的损失；
                                </div>
                                <div>
                                    综合附加被盗险 费率0.05%，除了综合险责任外，还承保货物被盗的损失；
                                </div>
                                <div>
                                    详细保险条款，请查看《中国太平洋财产保险股份有限公司国内水路、陆路货物运输保险条款》
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>保险金额：</td>
                        <td>
                            <input id="amount_covered" name="amount_covered" class="mini-spinner" value="0" minValue="0" maxValue="90000000" onvaluechanged="onAmountCoveredChanged"/>
                        </td>
                        <td>保险费率：</td>
                        <td>
                            <span id="ration_div"></span>%
                        </td>
                        <td>签单日期：</td>
                        <td>
                            <input id="sign_time" name="sign_time" class="mini-datepicker" required="true" format="yyyy-MM-dd" timeFormat="HH:mm:ss" showTime="true" emptyText="请选择日期" style="width:160px;"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <div class="mini-toolbar" style="">
                                <table style="table-layout:fixed;">
                                    <tr>
                                        <td>免赔条款：</td>
                                        <td>
                                            <div>1、易碎品风险每次事故绝对免费RMB1000或损失金额的20%，其余风险每次事故绝对免赔RMB1000或损失金额的10%，二者以高者为准；
                                            </div>
                                            <div>2、裸装货物提出锈损和刮擦责任。
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>  
                </table>
            </div>
        	<table style="table-layout:fixed;">
                <tr>
                    <td style="width:100px;">保险费用：
			
		    </td>
                    <td style="width:200px;">
                        <input id="insurance_charge" class="mini-textbox" value="0" readonly="true" />元
                    </td>
                    <td style="width:100px;">账户余额${user.gold!0}</td>
                    <td style="width:200px;">
                        <a class="mini-button" href="/pay" plain="false" target="_blank" iconCls="icon-user">充值</a>
                    </td>
                    <td style="width:100px;">发票抬头</td>
                    <td style="width:200px;">
                        <input id="receipt_title" name="receipt_title" class="mini-textbox"  required="true" >
                    </td>
                </tr>
            </table>
		<div style="text-align:center;padding:10px;">
		<font color="red">保险费用不得低于20元</font>&nbsp;&nbsp;
            <a class="mini-button" onclick="onViewPolicy" style="margin-right:20px;">查看保险条款</a>       
            <a class="mini-button" onclick="onOk" style="margin-right:20px;" hrefxx="javascript:;">确认并提交保单</a>       
            <a class="mini-button" onclick="onCancel" style="">取消保单</a>       
        </div>  
    </form>
    <div id="areaWindow" class="mini-window" title="地区选择" style="width:430px;height:320px;" showFooter="true" showModal="true" allowResize="false" allowDrag="false">
        <ul class="area">
        </ul>
        <div property="footer" style="text-align:right;padding:5px;padding-right:15px;">
            <input type="button" value='清除选择' onclick="clearArea()" style='vertical-align:middle;'/>
            <input type='button' value='关闭' onclick="hideWindow()" style='vertical-align:middle;'/>
        </div>
    </div>
</body>
<script>
    //保险费率，1-基本险,2-综合险
    var ratios = {
        "1": 0.03,
        "2": 0.04,
        "3": 0.05
    };

    mini.parse();
    var form = new mini.Form("form1");
    var areaWindow = mini.get("areaWindow");
    var gold = ${user.gold!0};

    function SaveData() {
        var o = form.getData();
        o.start_date = mini.formatDate(o.start_date, 'yyyy-MM-dd');
        o.sign_time = mini.formatDate(o.sign_time, 'yyyy-MM-dd');

        form.validate();
        if (form.isValid() == false) return;
        var charge = parseFloat(mini.get("insurance_charge").getValue());
        if(charge > gold){
            mini.confirm("当前余额不足，余额总数:" + gold + "，要充值吗?", "温馨提示", function(action){
                if(action == "ok"){
                    //$("#pay").click();
                    window.open("/pay");
                }
            });
            return;
        }

        //var json = mini.encode([o]);
        $.ajax({
            url: "/insurance/save_cpic",
            data: o,
            cache: false,
            success: function (text) {
            	var o = mini.decode(text);
            	if(!o.success){
            		mini.alert(o.data);
            	}else{
                    mini.alert(o.data, "温馨提示", function(){
                        CloseWindow("save");
                    });
            	}
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(jqXHR.responseText);
                CloseWindow();
            }
        });
    }

    function GetData() {
        var o = form.getData();
        return o;
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
        CloseWindow("close");
    }

    function hideWindow(){
        areaWindow.hide();
    }

    //清除所选地区
    function clearArea(){
        //hideWindow();
        mini.get("start_province").setValue("");
        mini.get("start_province_id").setValue("");
        mini.get("start_city").setValue("");
        mini.get("start_city_id").setValue("");
        mini.get("start_district").setValue("");
        mini.get("start_district_id").setValue("");
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
                for(var i = 0; i < json.length; i++){
                    var province = json[i];
                    ul.append('<li><a class="mini-button start_province_btn" style="width:70px;" href="javascript:;" area_id="' + province.id + '"><span class="mini-button-text">' + province.short_name + '</span></a></li>');
                }
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
                for(var i = 0; i < json.length; i++){
                    var area = json[i];
                    ul.append('<li><a class="mini-button start_city_btn" href="javascript:;" area_id="' + area.id + '"><span class="mini-button-text">' + area.short_name + '</span></a></li>');
                }
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
                for(var i = 0; i < json.length; i++){
                    var area = json[i];
                    ul.append('<li><a class="mini-button start_district_btn" href="javascript:;" area_id="' + area.id + '"><span class="mini-button-text">' + area.short_name + '</span></a></li>');
                }
            }
        });
    }


    $(function(){
        $(".start_province_btn").live("click",function(){
            var text = $(this).text();
            var start_point = $(this).attr("area_id");
            mini.get("start_province").setValue(text);
            mini.get("start_province_id").setValue(start_point);
            //updateDistance();
            onSelectStartCity();
        });

        $(".start_city_btn").live("click",function(){
            var text = $(this).text();
            var start_point = $(this).attr("area_id");
            mini.get("start_city").setValue(text);
            mini.get("start_city_id").setValue(start_point);
            //updateDistance();
            onSelectStartDistrict();
        });

        $(".start_district_btn").live("click",function(){
            var text = $(this).text();
            var start_point = $(this).attr("area_id");
            mini.get("start_district").setValue(text);
            mini.get("start_district_id").setValue(start_point);
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
                for(var i = 0; i < json.length; i++){
                    var province = json[i];
                    ul.append('<li><a class="mini-button end_province_btn" style="width:70px;" href="javascript:;" area_id="' + province.id + '"><span class="mini-button-text">' + province.short_name + '</span></a></li>');
                }
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
                for(var i = 0; i < json.length; i++){
                    var area = json[i];
                    ul.append('<li><a class="mini-button end_city_btn" href="javascript:;" area_id="' + area.id + '"><span class="mini-button-text">' + area.short_name + '</span></a></li>');
                }
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
                for(var i = 0; i < json.length; i++){
                    var area = json[i];
                    ul.append('<li><a class="mini-button end_district_btn" href="javascript:;" area_id="' + area.id + '"><span class="mini-button-text">' + area.short_name + '</span></a></li>');
                }
            }
        });
    }


    $(function(){
        $(".end_province_btn").live("click",function(){
            var text = $(this).text();
            var end_point = $(this).attr("area_id");
            mini.get("end_province").setValue(text);
            mini.get("end_province_id").setValue(end_point);
            //updateDistance();
            onSelectEndCity();
        });
        
        $(".end_city_btn").live("click",function(){
            var text = $(this).text();
            var end_point = $(this).attr("area_id");
            mini.get("end_city").setValue(text);
            mini.get("end_city_id").setValue(end_point);
            //updateDistance();
            onSelectEndDistrict();
        });

        $(".end_district_btn").live("click",function(){
            var text = $(this).text();
            var end_point = $(this).attr("area_id");
            mini.get("end_district").setValue(text);
            mini.get("end_district_id").setValue(end_point);
            //updateDistance();
            areaWindow.hide();
        });
    });

    $(function(){
        var now = mini.formatDate(new Date(), "yyyy-MM-dd");
        mini.get("start_date").setValue(now);
        mini.get("sign_time").setValue(now);
    });

    function onInsuranceTypeChanged(e){
        var btn = e.sender;
        var checked = btn.getChecked();
        var text = btn.getText();
        var value = btn.getValue();
        if(checked){
            mini.get('insurance_type').setValue(value);
            var ratio = ratios[value];
            $("#ration_div").text(ratio);
            mini.get("policy_content").setValue(text);
            updateInsuranceCharge();
        }
    }

    function onAmountCoveredChanged(e){
        updateInsuranceCharge();
    }

    //更新保险费用
    function updateInsuranceCharge(){
        if(!mini.get('amount_covered') || !mini.get('insurance_type') || !mini.get("insurance_charge")){
            return;
        }
        var insurance_type = mini.get('insurance_type').getValue();
        var ratio = ratios[insurance_type];
        var amount_covered = parseInt(mini.get('amount_covered').getValue());
        if(!isNaN(amount_covered) && amount_covered != 0){
            var charge = (amount_covered * ratio)/100;
            if(!isNaN(charge)){
                charge = charge.toFixed(2);
                if(charge < 20){
                	charge = 20 ;
                }
                mini.get("insurance_charge").setValue(charge);
            }
        }
    }

	function onCargoChanged(e) {
		var cargo_type1 = mini.get("cargo_type1");
        var cargo_type2 = mini.get("cargo_type2");
        var id = cargo_type1.getValue();
        cargo_type2.setValue("");
        var url = "/insurance/getSecondCargoType?id=" + id
        cargo_type2.setUrl(url);
        cargo_type2.select(0);
        }
</script>
</html>
