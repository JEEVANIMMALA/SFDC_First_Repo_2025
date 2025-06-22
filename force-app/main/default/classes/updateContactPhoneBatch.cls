global class updateContactPhoneBatch implements Database.Batchable<sObject>,Database.stateful{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id,name,Phone from Contact');
    }
    
    global void execute(Database.batchableContext BC, List<Contact> contacts) {
        List<Contact> conList = new List<Contact>();
        for(contact con:contacts) {
            con.Phone ='999';
            conList.add(con);
        }
        
        Update conList;
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('TEST PRINT---');
    }

}