public with sharing class OpportunityTriggerHandler {

    public static void handleAfterUpdate(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunityMap) {

        List<Quote> quotesToInsert = new List<Quote>();
        Map<Id, Id> oppToQuoteMap = new Map<Id, Id>();

        for (Opportunity opp : newOpportunities) {
            Opportunity oldOpp = oldOpportunityMap.get(opp.Id);

            if (opp.StageName == 'Closed Won' && opp.IsClosed && !oldOpp.IsClosed) {
                Quote q = new Quote(
                    OpportunityId = opp.Id,
                    Name = opp.Name + ' Quote',
                    Status = 'Draft',
                    Pricebook2Id = opp.Pricebook2Id
                );
                quotesToInsert.add(q);
            }
        }

        if (!quotesToInsert.isEmpty()) {
            insert quotesToInsert;

            for (Quote q : quotesToInsert) {
                oppToQuoteMap.put(q.OpportunityId, q.Id);
            }

            List<OpportunityLineItem> olis = [
                SELECT OpportunityId, PricebookEntryId, Quantity, UnitPrice
                FROM OpportunityLineItem
                WHERE OpportunityId IN :oppToQuoteMap.keySet()
            ];

            List<QuoteLineItem> qlis = new List<QuoteLineItem>();

            for (OpportunityLineItem oli : olis) {
                qlis.add(new QuoteLineItem(
                    QuoteId = oppToQuoteMap.get(oli.OpportunityId),
                    PricebookEntryId = oli.PricebookEntryId,
                    Quantity = oli.Quantity,
                    UnitPrice = oli.UnitPrice
                ));
            }

            if (!qlis.isEmpty()) {
                insert qlis;
            }
        }
    }
}