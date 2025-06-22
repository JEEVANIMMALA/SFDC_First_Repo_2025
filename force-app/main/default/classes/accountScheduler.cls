global class accountScheduler implements Schedulable {

    public void execute(SchedulableContext SC) {
        List<Account> allList = [SELECT ID,Name,Scheduled_Apex_Date_Fill__c FROM Account];
        List<Account> accountsToBeUpdated = new List<Account>();
        
        for(account acc: allList) {
            DateTime now = DateTime.now();
            acc.Scheduled_Apex_Date_Fill__c = now.format();
            accountsToBeUpdated.add(acc);
        }
        
        update accountsToBeUpdated;
        
        AccountUpdateBatch temp = new AccountUpdateBatch();
        Database.executeBatch(temp,200);
        
        Messaging.singleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<String> emailstr= new List<String>();
        emailstr.add('jeevan.sai.nimmala@accenture.com');
        emailstr.add('jeevansainimmala@gmail.com');
        msg.setToAddresses(emailstr);
        msg.setSubject('Batch apex Updated');
        msg.setPlainTextBody('Schedule bacth org executed these accountss '+accountsToBeUpdated);
        List<Messaging.singleEmailMessage> allEmail = new List<Messaging.singleEmailMessage>();
        allEmail.add(msg);
        
        Messaging.sendEmail(allEmail);
    }
}