trigger opportunityTRigger on Opportunity (before delete) {
	
    if(trigger.isBefore && trigger.isDelete) {
        for(Opportunity opp : Trigger.New) {
            if(opp.StageName == 'Closed Won') {
                //opp.StageName.addError('Cannot Delete Now man');
            }
        }
    }
}