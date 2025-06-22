public class IntegrationS2SOrgA {

    public static void sendcallout() {
        httpRequest request = new httpRequest();
        http p = new http();
        request.setEndpoint('callout:S2SIntegration/services/apexrest/getaccountlist');
        request.setMethod('GET');
        HttpResponse response = p.send(request);
        System.debug('RESPONSE=-----'+response.getBody());
        if(response.getStatusCode() == 200) {
            List<Account> receivedAccount = (List<Account>) JSON.deserialize(response.getBody(), List<Account>.class);
            List<Account> accToinset = new List<Account>();
            for(account acc :receivedAccount ) {
                List<Account> existingAcc = [SELECT ID, name , Industry FROM Account WHERE Name=: acc.name LIMIT 1];
                if(existingAcc.size()>0) {
                    System.debug('RESPONSE_Existing=-----'+existingAcc[0]);
                    acc.Id = existingAcc[0].Id;
                    acc.Name = existingAcc[0].Name;
                    accToinset.add(acc);
                } else {
                    System.debug('RESPONSE_New=-----'+acc);
                    Account acc2 = new Account();
                    acc2.Name = acc.Name;
                    acc2.Industry = acc.Industry;
                    accToinset.add(acc2);
                }
                
                System.debug('RESPONSE22=-----'+acc);
            }
            try{
                Upsert accToinset;
            }catch(Exception ex) {
                System.debug(ex.getMessage()+'---'+ex.getLineNumber());
            }
            
        }
    }
}