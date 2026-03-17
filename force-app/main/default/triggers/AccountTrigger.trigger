trigger AccountTrigger on Account (before insert) {
  /* System.debug('AccountTrigger: before insert');
    System.debug('Inserted Records : ' + Trigger.New); */
    if (Trigger.isbefore && Trigger.isInsert){
        for(Account accRec : Trigger.new)
    {
        if(accRec.shippingStreet==null)
        accRec.ShippingStreet=accRec.BillingStreet;
        if(accRec.shippingCity==null)
        accRec.ShippingCity=accRec.ShippingCity;
        if(accRec.shippingState==null)
        accRec.ShippingState=accRec.ShippingState;
        if(accRec.shippingPostalCode==null)
        accRec.ShippingPostalCode=accRec.ShippingPostalCode;
        if(accRec.shippingCountry==null)
        accRec.ShippingCountry=accRec.ShippingCountry;
    }
    }
}