<style>
#bodycontainer {
background:#FFFFFF;
margin:0 auto;
}
#container {
background: transparent;
}
</style>
<script>
function showEveLoadingImage(msg) {
	loaded = false;
	var el = document.getElementById("imageLoad");
	if (el && !loaded) {
		el.innerHTML='';
		el.innerHTML = msg+'<br/><img src="/home/images/ajax-loader.gif">';
		Element.show('imageLoad');
	}
	
}

</script>
<table width="100%" align="center" cellpadding="0" cellspacing="0"><tr><td width="100%" align="center" >

<div id="bodycontainer">

  <div id="singledatacol">
   <div id="maincontent">
    <table width="100%" height="250" valign="middle" align="center">
	<tr>
		
		<td  valign="middle" align="center"> 
		<div class="logo"><a href="/main/"><img src="/home/images/logo_big.jpg" style="border-style: none"></a>
    	</div>
    	<br/>
		<div id="imageLoad"></div>
			<script>showEveLoadingImage("Loading...");</script>
			<script>setTimeout(function(){window.location.href=window.location.href;},30000);</script>
		</td>
	</tr>
    </table>
   </div>
  </div>
</div>

</td></tr></table>
