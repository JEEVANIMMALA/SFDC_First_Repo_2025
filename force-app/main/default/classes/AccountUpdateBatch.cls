global class AccountUpdateBatch implements Database.batchable<sObject>, Database.Stateful{
    global integer totalRecords =0;
    global Database.queryLocator start(Database.BatchableContext BC) {
        return Database.getqueryLocator('SELECT Id,name,Phone FROM Account WHERE phone != null');
    }
    
    global void execute(database.batchableContext BC ,List<Account> scopeAccount) {
        List<account> accList= new List<Account>();
        for(account acc : scopeAccount) {
            acc.Phone = '7777';
            accList.add(acc);
            totalRecords++;
        }
        
        Database.update(accList);
    }
    
    global void finish(Database.batchableContext BC) {
        System.debug('Finshed batch'+totalRecords);
        Messaging.singleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<String> emailstr= new List<String>();
        emailstr.add('jeevan.sai.nimmala@accenture.com');
        emailstr.add('jeevansainimmala@gmail.com');
        msg.setToAddresses(emailstr);
        msg.setSubject('Batch apex Updated');
        msg.setPlainTextBody('numberof records updated '+totalRecords);
        List<Messaging.singleEmailMessage> allEmail = new List<Messaging.singleEmailMessage>();
        allEmail.add(msg);
        
        Messaging.sendEmail(allEmail);
        
        updateContactPhoneBatch updat= new updateContactPhoneBatch();
		Database.ExecuteBatch(updat, 200);
        
    }
}