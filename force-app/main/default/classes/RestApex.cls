@RestResource(urlMapping='/orderdetails/*')
global class RestApex {
    
    global class orderDetails{
        String OrderName {get;set;}
        String description {get;set;}
        String OrderStatus {get;set;}
        Boolean isActive {get;set;}
    }

    @HttpGet
    global static orderDetails getOrderDetails() {
        RestRequest req = RestContext.Request;
        System.debug('TEST1---'+req.RequestURI);
        System.debug('TEST12---'+req.RequestURI.lastIndexOf('/'));
        String orderid = req.RequestURI.substring(req.RequestURI.lastIndexOf('/')+1);
        List<Order__c> ordeRec = [SELECT ID,Name, Active__c,Description__c,Status__c FROM Order__c WHERE ID =:orderid];
        orderDetails ord = new orderDetails();
        ord.OrderName = ordeRec[0].Name;
        ord.isActive = ordeRec[0].Active__c;
        ord.description = ordeRec[0].Description__c;
        ord.OrderStatus = ordeRec[0].Status__c;
        
        return ord;
    }
}