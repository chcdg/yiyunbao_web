$(function(){
	var F=$("#sidebox"),H=$("#arrowbox");$w=$("#sidemenu");
	
	var D="side-collapsed",
	
	A=$w.hasClass(D),
	
	C=$(".sideBarButton"),
	arrow=$("<div class=\"btn\">&nbsp;</div>").css("cursor","pointer").click(G).hover(function(){
	C.addClass("sidebarButton-over")},
																																										
	function(){
		C.removeClass("sidebarButton-over")});
		C.append(arrow);
	function G(){
		if(A){
			C.removeClass("sidebarButton-over");
		if(navigator.userAgent.indexOf("MSIE 6")>-1&&navigator.userAgent.indexOf("MSIE 8")<0)F.animate({left:170});
		$w.animate({paddingLeft:170},function(){
			$w.toggleClass(D)});
		A=false;
			}else{
			C.removeClass("sidebarButton-over");
		if(navigator.userAgent.indexOf("MSIE 6")>-1&&navigator.userAgent.indexOf("MSIE 8")<0)F.animate({left:0});
		$w.animate({paddingLeft:20},function(){
			$w.toggleClass(D)});
		A=true;
	}}
});