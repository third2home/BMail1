<cfif url.email eq "32H">
	<cfset locServer="mail.third2home.com">
	<cfset LocUser="bprice@third2home.com">
	<cfset locPassword="gocubs">
<cfelseif url.email eq "357">
	<cfset locServer="pop-server.kc.rr.com">
	<cfset LocUser="price357">
	<cfset locPassword="olivia00">
<cfelse>
	<cfset locServer="pop-server.kc.rr.com">
	<cfset LocUser="third2home">
	<cfset locPassword="gocubs00">
</cfif>

<cfoutput><cfpop action="GETALL" server="#locServer#" username="#locUser#" password="#locPassword#" name="Messages" messagenumber="#url.messagenumber#"></cfoutput>
<html>
<head>
	<title>Mail, Dude</title>
</head>
<body>
<cfif Messages.RecordCount gt 0>
	<cfoutput query="Messages">
		<cfif url.messagenumber neq 1><a href="mymail_view.cfm?messagenumber=#evaluate(url.messageNumber-1)#&total=#url.total#&email=#url.email#">&lt;&lt;Previous</a>
		&nbsp;&nbsp;</cfif>
		<cfif url.messagenumber neq url.total><a href="mymail_view.cfm?messagenumber=#evaluate(url.messageNumber+1)#&total=#url.total#&email=#url.email#">Next&gt;&gt;</a></cfif><br>
		<a href="mymail.cfm">Message List</a><br>
		<strong>Subject: #subject#<br>
		From: #from#<br>
		To: #to#<br>
		CC: #cc#<br>
		ReplyTo: <cfif replyto neq ""><a href="mailto:#replyto#">#replyto#</a><cfelse><a href="mailto:#from#">#from#</a></cfif><br>
		Date: #date#<br>
		</strong>
		<form action="mymail.cfm?email=#url.email#" method="post">
			<input type="hidden" name="deleteThis" value="#url.messagenumber#">
			<input type="Submit" value="Delete Message">
		</form>
		<br>
		<cfset listIndex=1>
		<cfloop index="body_word" list="#body#" delimiters=" #Chr(13)#">
			<cfset tempLink="">
			<cfif FindNoCase("http://",body_word) or FindNoCase("www.",body_word)>
				<cfset tempLink="<a href='" & body_word & "'>" & body_word & "</a>">
				<cfset ReplaceNoCase(body,"#body_word#","#tempLink#","ALL")>
			</cfif>
			<cfset listIndex=IncrementValue(listIndex)>
		</cfloop>
		<cfif FindNoCase("<br>",body)>
			#body#
		<cfelse>
			#Replace(body,Chr(13),"<br>","All")#
		</cfif>
		<br>
		<br>
	</cfoutput>
<cfelse>
	<cflocation url="mymail.cfm">
</cfif>
</body>
</html>