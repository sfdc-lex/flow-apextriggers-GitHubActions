@isTest
public class QuoteTriggerHandlerTest {

    @isTest
    static void testQuoteToOrderFlow() {

        Pricebook2 pb = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        Account acc = new Account(Name='Test Acc');
        insert acc;

        Product2 prod = new Product2(Name='Test Product', IsActive=true);
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pb.Id,
            Product2Id = prod.Id,
            UnitPrice = 200,
            IsActive = true
        );
        insert pbe;

        Opportunity opp = new Opportunity(
            Name='Test Opp',
            StageName='Prospecting',
            CloseDate=Date.today(),
            AccountId = acc.Id,
            Pricebook2Id = pb.Id
        );
        insert opp;

        Quote q = new Quote(
            Name='Test Quote',
            OpportunityId=opp.Id,
            AccountId=acc.Id,
            Pricebook2Id=pb.Id,
            Status='Draft'
        );
        insert q;

        QuoteLineItem qli = new QuoteLineItem(
            QuoteId=q.Id,
            PricebookEntryId=pbe.Id,
            Quantity=1,
            UnitPrice=200
        );
        insert qli;

        // 🔥 Trigger fires here
        q.Status = 'Accepted';
        update q;

        List<Order> orders = [SELECT Id FROM Order WHERE AccountId = :acc.Id];
        System.assertEquals(1, orders.size());

        List<OrderItem> ois = [SELECT Id FROM OrderItem WHERE OrderId = :orders[0].Id];
        System.assertEquals(1, ois.size());
    }
}