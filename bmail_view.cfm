<cfquery name="qryGetAccounts" datasource="emails">
	select EmailAccount,EmailServer,EmailLoginID,EmailPassword,EmailID
	from EmailAccounts
	where EmailID=#url.email#
</cfquery>

<cfoutput query="qryGetAccounts"><cfpop action="GETALL" server="#EmailServer#" username="#EmailLoginID#" password="#EmailPassword#" name="Messages" messagenumber="#url.messagenumber#"></cfoutput>
<cfinclude template="bmail_header.cfm">
<cfhtmlhead text='
	<script language="JavaScript">
		function EmailAction(locAction,locEmail){
			windowName = "newwindow";
			url="new_mail.cfm?email=#qryGetAccounts.EmailID#&Message=" + locEmail + "&action=" + locAction;
			params = "toolbar=0,";
			params += "location=0,";
			params += "directories=0,";
			params += "status=0,";
			params += "menubar=0,";
			params += "scrollbars=1,";
			params += "resizable=1,"; 
			params += "width=550,";
			params += "height=550";
			win = window.open(url, windowName, params);
			win.opener.name = "opener";
			win.focus();
		}
	</script>

'>
<cfif Messages.RecordCount gt 0>
	<cfoutput query="Messages">
		<cfif url.messagenumber neq 1><a href="bmail_view.cfm?messagenumber=#evaluate(url.messageNumber-1)#&total=#url.total#&email=#url.email#">&lt;&lt;Previous</a>
		&nbsp;&nbsp;</cfif>
		<cfif url.messagenumber neq url.total><a href="bmail_view.cfm?messagenumber=#evaluate(url.messageNumber+1)#&total=#url.total#&email=#url.email#">Next&gt;&gt;</a></cfif><br>
		<a href="index.cfm">Message List</a><br>
		<strong>Subject: #subject#<br>
		<cfset emailStart1=Find("<",from)>
		<cfif not emailStart1>
			<cfset emailStart1=1>
		</cfif>
		<cfset emailEnd1=Find(">",from)>
		<cfif not emailEnd1>
			<cfset emailEnd1=2>
		</cfif>
		<cfset FromEmailValue=Mid(from,emailStart1+1,evaluate((emailEnd1-1)-emailStart1))>
		<cfif not Find("@",FromEmailValue)>
			<cfset FromEmailValue=from>
		</cfif>
		From: <a href="mailto:#FromEmailValue#">#FromEmailValue#</a><br>
		To: #to#<br>
		<cfif cc neq "">CC: #cc#<br></cfif>
		<cfset EmailValue="">
		<cfif replyto neq "" and Find("@",replyto)>
			<cfset emailStart=Find("<",replyto)>
			<cfif not emailStart>
				<cfset emailStart=1>
			</cfif>
			<cfset emailEnd=Find(">",replyto)>
			<cfif not emailEnd>
				<cfset emailEnd=2>
			</cfif>
			<cfset EmailValue=Mid(replyto,emailStart+1,evaluate((emailEnd-1)-emailStart))>
			<cfif not Find("@",EmailValue)>
				<cfset EmailValue=replyto>
			</cfif>
		<cfelseif Find("@",from) and FromEmailValue neq "">
			<cfset EmailValue=FromEmailValue>
		</cfif>
		<cfif EmailValue neq "">
			ReplyTo: <a href="mailto:#EmailValue#">#EmailValue#</a><br>
		</cfif>
		<cftry>
			<cfset tempDate=ParseDateTime(date,"POP")>
			<cfset useParsedate=1>
			<cfcatch type="Expression">
				<cfset tempDate=date>
				<cfset useParsedate=0>
			</cfcatch>
		</cftry>
		Date: <cfif useParseDate eq 1>#DateFormat(tempDate,"m/d")#&nbsp;#TimeFormat(tempDate,"h:mm tt")#<cfelse>#date#</cfif><br>
		</strong>
		<form action="index.cfm?email=#url.email#" method="post">
			<input type="hidden" name="deleteThis" value="#url.messagenumber#">
			<input type="Submit" value="Delete" class="button_submit">&nbsp;<input type="button" value="<<Reply" class="button_submit" onClick="EmailAction('reply',#url.messagenumber#)">&nbsp;<input type="button" value="Forward>>" class="button_submit" onClick="EmailAction('forward',#url.messagenumber#)">
		</form>
		<br>
		<cfset locBody=body>
		<cfset listIndex=1>
		<!--- #REFindNoCase(locBody,"(http://|www\.)(([:alpha:],_,-)+\.){1,2})[com,org,net](/([:alpha:],_,-,\.)+)*(\?([:alpha:],_,-,\.,&)*")# --->
		<cfloop index="body_word" list="#locBody#" delimiters=" ,#Chr(10)##Chr(13)#">
			<cfset tempLink="">
			<cfif FindNoCase("http://",body_word) or FindNoCase("www.",body_word)>
				<cfset tempLink="<a href='" & body_word & "'>" & body_word & "</a>">
				<cfset ReplaceNoCase(locBody,"#body_word#","#tempLink#","ALL")>
			</cfif>
			<cfset listIndex=IncrementValue(listIndex)>
		</cfloop>
		<!--- <cfif FindNoCase("<html>",locBody)>
			<cfset locBody=Replace(locBody,"<html>","","All")>
		</cfif>
		<cfif FindNoCase("</html>",locBody)>
			<cfset locBody=Replace(locBody,"</html>","","All")>
		</cfif>
		<cfif FindNoCase("<head>",locBody)>
			<cfset locBody=Replace(locBody,"<head>","","All")>
		</cfif>
		<cfif FindNoCase("</head>",locBody)>
			<cfset locBody=Replace(locBody,"</head>","","All")>
		</cfif> --->
		<cfif FindNoCase("<html>",locBody)>
			#locBody#
		<cfelse>
			#Replace(locBody,Chr(13),"<br>","All")#
		</cfif>
		<br>
		<br>
	</cfoutput>
<cfelse>
	<cflocation url="index.cfm">
</cfif>
<cfinclude template="bmail_footer.cfm">