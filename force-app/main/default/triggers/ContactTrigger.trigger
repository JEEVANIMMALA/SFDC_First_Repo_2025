trigger ContactTrigger on Contact (before insert,after insert, after update) {
	if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            //ContactTriggerHandler.checkDuplicateEmails(Trigger.new, Trigger.oldMap);
        }
    }
    
    System.debug('TRigger --10--');
    if(Trigger.isafter & (Trigger.isInsert|| Trigger.isUpdate)) {
        System.debug('TRigger --1--');
        Set<String> allEmail = new Set<String>();
        for(Contact con : Trigger.New) {
            if(Trigger.isUpdate && con.email!= null && con.email != Trigger.oldMap.get(con.id).email) {
                System.debug('TRigger --12--');
                allEmail.add(con.email);
            }else {
                System.debug('TRigger --13--');
                 allEmail.add(con.email);
            }
        }
        
        Map<String,Contact> contactMapMatched = new Map<String, Contact>();
        
          for(Contact eachContact : [SELECT ID,name,email FROM contact WHERE email IN:allEmail AND Id NOT IN:Trigger.New ]) {
               contactMapMatched.put(eachContact.email,eachContact);
            System.debug('TRigger --14--'+eachContact);
        }
        
          for(Contact con : Trigger.New) {
            if(con.email != null && contactMapMatched.containsKey(con.email)) {
                System.debug('TRigger --15--'+con);
                con.email.addError('Email Already Exist Boss in'+contactMapMatched.get(con.email).Name);
            }
        }
    }
}