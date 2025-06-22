trigger accTRigger on Account (before delete) {
	
    if(trigger.isBefore && trigger.isDelete) {
        for(Account opp : Trigger.New) {
            if(opp.Phone == '123456') {
                opp.Phone.addError('Cannot Delete Now man');
            }
        }
    }
}