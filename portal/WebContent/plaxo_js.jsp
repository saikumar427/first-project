<script type="text/javascript" src="http://www.plaxo.com/css/m/js/util.js" defer='defer'></script>
<script type="text/javascript" src="http://www.plaxo.com/css/m/js/basic.js" defer='defer'></script>
<script type="text/javascript" src="http://www.plaxo.com/css/m/js/abc_launcher.js" defer='defer'></script>
<script type="text/javascript">
function trim(s1)
 	{
		s1=ltrim(s1);
		s1=rtrim(s1);
		return s1;
 	}

function onABCommComplete(data) {
// OPTIONAL: do something here after the new data has been populated in your text area
emails = new Array();
for (var i = 0; i < data.length; i++) {
emails[i] = data[i][1];
}
var email=trim(document.getElementById('toheader').value )+ ",";

if (document.getElementById('toheader').value != '' ) {


if(email.indexOf(',') == 0){

document.getElementById('toheader').value = email.substring(1,email.length);

}
else{

document.getElementById('toheader').value = email;

}

}	


document.getElementById('toheader').value = document.getElementById('toheader').value + emails.join(', ');
}
</script>

