
<style>
#countries li.active a,#languages li.active a{
	color:#FF9900 !important;
}
</style>

  <div
		style="background: none repeat scroll 0px 0px rgb(243, 246, 250); min-height: 91px;"
		class="navbar navbar-default navbar-fixed-top">
		<div class="container">
			<div class="navbar-header">
				<button data-target=".navbar-collapse" data-toggle="collapse"
					class="navbar-toggle">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<br /> 
				
				<a style="margin-bottom: -16px; margin-top: -15px;"
					class="navbar-brand" href="/"><img height="50" alt="Eventbee"
					src="http://www.eventbee.com/main/images/logo.png" /></a>
			</div>
			<div class="navbar-collapse collapse">
				<ul class="nav navbar-nav" style="margin: 18px -8px;">
					<li><a href="/main/pricing/en-us">Pricing and features  </a></li>
					<li><a href="/main/how-it-works/en-us">How it works</a></li>
					<li><a href="/main/faq/en-us">FAQ</a></li>
					<li><a id="contact" href="javascript:;"> Contact</li>
				</ul>
			  <ul class="nav navbar-nav navbar-right" style="margin: 18px -8px;">
				  
				  				  
				<li><a href="javascript:;" id="getTickets">  Get my tickets</a></li>
				  
			
				<li><a href="/main/user/login?lang=en-us"> Login    </a></li>
				<li class="nav-btn" ><a href="/main/user/signup?lang=en-us"><button
							class="btn btn-primary">    Sign Up</button></a></li>
				
			</ul>
			</div>
		</div>
	</div>
	
<!-- modal dialog -->
<div class="col-md-12">
	<!-- Modal -->
	<div class="modal" id="myModal" tabindex="-1" role="dialog"
		aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title"></h4>
				</div>
				<div class="modal-body">
					<iframe id="popup" src="" width="100%" style="height: 430px"
						frameborder="0"></iframe>
				</div>
			</div>
		</div>
	</div>
</div>
 <script>
 $('#contact').click(function() {
							$('.modal-title').html("Contact Eventbee");
							$('#myModal').on('show.bs.modal',
											function() {
												$('iframe#popup')
														.attr("src",
																'/main/user/homepagesupportemail.jsp');
												$('iframe#popup').css("height",
														"440px");
											});
							$('#myModal').modal('show');
						});
	$('#getTickets').click(	function() {
							$('.modal-title').html("Get My Tickets");
							$('#myModal').on('show.bs.modal',
											function() {
												$('iframe#popup')
														.attr("src",
																'/main/user/homepagemytickets.jsp');
												$('iframe#popup').css("height",
														"435px");
											});
							$('#myModal').modal('show');
						});
		$('#myModal').modal({
			backdrop : 'static',
			keyboard : false,
			show : false
		});
		$('#myModal').on('hide.bs.modal',
						function() {
							$('iframe#popup').attr("src", '');
							$('#myModal .modal-body')
									.html(
											'<iframe id="popup" src="" width="100%" style="height:440px" frameborder="0"></iframe>');
						});
	
	 </script> 