<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
    <script src="/js/boot.js"></script>
    
 </head>
<body>
   <table class="mini-grid-table">
   		<tr class="mini-grid-row">
   			<td  class="mini-grid-cell">订单编号</td>
   			<td  class="mini-grid-cell">履约诚信度</td>
   			<td  class="mini-grid-cell">信息真实度</td>
   			<td  class="mini-grid-cell">付款及时率</td>
   			<td  class="mini-grid-cell">评价内容</td>
   			<td  class="mini-grid-cell">评价人</td>
   			<td  class="mini-grid-cell">评价时间</td>
   		</tr>
   		<#list list as reply>
   		<tr class="mini-grid-row">
   			<td class="mini-grid-cell">${reply.order_id!""}</td>
   			<td class="mini-grid-cell">
   				<div id="score1_${reply.id}"></div>
   			</td>
   			<td class="mini-grid-cell">
   				<div id="score2_${reply.id}"></div>
			</td>
   			<td class="mini-grid-cell">
   				<div id="score3_${reply.id}"></div>
			</td>
   			<td class="mini-grid-cell">${reply.reply_content!""}</td>
   			<td class="mini-grid-cell">${reply.driver_name!""}</td>
   			<td class="mini-grid-cell">${reply.reply_time!""}</td>
   		</tr>
   		</#list>
   </table>

</body>
<script type="text/javascript" src="/js/jquery.raty.min.js"></script>
<script>
    mini.parse();
	 $(function() {
   	 	$.fn.raty.defaults.path = '/images/rate';
   	 	<#list list as reply>
	    	$('#score1_${reply.id}').raty({
	    		score : ${reply.score1},
	    		readOnly : true
	    	});
	    	$('#score2_${reply.id}').raty({
	    		score : ${reply.score2},
	    		readOnly : true
	    	});
	    	$('#score3_${reply.id}').raty({
	    		score : ${reply.score3},
	    		readOnly : true
	    	});
    	</#list>
    });
</script>
</html>
