<cfcomponent>
	<cffunction name="getAllMail">
		<cfargument name="mailBox">
		<cfset qryMail=getMailData(arguments.mailBox)>
		
	</cffunction>
	
	<cffunction name="getMail" access="remote">
		<cfargument name="mailBox">
		<cfargument name="mailNum">
		<cfset qryMail=getMailData(arguments.mailBox)>
		<cfpop action="GETALL" server="#qryMail.EmailServer#" username="#qryMail.emailloginid#" password="#qryMail.emailpassword#" name="Messages" messagenumber="#arguments.mailNum#">
		<!--- <cfdump var="#Messages#"><cfabort> --->
		<cfoutput query="Messages">
			<cfsavecontent variable="xmlString">
			
				<xml version="1.0" encoding="UTF-8">
				<email>
					<subject>#XMLFormat(subject)#</subject>
					<from>#XMLFormat(from)#</from>
					<to>#XMLFormat(to)#</to>
					<cc>#XMLFormat(cc)#</cc>
					<replyto>#XMLFormat(replyto)#</replyto>
					<maildate>#XMLFormat(date)#</maildate>
					<mailbody>#XMLFormat(body)#</mailbody>
				</email>
			
			</cfsavecontent>
		</cfoutput>
		
		<!--- <cfset xmlString=toString(mailXML)> --->
		<cfreturn xmlString />
	</cffunction>
	
	<cffunction name="getMailData" returntype="query">
		<cfargument name="mailBox">
		<cfquery name="qryGetMailInfo" datasource="emails" result="temp">
			select emailloginid,emailpassword,emailserver
			from EmailAccounts
			where emailid=#arguments.mailBox#
		</cfquery>
		<cfreturn qryGetmailInfo />
	</cffunction>
	
</cfcomponent>
