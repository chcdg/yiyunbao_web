<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    <link rel="stylesheet" href="/js/jBox/Skins/Blue/jbox.css" type="text/css"/>
    <style type="text/css">
        .verify-summary-title{
            font-weight: bold;
            font-size: 14px;
            font-family:Microsoft YaHei;
        }
        .verify-summary-content{
            font-size: 12px;
        }
        .verify-note{
            color:red;
            font-size: 12px;
        }
        
        #idcard
			{
			width:457px;
			height:292px;
			padding:50px 263px;
			}
			
        #idcardback
			{
			width:457px;
			height:292px;
			padding:50px 263px;
			}
		#title
		{
			height:50px;
			margin:0 auto;
			font-weight:bold;
			width:370px;
		}
		#idCardResult{
			font-size:14px;
		}
    </style>
 </head>
<body>
        <div id="idCardResult" >
        	<div id= "title">
        		<img src="/images/jinghui.png" style="float:left;"/>
        		<p style="margin:0 20px;height:50px;line-height:50px;color:red;font-size:30px;float:left;">
        			公安局身份验证系统
        		</p>
        	</div>
        	<div id="idcard">
        		<img src="/images/idcard.jpg"/>
        		<div id="result_name" style="position:absolute;top:150px;left:354px;">${result.id_name!""}</div>
				<div id="id_gender" style="position:absolute;top:186px;left:354px;">${result.gender!""}</div>
				<div id="id_year" style="position:absolute;top:221px;left:354px;">${result.id_year!""}</div>
				<div id="id_month" style="position:absolute;top:221px;left:433px;">${result.id_month!""}</div>
				<div id="id_day" style="position:absolute;top:221px;left:475px;">${result.id_day!""}</div>
				<div id="id_num" style="position:absolute;top:353px;left:440px;letter-spacing:2px;">${result.id_num!""}</div>
				<div id="id_photo" style="position:absolute;top:138px;left:550px;">
					<a href='${result.photo!""}' target='_blank'><img width='150' height='200' src='${result.photo!""}'/></a>
				</div>
        	</div>
        	<div id="idcardback">
        		<div style="">&nbsp;</div>
        		<img src="/images/idcard_back.jpg"/>
        		<div id="regioninfo" style="position:absolute;top:728px;left:460px;">${result.regioninfo!""}</div>
        	</div>
        	<div style="width:277px;margin:0 auto;padding-top:30px;">
        		<img src="/images/verify_ok.png"/>
        	</div>
        </div>
        
</body>

</html>
