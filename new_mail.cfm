<cfparam name="url.Message" default="">
<cfparam name="url.email" default="">

<cfquery name="qryGetAccounts" datasource="emails">
	select EmailAccount,EmailServer,EmailLoginID,EmailPassword,EmailID
	from EmailAccounts
	order by EmailUserID,EmailID
</cfquery>
<cfif url.Message neq "">
	<cfquery name="qryGetActionAccount" dbtype="query">
		select *
		from qryGetAccounts
		where EmailID=#url.email#
	</cfquery>
	<cfoutput query="qryGetAccounts"><cfpop action="GETALL" server="#qryGetActionAccount.EmailServer#" username="#qryGetActionAccount.EmailLoginID#" password="#qryGetActionAccount.EmailPassword#" name="locMessage" messagenumber="#url.Message#"></cfoutput>
</cfif>
<html>
<head>
	<title>New Mail, Dude</title>
	<style>
		body{
			font-family:Verdana;
			font-size:10pt;
		}
		
		td{
			font-family:Verdana;
			font-size:10pt;
		}
		
		input.button_submit {
		   font: 10px verdana, geneva, arial, sans-serif; 
		   font-size: 11px; 
		   color: #fff; 
		   background: #F00; 
		   margin: 0;
		   padding: 0px;
		   font-weight: bold;
		}
		
		input.text_box {
		   font-family: verdana, geneva, arial, sans-serif; 
		   font-size: 11px; 
		}
		
		
		a:link {
			font-weight:normal;
			margin:0px;
			padding:0px;
			color:#00F;
			text-decoration:underline;
		}
		
		a:active {
			font-weight:normal;
			margin:0px;
			padding:0px;
			color:#F00;
			text-decoration:underline;
		}
		
		a:visited {
			font-weight:normal;
			margin:0px;
			padding:0px;
			color:#00F;
			text-decoration:underline;
		}
	</style>
</head>
<body>
<form name="mail_form" action="send_mail.cfm" method="post">
<table>
	<tr>
		<td align="right">To:</td>
		<cfoutput><td><input type="text" size="30" name="to_value" class="text_box"<cfif url.Message neq "" and url.action eq "reply"> value="#Replace(locMessage.from,"""","","ALL")#"</cfif>></td></cfoutput>
	</tr>
	<tr>
		<td align="right">From:</td>
		<td>
			<select name="from_value" style="font-size:11px; font-family:verdana, arial, helvetica, geneva, sans-serif">
				<cfoutput query="qryGetAccounts">
				<option value="#EmailAccount#"<cfif url.Message neq "" and url.email neq "" and url.email eq EmailID> selected</cfif>>#EmailAccount#
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td align="right">Subject:</td>
		<cfoutput><td><input type="text" size="30" name="subject_value" class="text_box"<cfif url.Message neq ""> value="<cfif url.action eq "reply">RE:<cfelse>FW:</cfif>#locMessage.subject#"</cfif>></td></cfoutput>
	</tr><br>
	<tr>
		<td align="right">Body:</td>
		<cfif url.Message neq "">
			<cfoutput>
			<td><textarea name="body_value" cols="50" rows="20" class="text_box">
			
			
-------Original Message----------
#Replace(locMessage.from,"""","","ALL")##Chr(13)##Chr(10)#
#locMessage.body#
			</textarea></td>
			</cfoutput>
		<cfelse>
			<td><textarea name="body_value" cols="50" rows="20" class="text_box"></textarea></td>
		</cfif>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<input type="submit" value="Send Mail" class="button_submit">
		</td>
	</tr>
</table>
</form>
</body>
</html>