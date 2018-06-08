import-module c:\phoneregistration\FimPowerShellModule.psm1

###
### Create the Workflow: 'PhoneRegistration: Registration'
###
New-FimWorkflowDefinition -DisplayName 'PhoneRegistration: Registration' `
-Description 'Enables the PhoneFactor user and updates the registration status at the web application by calling a web API' `
-RequestPhase 'Action' `
-Xoml (@"
<ns0:SequentialWorkflow
	x:Name					="SequentialWorkflow"
	ActorId					="00000000-0000-0000-0000-000000000000"
	WorkflowDefinitionId	="00000000-0000-0000-0000-000000000000"
	RequestId				="00000000-0000-0000-0000-000000000000"
	TargetId				="00000000-0000-0000-0000-000000000000"
	xmlns:ns1				="clr-namespace:MS.IT.PhoneAuth.WorkflowActivities;Assembly=MS.IT.PhoneAuth.WorkflowActivities, Version=1.0.1.0, Culture=neutral, PublicKeyToken=93c089e0b7eeba05"
	xmlns:ns3				="clr-namespace:MS.IT.FimServer.Activities;Assembly=MS.IT.FimServer.Activities, Version=1.0.1.0, Culture=neutral, PublicKeyToken=93c089e0b7eeba05"
	xmlns:ns4				="clr-namespace:MS.IT.FimServer.Activities.ProcessManagement;Assembly=MS.IT.FimServer.Activities, Version=1.0.1.0, Culture=neutral, PublicKeyToken=93c089e0b7eeba05"
	xmlns:x					="http://schemas.microsoft.com/winfx/2006/xaml"
	xmlns:ns0				="clr-namespace:Microsoft.ResourceManagement.Workflow.Activities;Assembly=Microsoft.ResourceManagement, Version=4.1.3452.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35">
	<ns1:PhoneFactorWebsvcActivity 
		x:Name								="authenticationGateActivity1"
		MethodToCall						="EnableUser" 
		PhoneFactorEndpoint					="[//Configuration/PhoneRegistration: PhoneFactorEndpoint]"
		PhoneFactorCertificateThumbprint	="[//Configuration/PhoneRegistration: PhoneFactorCertificateThumbprint]"
		StatusUpdateEndpoint				="[//Configuration/PhoneRegistration: StatusUpdateEndpoint]"
		CertificateThumbprint				="[//Configuration/PhoneRegistration: CertificateThumbprint]">
		<ns1:PhoneFactorWebsvcActivity.MethodArguments>
			<x:Array Type="{{x:Type p7:String}}" xmlns:p7="clr-namespace:System;Assembly=mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089">
				<ns2:String xmlns:ns2="clr-namespace:System;Assembly=mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089">[//Target/UserPrincipalName]</ns2:String>
			</x:Array>
		</ns1:PhoneFactorWebsvcActivity.MethodArguments>
	</ns1:PhoneFactorWebsvcActivity>
	<ns3:TimeStampGeneratorActivity
		x:Name						="authenticationGateActivity2"
		UseUtc						="False"
		StoreInWorkflowDictionary	="False"
		OffsetString				=""
		AttributeOrKeyName			="LastRegistrationDate" />
	<ns4:UpdateStatusActivity
		x:Name						="authenticationGateActivity3"
		NewStatus					="Complete"
		ProcessType					="Registration"
		StatusUpdateEndpoint		="[//Configuration/PhoneRegistration: StatusUpdateEndpoint]" />
	<ns0:EmailNotificationActivity
		x:Name						="authenticationGateActivity4"
		CC							="{{x:Null}}"
		Bcc							="{{x:Null}}"
		SuppressException			="False"
		To							="[//Requestor];"
		EmailTemplate				="{0}" />
</ns0:SequentialWorkflow>
"@ -F (Get-FimObjectID EmailTemplate DisplayName 'PhoneRegistration: Registration Complete'))
