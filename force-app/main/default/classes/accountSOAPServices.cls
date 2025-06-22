global class accountSOAPServices {
	
    webservice static account getAccounts(String accId) {
        Account acc = [SELECT ID, Name ,CreatedBy.Name, Phone FROM Account WHERE Id=:accId];
        
        return acc;
    }
}