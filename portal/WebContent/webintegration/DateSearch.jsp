<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>
<script>
function testtrim(str){
	var temp='';
	temp=new String(str);
	temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');
	return temp;
}
</script>

<script>
function search(){		
	var startdate=document.getElementById('startdate').value;
	var enddate=document.getElementById('enddate').value;
    document.getElementById('searchdetails').innerHTML='Loading .... Please wait';
		advAJAX.get( {
			
		url : '/portal/webintegration/closedevents.jsp?startdate='+startdate+'&enddate='+enddate,
		onSuccess : function(obj) {
		var data=obj.responseText;
		data=testtrim(data);
		
		document.getElementById('searchdetails').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});

}

</script>


<FORM id="datesearch" METHOD="POST" ACTION="" >
<TABLE ALIGN="CENTER">
<TR>
	<TD>Transaction Date Between</TD><TD>
	<INPUT TYPE="text" name="startdate" id="startdate"> To:<input type="text" name="enddate" id="enddate">(MM-DD-YYYY)
	<td align="center" colspan="2"><input value="Go" name="validate" type="button" onclick="search();"/></TD>
	</TR>
</TABLE>
</FORM>
<div id='searchdetails'></div>
