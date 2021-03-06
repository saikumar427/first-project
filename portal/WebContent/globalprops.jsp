<%@page import="com.eventbee.layout.DBHelper"%>
<%@page import="java.util.HashMap"%>
<%!
   private HashMap<String,String> props=new HashMap<String,String>();

	public String getPropValue(String key,String eid){
		String lang=DBHelper.getLanguageFromDB(eid);
		String prop=props.get(key+"_"+lang);
		prop = prop == null ? (props.get(key+"_en_US") == null ? "" : props.get(key+"_en_US") ) : prop;
		return prop;
	}
%>

<%

/*eventhandler.jsp*/
props.put("evh.footer.lnk_en_US", "Powered by Eventbee - Your online registration and event ticketing solution. For more information, visit");


/*CreditCardScreen.jsp*/
props.put("ccs.note_en_US", "NOTE: CC processing is done by Eventbee. Eventbee appears on your credit card statement");
props.put("ccs.card.type_en_US", "Card Type");
props.put("ccs.card.nmbr_en_US", "Card Number");
props.put("ccs.cvv.nmbr_en_US", "CVV Code");
props.put("ccs.exp_en_US", "Expiration Month/Year");
props.put("ccs.cc.address_en_US", "Credit Card Billing Address");
props.put("ccs.card.holder_en_US", "Cardholder");
props.put("ccs.fname_en_US", "First Name");
props.put("ccs.lname_en_US", "Last Name");
props.put("ccs.country_en_US", "Country");
props.put("ccs.street_en_US", "Street");
props.put("ccs.apt_en_US", "Apt/Suite");
props.put("ccs.city_en_US", "City");
props.put("ccs.state_en_US", "State/Province");
props.put("ccs.zip_en_US", "Zip/Postal Code");


/*continueoptions.jsp*/
props.put("co.nopayment.first_en_US", "If you have closed payment processing window without completing the payment process, ");
props.put("co.nopayment.second_en_US", "click here to continue the process, ");
props.put("co.payment.first_en_US", "If you have completed payment processing successfully,");
props.put("co.payment.second_en_US", "click here to reach confirmation page");

/*fbpopupshare.jsp*/
props.put("fbpopshre.nts.enable_en_US", "Publish to Facebook. Earn Bee Credits if your <br>friends buy tickets through your published link!");
props.put("fbpopshre.nts.disable_en_US", "Publish to Facebook. Let your friends know that you are attending this event!");

/*done.jsp*/
props.put("done.print_en_US", "Print");
props.put("done.payment.not.received.first_en_US", "We haven't received payment confirmation from credit card processing company. Some times it may take few minutes to get the confirmation.<p>A confirmation email with Transaction ID <b>");
props.put("done.payment.not.received.second_en_US", "</b> will be sent to your mail as soon as we get confirmation.");
props.put("done.payment.not.received.note_en_US", "NOTE: If you do not find confirmation email in your Inbox, please do check your Bulk folder, and update your spam filter settings to allow Eventbee emails.");
props.put("done.back_en_US", "Back to Tickets page");

/*checkavailability.jsp*/
props.put("ca.tkt.not.avail_en_US", "Tickets you have selected are currently not available");
props.put("ca.timeout.first_en_US", "You have exceeded the time limit and your reservation has been released.");
props.put("ca.timeout.second_en_US", "The purpose of this time limit is to ensure that registration is available to as many people as possible.");
props.put("ca.timeout.third_en_US", "We apologize for the inconvenience.");
props.put("ca.back_en_US", "Click Here Go To Tickets Page");		
props.put("ca.seats.not.available_en_US", "Few of the seats you are trying to book are currently on hold or already soldout.");

/*socialshare.jsp*/
props.put("ss.share_en_US", "Share");
props.put("ss.tweet_en_US", "Tweet");
props.put("ss.email_en_US", "Email");

props.put("ss.to_en_US", "To");
props.put("ss.comma.seperate_en_US", "Enter emails with comma separated");
props.put("ss.ur.email_en_US", "Your Email");
props.put("ss.ur.name_en_US", "Your Name");
props.put("ss.sub_en_US", "Subject");
props.put("ss.msg_en_US", "Message");
props.put("ss.enter.crct_en_US", "Enter Correct Code");
props.put("ss.enter.below_en_US", "Enter the code as shown below");
props.put("ss.refer.lnk_en_US", "Your referral link");
props.put("ss.send_en_US", "Send");
props.put("ss.cancel_en_US", "Cancel");
props.put("ss.share.purchase_en_US", "Share your purchase");

/*rsvp confirmation*/
props.put("rsvp.other.info_en_US", "Other Information");
props.put("rsvp.back.evnt_en_US", "Back to Event page");

/*rsvpoptions.jsp*/
props.put("rsvp.sel.date_en_US", "--Select Date--");

/*waitlist.jsp */
props.put("wl.tkt.name_en_US", "Ticket Name");
props.put("wl.qty_en_US", "Quantity");
props.put("wl.name_en_US", "Name");
props.put("wl.email_en_US", "Email");
props.put("wl.phone_en_US", "Phone");
props.put("wl.msg.mgr_en_US", "Message to manager");
props.put("wl.submit_en_US", "Submit");
props.put("wl.cancel_en_US", "Cancel");
props.put("wl.require_en_US", "Required");

/*paymentsection.jsp */
props.put("ps.proc.fee.msg_en_US","Processing Fee is not applicable to this payment method");

/*emailsend.jsp*/
props.put("email.sent.to.msg_en_US","Email sent to");
props.put("email.sent.to.msg2_en_US","recepient(s)");
props.put("email.invi.limit.msg_en_US","Please limit to 10 email invitations");
props.put("no.email.sent.to.msg_en_US","No Email sent to  recepient(s)");

props.put("buy.btn.lbl_en_US","Buy Tickets");
props.put("reg.btn.lbl_en_US","Register");

//priority registration
props.put("pri.reg.invalid.errmsg_en_US","Invalid Code or Passcode");
props.put("pri.reg.limit.reg.single.errmsg_en_US","This code is already used");
props.put("pri.reg.limit.reg.mul.errmsg_en_US","This code reached maximum usage");
props.put("pri.reg.limit.reg.errmsg_en_US","Limited registrations are over");

/*BuyerPage login */
props.put("byer.lgt.fb.lgin.reged.fb.acct_en_US","Sorry! Your Facebook login doesn't match with the Facebook login used to register for this event.");
props.put("byer.there.problm.try.latr_en_US","There is a problem. Please try back later");
props.put("byer.ur.pg.crntly.unavble_en_US","Your page is currently unavailable");
props.put("byer.aces.tkn.sent.success_en_US","Access Token sent successfully");
props.put("byer.fb.lgn.nt.mtch.wth.reg_en_US","Sorry! Your Facebook login doesn't match with the Facebook login used to register for this event.");
props.put("byer.invld.access.tken_en_US","Invalid Access Token");
props.put("byer.to.vst.byr.page_en_US","To visit buyer page");
props.put("byer.eml.byr.access.tkn_en_US","Email me buyer page Access Token");
props.put("byer.lgn.wth.fb_en_US","Login with my Facebook");
props.put("byer.access.tkn.snt.mail_en_US","Access Token is sent to email");
props.put("byer.access.tkn_en_US","Access Token");
props.put("byer.u.hv.regd.wth.fb.acc_en_US","You have registered for this event with your Facebook login.");
props.put("byer.access.tkn.expired_en_US","Access Token is expired");
props.put("byer.resend.btn_en_US","Resend");
props.put("byer.continue.btn_en_US","Continue");
props.put("byer.or.lbl_en_US","OR");
		
	//for columbia

/*eventhandler.jsp*/
props.put("evh.footer.lnk_es_CO", "Desarrollado por Eventbee - Tu plataforma online para el registro y venta de tiquetes de eventos. Para m�s informaci�n, visita");

/*CreditCardScreen.jsp*/

props.put("ccs.note_es_CO", "NOTA: El proceso de tarjeta de cr�dito se realiz� a trav�s de Eventbee. Eventbee aparecer� en el extracto bancario de su tarjeta de cr�dito");
props.put("ccs.card.type_es_CO", "Tipo de Tarjeta");
props.put("ccs.card.nmbr_es_CO", "N�mero de Tarjeta");
props.put("ccs.cvv_es_CO", "C�digo de Seguridad");
props.put("ccs.exp_es_CO", "Fecha de Expiraci�n Mes/A�o");
props.put("ccs.cc.address_es_CO", "Direcci�n Tarjeta de Cr�dito");
props.put("ccs.card.holder_es_CO", "Titular");
props.put("ccs.fname_es_CO", "Nombre");
props.put("ccs.lname_es_CO", "Apellido");
props.put("ccs.country_es_CO", "Pa�s");
props.put("ccs.street_es_CO", "Calle");
props.put("ccs.apt_es_CO", "Apt/Suite");
props.put("ccs.city_es_CO", "Ciudad");
props.put("ccs.state_es_CO", "Departamento");
props.put("ccs.zip_es_CO", "C�digo Postal");


/*continueoptions.jsp*/

props.put("co.nopayment.first_es_CO", "Si has cerrado la ventana del proceso de pago sin completar el proceso, ");
props.put("co.nopayment.second_es_CO", "haz clic aqu� para continuar el proceso, ");
props.put("co.payment.first_es_CO", "Si has completado el proceso de pago exitosamente,");
props.put("co.payment.second_es_CO", "haz clic aqu� para dirigirte a la p�gina de confirmaci�n");


/*fbpopupshare.jsp*/

props.put("fbpopshre.nts.enable_es_CO", "Publica en Facebook. �Gana Bee Credits si tus amigos compran tiquetes por medio del link de tu publicaci�n!");
props.put("fbpopshre.nts.disable_es_CO", "Publica en Facebook. Permite que tus amigos sepan a qu� evento estas asistiendo");



/*done.jsp*/

props.put("done.print_es_CO", "Imprimir");
props.put("done.payment.not.received.first_es_CO", "No hemos recibido la confirmaci�n de pago de la compa��a encargada del procesamiento de la tarjeta de cr�dito. Este proceso por lo general toma algunos minutos para efectuarse. <p>Un correo de confirmaci�n con el N�mero de Transacci�n</p>");
props.put("done.payment.not.received.second_es_CO", "</b> ser� enviado a su correo tan pronto como se realice la confirmaci�n");
props.put("done.payment.not.received.note_es_CO", "NOTA: Si no encuentra el correo de confirmaci�n en su bandeja de entrada, por favor revise su carpeta de Correos No Deseados y actualice los ajustes de filtros de Spam para permitir los correo de Eventbee.");
props.put("done.back_es_CO", "Volver a la P�gina de Tiquetes");


/*checkavailability.jsp*/

props.put("ca.tkt.not.avail_es_CO", "Los tiquetes que ha seleccionado recientemente no se encuentran disponibles");
props.put("ca.timeout.first_es_CO", "Usted ha excedido el tiempo l�mite y su reserva ha sido liberada");
props.put("ca.timeout.second_es_CO", "El prop�sito de este tiempo l�mite es permitir que el registro se encuentre disponible para la mayor cantidad de personas");
props.put("ca.timeout.third_es_CO", "Pedimos disculpas por las molestias ocasionadas");
props.put("ca.back_es_CO", "Haga clic aqu� para ir a la P�gina de Tiquetes");
props.put("ca.seats.not.available_es_CO", "Algunos de estos asientos est�n siendo reservados o ya fueron vendidos");



/*socialshare.jsp*/

props.put("ss.share_es_CO", "Compartir");
props.put("ss.tweet_es_CO", "Compartir en Twitter");
props.put("ss.email_es_CO", "Enviar por Correo");
props.put("ss.to_es_CO", "To");
props.put("ss.comma.seperate_es_CO", "Ingrese los correos separados por comas");
props.put("ss.ur.email_es_CO", "Su Correo");
props.put("ss.ur.name_es_CO", "Su Nombre");
props.put("ss.sub_es_CO", "Asunto");
props.put("ss.msg_es_CO", "Mensaje");
props.put("ss.enter.crct_es_CO", "Ingrese el C�digo Correcto");
props.put("ss.enter.below_es_CO", "Ingrese el c�digo mostrado a continuaci�n");
props.put("ss.refer.lnk_es_CO", "Su enlace de referencia");
props.put("ss.send_es_CO", "Enviar");
props.put("ss.cancel_es_CO", "Cancelar");
props.put("ss.share.purchase_es_CO", "Compartir tu compra");


/*rsvp confirmation*/
props.put("rsvp.other.info_es_CO", "Informaci�n Adicional");
props.put("rsvp.back.evnt_es_CO", "Regresar a la P�gina del Evento");

/*rsvpoptions.jsp*/
props.put("rsvp.sel.date_es_CO", "--Seleccionar Fecha--");

/*waitlist.jsp */
props.put("wl.tkt.name_es_CO", "Nombre del Tiquete");
props.put("wl.qty_es_CO", "Cantidad");
props.put("wl.name_es_CO", "Nombre");
props.put("wl.email_es_CO", "Correo");
props.put("wl.phone_es_CO", "Tel�fono");
props.put("wl.msg.mgr_es_CO", "Escribir al Administrador");
props.put("wl.submit_es_CO", "Enviar");
props.put("wl.cancel_es_CO", "Cancelar");
props.put("wl.require_es_CO", "Requerido");

/*paymentsection.jsp */
props.put("ps.proc.fee.msg_es_CO","Cuota de procesamiento no es aplicable a este m�todo de pago");

/*emailsend.jsp*/
props.put("email.sent.to.msg_es_CO","Correo electr�nico enviado a");
props.put("email.sent.to.msg2_es_CO","recepient(s)");
props.put("email.invi.limit.msg_es_CO","Por favor, limite de 10 invitaciones por correo electr�nico");
props.put("no.email.sent.to.msg_es_CO","Sin correo electr�nico enviado a recepient(s)");

props.put("buy.btn.lbl_es_CO","Comprar Tiquetes");
props.put("reg.btn.lbl_es_CO","Registro");

//priority registration
props.put("pri.reg.invalid.errmsg_es_CO","C�digo no v�lido o c�digo de acceso");
props.put("pri.reg.limit.reg.single.errmsg_es_CO","Este c�digo se utiliza ya");
props.put("pri.reg.limit.reg.mul.errmsg_es_CO","Este c�digo alcanz� el m�ximo uso");
props.put("pri.reg.limit.reg.errmsg_es_CO","Inscripciones limitadas son m�s de");
		
/*BuyerPage login */		
props.put("byer.u.hv.regd.wth.fb.acc_es_CO","Te has registrado para este evento con tu cuenta de Facebook");
props.put("byer.access.tkn_es_CO","Se�al de acceso");
props.put("byer.access.tkn.snt.mail_es_CO","Se�al de Acceso enviada a esta direcci�n de correo electr�nico");
props.put("byer.lgn.wth.fb_es_CO","Iniciar sesi�n con mi cuenta de Facebook");
props.put("byer.eml.byr.access.tkn_es_CO","Mandarme por correo electr�nico la Se�al de Acceso de la p�gina del comprador");
props.put("byer.to.vst.byr.page_es_CO","Para visitar la p�gina del comprador");
props.put("byer.invld.access.tken_es_CO","Se�al de Acceso Inv�lida");
props.put("byer.fb.lgn.nt.mtch.wth.reg_es_CO","Lo sentimos! Tu informaci�n de inicio de sesi�n de Facebook no coincide con la informaci�n de Facebook proporcionada para el registro de este evento.");
props.put("byer.aces.tkn.sent.success_es_CO","Se�al de Acceso enviada exitosamente");
props.put("byer.there.problm.try.latr_es_CO","Hay un problema. Por favor int�ntalo de nuevo m�s tarde");
props.put("byer.lgt.fb.lgin.reged.fb.acct_es_CO","Lo sentimos! Tu informaci�n de inicio de sesi�n de Facebook no coincide con la informaci�n de Facebook proporcionada para el registro de este evento.");
props.put("byer.ur.pg.crntly.unavble_es_CO","Tu p�gina no est� disponible en estos momentos");
props.put("byer.access.tkn.expired_es_CO","Token de acceso ha caducado");
props.put("byer.resend.btn_es_CO","Reenviar");
props.put("byer.continue.btn_es_CO","Continuar");
props.put("byer.or.lbl_es_CO","O");
		

//for mexico


/*eventhandler.jsp*/
props.put("evh.footer.lnk_es_MX", "Desarrollado por Eventbee - Tu plataforma online para el registro y venta de tiquetes de eventos. Para m�s informaci�n, visita");

/*CreditCardScreen.jsp*/

props.put("ccs.note_es_MX", "NOTA: El proceso de tarjeta de cr�dito se realiz� a trav�s de Eventbee. Eventbee aparecer� en el extracto bancario de su tarjeta de cr�dito");
props.put("ccs.card.type_es_MX", "Tipo de Tarjeta");
props.put("ccs.card.nmbr_es_MX", "N�mero de Tarjeta");
props.put("ccs.cvv_es_MX", "C�digo de Seguridad");
props.put("ccs.exp_es_MX", "Fecha de Expiraci�n Mes/A�o");
props.put("ccs.cc.address_es_MX", "Direcci�n Tarjeta de Cr�dito");
props.put("ccs.card.holder_es_MX", "Titular");
props.put("ccs.fname_es_MX", "Nombre");
props.put("ccs.lname_es_MX", "Apellido");
props.put("ccs.country_es_MX", "Pa�s");
props.put("ccs.street_es_MX", "Calle");
props.put("ccs.apt_es_MX", "Apt/Suite");
props.put("ccs.city_es_MX", "Ciudad");
props.put("ccs.state_es_MX", "Departamento");
props.put("ccs.zip_es_MX", "C�digo Postal");


/*continueoptions.jsp*/

props.put("co.nopayment.first_es_MX", "Si has cerrado la ventana del proceso de pago sin completar el proceso, ");
props.put("co.nopayment.second_es_MX", "haz clic aqu� para continuar el proceso, ");
props.put("co.payment.first_es_MX", "Si has completado el proceso de pago exitosamente,");
props.put("co.payment.second_es_MX", "haz clic aqu� para dirigirte a la p�gina de confirmaci�n");


/*fbpopupshare.jsp*/

props.put("fbpopshre.nts.enable_es_MX", "Publica en Facebook. �Gana Bee Credits si tus amigos compran tiquetes por medio del link de tu publicaci�n!");
props.put("fbpopshre.nts.disable_es_MX", "Publica en Facebook. Permite que tus amigos sepan a qu� evento estas asistiendo");



/*done.jsp*/

props.put("done.print_es_MX", "Imprimir");
props.put("done.payment.not.received.first_es_MX", "No hemos recibido la confirmaci�n de pago de la compa��a encargada del procesamiento de la tarjeta de cr�dito. Este proceso por lo general toma algunos minutos para efectuarse. <p>Un correo de confirmaci�n con el N�mero de Transacci�n</p>");
props.put("done.payment.not.received.second_es_MX", "</b> ser� enviado a su correo tan pronto como se realice la confirmaci�n");
props.put("done.payment.not.received.note_es_MX", "NOTA: Si no encuentra el correo de confirmaci�n en su bandeja de entrada, por favor revise su carpeta de Correos No Deseados y actualice los ajustes de filtros de Spam para permitir los correo de Eventbee.");
props.put("done.back_es_MX", "Volver a la P�gina de Tiquetes");


/*checkavailability.jsp*/

props.put("ca.tkt.not.avail_es_MX", "Los tiquetes que ha seleccionado recientemente no se encuentran disponibles");
props.put("ca.timeout.first_es_MX", "Usted ha excedido el tiempo l�mite y su reserva ha sido liberada");
props.put("ca.timeout.second_es_MX", "El prop�sito de este tiempo l�mite es permitir que el registro se encuentre disponible para la mayor cantidad de personas");
props.put("ca.timeout.third_es_MX", "Pedimos disculpas por las molestias ocasionadas");
props.put("ca.back_es_MX", "Haga clic aqu� para ir a la P�gina de Tiquetes");
props.put("ca.seats.not.available_es_MX", "Algunos de estos asientos est�n siendo reservados o ya fueron vendidos");



/*socialshare.jsp*/

props.put("ss.share_es_MX", "Compartir");
props.put("ss.tweet_es_MX", "Compartir en Twitter");
props.put("ss.email_es_MX", "Enviar por Correo");
props.put("ss.to_es_MX", "To");
props.put("ss.comma.seperate_es_MX", "Ingrese los correos separados por comas");
props.put("ss.ur.email_es_MX", "Su Correo");
props.put("ss.ur.name_es_MX", "Su Nombre");
props.put("ss.sub_es_MX", "Asunto");
props.put("ss.msg_es_MX", "Mensaje");
props.put("ss.enter.crct_es_MX", "Ingrese el C�digo Correcto");
props.put("ss.enter.below_es_MX", "Ingrese el c�digo mostrado a continuaci�n");
props.put("ss.refer.lnk_es_MX", "Su enlace de referencia");
props.put("ss.send_es_MX", "Enviar");
props.put("ss.cancel_es_MX", "Cancelar");
props.put("ss.share.purchase_es_MX", "Compartir tu compra");


/*rsvp confirmation*/
props.put("rsvp.other.info_es_MX", "Informaci�n Adicional");
props.put("rsvp.back.evnt_es_MX", "Regresar a la P�gina del Evento");

/*rsvpoptions.jsp*/
props.put("rsvp.sel.date_es_MX", "--Seleccionar Fecha--");

/*waitlist.jsp */
props.put("wl.tkt.name_es_MX", "Nombre del Tiquete");
props.put("wl.qty_es_MX", "Cantidad");
props.put("wl.name_es_MX", "Nombre");
props.put("wl.email_es_MX", "Correo");
props.put("wl.phone_es_MX", "Tel�fono");
props.put("wl.msg.mgr_es_MX", "Escribir al Administrador");
props.put("wl.submit_es_MX", "Enviar");
props.put("wl.cancel_es_MX", "Cancelar");
props.put("wl.require_es_MX", "Requerido");

/*paymentsection.jsp */
props.put("ps.proc.fee.msg_es_MX","Cuota de procesamiento no es aplicable a este m�todo de pago");

/*emailsend.jsp*/
props.put("email.sent.to.msg_es_MX","Correo electr�nico enviado a");
props.put("email.sent.to.msg2_es_MX","recepient(s)");
props.put("email.invi.limit.msg_es_MX","Por favor, limite de 10 invitaciones por correo electr�nico");
props.put("no.email.sent.to.msg_es_MX","Sin correo electr�nico enviado a recepient(s)");

props.put("buy.btn.lbl_es_MX","Comprar Tiquetes");
props.put("reg.btn.lbl_es_MX","Registro");

//priority registration
props.put("pri.reg.invalid.errmsg_es_MX","C�digo no v�lido o c�digo de acceso");
props.put("pri.reg.limit.reg.single.errmsg_es_MX","Este c�digo se utiliza ya");
props.put("pri.reg.limit.reg.mul.errmsg_es_MX","Este c�digo alcanz� el m�ximo uso");
props.put("pri.reg.limit.reg.errmsg_es_MX","Inscripciones limitadas son m�s de");
		
/*BuyerPage login */		
props.put("byer.u.hv.regd.wth.fb.acc_es_MX","Te has registrado para este evento con tu cuenta de Facebook");
props.put("byer.access.tkn_es_MX","Se�al de acceso");
props.put("byer.access.tkn.snt.mail_es_MX","Se�al de Acceso enviada a esta direcci�n de correo electr�nico");
props.put("byer.lgn.wth.fb_es_MX","Iniciar sesi�n con mi cuenta de Facebook");
props.put("byer.eml.byr.access.tkn_es_MX","Mandarme por correo electr�nico la Se�al de Acceso de la p�gina del comprador");
props.put("byer.to.vst.byr.page_es_MX","Para visitar la p�gina del comprador");
props.put("byer.invld.access.tken_es_MX","Se�al de Acceso Inv�lida");
props.put("byer.fb.lgn.nt.mtch.wth.reg_es_MX","Lo sentimos! Tu informaci�n de inicio de sesi�n de Facebook no coincide con la informaci�n de Facebook proporcionada para el registro de este evento.");
props.put("byer.aces.tkn.sent.success_es_MX","Se�al de Acceso enviada exitosamente");
props.put("byer.there.problm.try.latr_es_MX","Hay un problema. Por favor int�ntalo de nuevo m�s tarde");
props.put("byer.lgt.fb.lgin.reged.fb.acct_es_MX","Lo sentimos! Tu informaci�n de inicio de sesi�n de Facebook no coincide con la informaci�n de Facebook proporcionada para el registro de este evento.");
props.put("byer.ur.pg.crntly.unavble_es_MX","Tu p�gina no est� disponible en estos momentos");
props.put("byer.access.tkn.expired_es_MX","Token de acceso ha caducado");
props.put("byer.resend.btn_es_MX","Reenviar");
props.put("byer.continue.btn_es_MX","Continuar");
props.put("byer.or.lbl_es_MX","O");
		
//for spain


/*eventhandler.jsp*/
props.put("evh.footer.lnk_es_ES", "Desarrollado por Eventbee - Tu plataforma online para el registro y venta de tiquetes de eventos. Para m�s informaci�n, visita");

/*CreditCardScreen.jsp*/

props.put("ccs.note_es_ES", "NOTA: El proceso de tarjeta de cr�dito se realiz� a trav�s de Eventbee. Eventbee aparecer� en el extracto bancario de su tarjeta de cr�dito");
props.put("ccs.card.type_es_ES", "Tipo de Tarjeta");
props.put("ccs.card.nmbr_es_ES", "N�mero de Tarjeta");
props.put("ccs.cvv_es_ES", "C�digo de Seguridad");
props.put("ccs.exp_es_ES", "Fecha de Expiraci�n Mes/A�o");
props.put("ccs.cc.address_es_ES", "Direcci�n Tarjeta de Cr�dito");
props.put("ccs.card.holder_es_ES", "Titular");
props.put("ccs.fname_es_ES", "Nombre");
props.put("ccs.lname_es_ES", "Apellido");
props.put("ccs.country_es_ES", "Pa�s");
props.put("ccs.street_es_ES", "Calle");
props.put("ccs.apt_es_ES", "Apt/Suite");
props.put("ccs.city_es_ES", "Ciudad");
props.put("ccs.state_es_ES", "Departamento");
props.put("ccs.zip_es_ES", "C�digo Postal");


/*continueoptions.jsp*/

props.put("co.nopayment.first_es_ES", "Si has cerrado la ventana del proceso de pago sin completar el proceso, ");
props.put("co.nopayment.second_es_ES", "haz clic aqu� para continuar el proceso, ");
props.put("co.payment.first_es_ES", "Si has completado el proceso de pago exitosamente,");
props.put("co.payment.second_es_ES", "haz clic aqu� para dirigirte a la p�gina de confirmaci�n");


/*fbpopupshare.jsp*/

props.put("fbpopshre.nts.enable_es_ES", "Publica en Facebook. �Gana Bee Credits si tus amigos compran tiquetes por medio del link de tu publicaci�n!");
props.put("fbpopshre.nts.disable_es_ES", "Publica en Facebook. Permite que tus amigos sepan a qu� evento estas asistiendo");



/*done.jsp*/

props.put("done.print_es_ES", "Imprimir");
props.put("done.payment.not.received.first_es_ES", "No hemos recibido la confirmaci�n de pago de la compa��a encargada del procesamiento de la tarjeta de cr�dito. Este proceso por lo general toma algunos minutos para efectuarse. <p>Un correo de confirmaci�n con el N�mero de Transacci�n</p>");
props.put("done.payment.not.received.second_es_ES", "</b> ser� enviado a su correo tan pronto como se realice la confirmaci�n");
props.put("done.payment.not.received.note_es_ES", "NOTA: Si no encuentra el correo de confirmaci�n en su bandeja de entrada, por favor revise su carpeta de Correos No Deseados y actualice los ajustes de filtros de Spam para permitir los correo de Eventbee.");
props.put("done.back_es_ES", "Volver a la P�gina de Tiquetes");


/*checkavailability.jsp*/

props.put("ca.tkt.not.avail_es_ES", "Los tiquetes que ha seleccionado recientemente no se encuentran disponibles");
props.put("ca.timeout.first_es_ES", "Usted ha excedido el tiempo l�mite y su reserva ha sido liberada");
props.put("ca.timeout.second_es_ES", "El prop�sito de este tiempo l�mite es permitir que el registro se encuentre disponible para la mayor cantidad de personas");
props.put("ca.timeout.third_es_ES", "Pedimos disculpas por las molestias ocasionadas");
props.put("ca.back_es_ES", "Haga clic aqu� para ir a la P�gina de Tiquetes");
props.put("ca.seats.not.available_es_ES", "Algunos de estos asientos est�n siendo reservados o ya fueron vendidos");



/*socialshare.jsp*/

props.put("ss.share_es_ES", "Compartir");
props.put("ss.tweet_es_ES", "Compartir en Twitter");
props.put("ss.email_es_ES", "Enviar por Correo");
props.put("ss.to_es_ES", "To");
props.put("ss.comma.seperate_es_ES", "Ingrese los correos separados por comas");
props.put("ss.ur.email_es_ES", "Su Correo");
props.put("ss.ur.name_es_ES", "Su Nombre");
props.put("ss.sub_es_ES", "Asunto");
props.put("ss.msg_es_ES", "Mensaje");
props.put("ss.enter.crct_es_ES", "Ingrese el C�digo Correcto");
props.put("ss.enter.below_es_ES", "Ingrese el c�digo mostrado a continuaci�n");
props.put("ss.refer.lnk_es_ES", "Su enlace de referencia");
props.put("ss.send_es_ES", "Enviar");
props.put("ss.cancel_es_ES", "Cancelar");
props.put("ss.share.purchase_es_ES", "Compartir tu compra");


/*rsvp confirmation*/
props.put("rsvp.other.info_es_ES", "Informaci�n Adicional");
props.put("rsvp.back.evnt_es_ES", "Regresar a la P�gina del Evento");

/*rsvpoptions.jsp*/
props.put("rsvp.sel.date_es_ES", "--Seleccionar Fecha--");

/*waitlist.jsp */
props.put("wl.tkt.name_es_ES", "Nombre del Tiquete");
props.put("wl.qty_es_ES", "Cantidad");
props.put("wl.name_es_ES", "Nombre");
props.put("wl.email_es_ES", "Correo");
props.put("wl.phone_es_ES", "Tel�fono");
props.put("wl.msg.mgr_es_ES", "Escribir al Administrador");
props.put("wl.submit_es_ES", "Enviar");
props.put("wl.cancel_es_ES", "Cancelar");
props.put("wl.require_es_ES", "Requerido");

/*paymentsection.jsp */
props.put("ps.proc.fee.msg_es_ES","Cuota de procesamiento no es aplicable a este m�todo de pago");

/*emailsend.jsp*/
props.put("email.sent.to.msg_es_ES","Correo electr�nico enviado a");
props.put("email.sent.to.msg2_es_ES","recepient(s)");
props.put("email.invi.limit.msg_es_ES","Por favor, limite de 10 invitaciones por correo electr�nico");
props.put("no.email.sent.to.msg_es_ES","Sin correo electr�nico enviado a recepient(s)");

props.put("buy.btn.lbl_es_ES","Comprar Tiquetes");
props.put("reg.btn.lbl_es_ES","Registro");

//priority registration
props.put("pri.reg.invalid.errmsg_es_ES","C�digo no v�lido o c�digo de acceso");
props.put("pri.reg.limit.reg.single.errmsg_es_ES","Este c�digo se utiliza ya");
props.put("pri.reg.limit.reg.mul.errmsg_es_ES","Este c�digo alcanz� el m�ximo uso");
props.put("pri.reg.limit.reg.errmsg_es_ES","Inscripciones limitadas son m�s de");
		
/*BuyerPage login */		
props.put("byer.u.hv.regd.wth.fb.acc_es_ES","Te has registrado para este evento con tu cuenta de Facebook");
props.put("byer.access.tkn_es_ES","Se�al de acceso");
props.put("byer.access.tkn.snt.mail_es_ES","Se�al de Acceso enviada a esta direcci�n de correo electr�nico");
props.put("byer.lgn.wth.fb_es_ES","Iniciar sesi�n con mi cuenta de Facebook");
props.put("byer.eml.byr.access.tkn_es_ES","Mandarme por correo electr�nico la Se�al de Acceso de la p�gina del comprador");
props.put("byer.to.vst.byr.page_es_ES","Para visitar la p�gina del comprador");
props.put("byer.invld.access.tken_es_ES","Se�al de Acceso Inv�lida");
props.put("byer.fb.lgn.nt.mtch.wth.reg_es_ES","Lo sentimos! Tu informaci�n de inicio de sesi�n de Facebook no coincide con la informaci�n de Facebook proporcionada para el registro de este evento.");
props.put("byer.aces.tkn.sent.success_es_ES","Se�al de Acceso enviada exitosamente");
props.put("byer.there.problm.try.latr_es_ES","Hay un problema. Por favor int�ntalo de nuevo m�s tarde");
props.put("byer.lgt.fb.lgin.reged.fb.acct_es_ES","Lo sentimos! Tu informaci�n de inicio de sesi�n de Facebook no coincide con la informaci�n de Facebook proporcionada para el registro de este evento.");
props.put("byer.ur.pg.crntly.unavble_es_ES","Tu p�gina no est� disponible en estos momentos");
props.put("byer.access.tkn.expired_es_ES","Token de acceso ha caducado");
props.put("byer.resend.btn_es_ES","Reenviar");
props.put("byer.continue.btn_es_ES","Continuar");
props.put("byer.or.lbl_es_ES","O");
%>