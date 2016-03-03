<%@ page import="com.eventbee.general.*,com.eventbee.general.GenUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<html title="Email to friend">
<head>
  <title>E-Mail this page to a friend</title>
 <script>

function callSubject()
{
 var msg="Hi,\n \n"
 +"Please accept my invitation to list your classified at\n"
 +"http://www.desihub.com for Free! Desihub is fastest growing Indian\n"
 +"community portal built on the foundation of giving back to the community.\n\n"

 +"The advantages of listing classifieds on Desihub are: \n\n"

 +"* Reach NRI's and Indians all over the world \n \n"

 +"* Add unlimited text or HTML to classifieds using advanced WYSIWYG editor \n\n"

 +"* Add photo to the classified, which reflects the classified more effectively \n\n"

 +"* Include your classified in Daily Classifieds listing digest sent out to all Desihub members\n\n"

 +"* Get your classified included in Desihub RSS feeds \n\n"

 +"Added to these features, we also have a premium listing option for a \n"
 +"nominal $4.95 to get high visibility and longer listing duration.\n\n"

 +"Please visit http://www.desihub.com to signup for free membership, and\n"
 +"start listing your classifieds for free!\n\n"
 
 +"If you have more questions on our services please do contact me.\n\n"

 +"Thanks,\n\n"

 +"Sailaja P\n"
 +"Marketing Executive\n"
 +"Desihub Inc.\n"
 +"http://www.desihub.com\n\n"

 +"If you do not wish to receive invitations from Desihub,please send an\n"
 +"email to me -sailaja@desihub.com";






var msg1="Hi,\n\n"

+"List your event at http://www.desihub.com. Enable Group Ticket selling feature, and sell tickets through group of trusted/approved people instead of just you!\n\n"

+"CRY, BATA, FIA, AIF and many more organizations use Desihub to sell event tickets. Take advantage of Desihub's advanced ticket selling platform tomaximize your ticket sales.\n\n"


+"More advantages:\n\n"

+"* Reach NRI's and Indians all over the world\n\n"

+"* Customize your event page look and feel to match with your website \n\n"

+"* Include your event in Daily events listing digest sent out to all Desihub members \n\n"

+"* Get your event included in Desihub RSS feeds\n\n"

+"* Publish your events automatically to world-class calendars/databases such as Google Base, Eventbee, Eventful\n\n"

+"Do not wait to take advantage of all these benefits for free, visit http://www.desihub.com now and list your event! If you have more questions please do contact me.\n\n"

+"Thanks,\n\n"

+"Sailaja P\n"
+"Marketing Executive\n"
+"Desihub Inc.\n"
+"sailaja@desihub.com\n"
+"http://www.desihub.com\n\n"

+"If you do not wish to receive invitations from Desihub,please send an \n"
+"email to me - sailaja@desihub.com ";


if(document.form.subject.value=="events"){
document.form.sub.value="Maximise your ticket sales by using Desihub";
document.form.personalmessage.value=msg1;
}
else{
document.form.sub.value="Classified listing at Desihub";
document.form.personalmessage.value=msg;
}
}



function checkName(){
var t1=document.form.fromemail.value;
  if(document.form.toemails.value==''){
  	alert("To email should not be empty");
  	return false;
  }else if(document.form.fromemail.value==''){
  	alert("From email should not be empty");
  	return false;
  }else if((document.form.fromemail.value!='')&&((t1.indexOf('@')==-1)||(t1.indexOf('.')==-1))){
       	alert("From Email Id Format is invalid");
        return false;
  }else{
  	return true;
  }

}


</script>



</head>
<body>

<form action="desihubmailsent.jsp" method="post" name="form" onSubmit="return (checkName())"/>

 

  <table cellspacing="0" cellpadding="2" border="0">
      <tr>
      <td class="inputlabel">To *<br/>(comma separated email IDs)</td>
      <td class="inputvalue">
        <textarea name="toemails" cols="40" rows="4" onfocus="this.value=(this.value==' ')?'':this.value"> </textarea>
      </td>
    </tr>
    <tr>
      <td class="inputlabel">From *<br/>(email ID)</td>
      <td class="inputvalue">
        <input type="text" maxlength="120" name="fromemail" value="sailaja@desihub.com" size="40"/>
      </td>
    </tr>

    </tr>
    
    <tr>
  	  <td class="inputlabel">Purpose </td>
  	   <td class="inputvalue">
       <SELECT NAME='subject' ID='subject' width='30%' OnChange="javascript:callSubject();" >
        <option value='sss'> Select</option>
	<option value='classifieds'> Classifieds</option>
	<option value='events'> Events</option>
	</SELECT>
	</td></tr>
	<tr>
	<td class="inputlabel">Subject<br/></td>
  	   <td class="inputvalue">
	<input type="text" name=sub id='sub' size=45 value="select" />
        </td></tr>



  	
    <tr>
    
      <td class="inputlabel">Personal Message</td>
      <td class="inputvalue">
        <textarea name="personalmessage" cols="70" rows="15" value=' '> </textarea>
      </td>
    </tr>
  
    <tr>
      <td colspan="2" align="center">
      	
	<input type="button" name="Submit" value="Cancel" onClick="javascript:window.close();"/>
        <input type="Submit" name="Submit" value="Submit" />
      </td>
    </tr>
  </table>
</form>