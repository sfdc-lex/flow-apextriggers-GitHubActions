@isTest
public class OpportunityTriggerHandlerTest {

    @isTest
    static void testOpportunityToQuoteFlow() {

        Pricebook2 pb = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        Product2 prod = new Product2(Name='Test Product', IsActive=true);
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pb.Id,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;

        Opportunity opp = new Opportunity(
            Name='Test Opp',
            StageName='Prospecting',
            CloseDate=Date.today(),
            Pricebook2Id = pb.Id
        );
        insert opp;

        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 1,
            UnitPrice = 100
        );
        insert oli;

        // 🔥 Trigger fires here
        opp.StageName = 'Closed Won';
        update opp;

        List<Quote> quotes = [SELECT Id FROM Quote WHERE OpportunityId = :opp.Id];
        System.assertEquals(1, quotes.size());

        List<QuoteLineItem> qlis = [SELECT Id FROM QuoteLineItem WHERE QuoteId = :quotes[0].Id];
        System.assertEquals(1, qlis.size());
    }
}