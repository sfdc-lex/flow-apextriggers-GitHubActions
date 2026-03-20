public with sharing class QuoteTriggerHandler {

    public static void handleAfterUpdate(List<Quote> newQuotes, Map<Id, Quote> oldQuoteMap) {

        List<Order> orders = new List<Order>();
        Map<Id, Id> quoteToOrderMap = new Map<Id, Id>();

        for (Quote q : newQuotes) {
            Quote oldQ = oldQuoteMap.get(q.Id);

            if (q.Status == 'Accepted' && oldQ.Status != 'Accepted') {
                Order o = new Order(
                    AccountId = q.AccountId,
                    EffectiveDate = Date.today(),
                    Status = 'Draft',
                    Pricebook2Id = q.Pricebook2Id
                );
                orders.add(o);
                quoteToOrderMap.put(q.Id, null);
            }
        }

        if (!orders.isEmpty()) {
            insert orders;

            Integer i = 0;
            for (Order o : orders) {
                quoteToOrderMap.put(newQuotes[i].Id, o.Id);
                i++;
            }

            List<QuoteLineItem> qlis = [
                SELECT QuoteId, PricebookEntryId, Quantity, UnitPrice
                FROM QuoteLineItem
                WHERE QuoteId IN :quoteToOrderMap.keySet()
            ];

            List<OrderItem> ois = new List<OrderItem>();

            for (QuoteLineItem qli : qlis) {
                ois.add(new OrderItem(
                    OrderId = quoteToOrderMap.get(qli.QuoteId),
                    PricebookEntryId = qli.PricebookEntryId,
                    Quantity = qli.Quantity,
                    UnitPrice = qli.UnitPrice
                ));
            }

            if (!ois.isEmpty()) {
                insert ois;
            }
        }
    }
}