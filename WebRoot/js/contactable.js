(function($) {
	$.fn.contactable = function(options) {
		var defaults = {
			name: 'Name',
			email: 'Email',
			message: 'Message',
			recipient: 'test@test.co.uk',
			subject: 'A contactable message',
			recievedMsg: 'Thankyou for your message',
			notRecievedMsg: 'Sorry but your message could not be sent, try again later'
		};
		var options = $.extend(defaults, options);
		return this.each(function(options) {
			$(this).html('<div id="contactable"></div><div id="contactForm" ><div class="bright ads fl" style="margin-left:-40px;"><div style="float:right;margin-right:5px;" ><img src="/images/adv_close.png" style="cursor:pointer;" onclick="javascript:$(\'#contactable\').click();">></div><div class="contact">联系我们：电话119</div><div><a class="adv" href="#"></a></div></div></div>');
			$('div#contactable').toggle(function() {
				$('#overlay').css({
					display: 'block'
				});
				$(this).animate({
					"marginRight": "-=0px"
				},
				"fast");
				$('#contactForm').animate({
					"marginRight": "-=0px"
				},
				"fast");
				$(this).animate({
					"marginRight": "+=190px"
				},
				"slow");
				$('#contactForm').animate({
					"marginRight": "+=190px"
				},
				"slow");
			},
			function() {
				$('#contactForm').animate({
					"marginRight": "-=190px"
				},
				"slow");
				$(this).animate({
					"marginRight": "-=190px"
				},
				"slow").animate({
					"marginRight": "+=0px"
				},
				"fast");
				$('#overlay').css({
					display: 'none'
				});
			});
			
		})
	}
})(jQuery);