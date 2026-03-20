@isTest
public with sharing class AddAttendeeControllerTest {

    @isTest
    static void testInputWrapper() {
        AddAttendeeController.InputWrapper inputWrapper = new AddAttendeeController.InputWrapper();
        inputWrapper.name = 'John Doe';
        inputWrapper.email = 'john.doe@example.com';
        inputWrapper.phone = '123-456-7890';
        inputWrapper.jobTitle = 'Software Engineer';
        inputWrapper.companyName = 'Tech Solutions';

        System.assertEquals('John Doe', inputWrapper.name);
        System.assertEquals('john.doe@example.com', inputWrapper.email);
        System.assertEquals('123-456-7890', inputWrapper.phone);
        System.assertEquals('Software Engineer', inputWrapper.jobTitle);
        System.assertEquals('Tech Solutions', inputWrapper.companyName);
    }

    @isTest
    static void testCreateAttendeeAndTicket() {

        // 1. Create Venue (required for Location__r.Name)
        Venue__c venue = new Venue__c(
            Name = 'Stage'
        );
        insert venue;

        // 2. Create Event with ALL required + used fields
        Event__c testEvent = new Event__c(
            Name = 'Test Event',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(1),
            Location__c = venue.Id,
            TicketPrefix__c = 'TICKET-',
            InvoicePrefix__c = 'INV-',
            TicketPrice__c = 10.00,
            EarlybirdTicketPrice__c = 5.00,
            EarlybirdActive__c = true, // 🔥 IMPORTANT FIX
            ShortDescription__c = 'Sample Description',
            Status__c = 'Planned'
        );
        insert testEvent;

        // 3. Prepare wrapper
        AddAttendeeController.InputWrapper inputWrapper = new AddAttendeeController.InputWrapper();
        inputWrapper.name = 'John Doe';
        inputWrapper.email = 'john.doe@example.com';
        inputWrapper.phone = '123-456-7890';
        inputWrapper.jobTitle = 'Software Engineer';
        inputWrapper.companyName = 'Tech Solutions';
        inputWrapper.eventId = testEvent.Id; // 🔥 MUST

        Test.startTest();
        AddAttendeeController.addAttendee(inputWrapper);
        Test.stopTest();

        // 4. Validate Attendee
        Attendee__c createdAttendee = [
            SELECT Id, Name, Email__c 
            FROM Attendee__c 
            WHERE Email__c = :inputWrapper.email 
            LIMIT 1
        ];
        System.assertNotEquals(null, createdAttendee);
        System.assertEquals('John Doe', createdAttendee.Name);

        // 5. Validate Ticket
        Ticket__c createdTicket = [
            SELECT Id, Attendee__c, TicketSent__c, TicketType__c 
            FROM Ticket__c 
            WHERE Attendee__c = :createdAttendee.Id 
            LIMIT 1
        ];

        System.assertNotEquals(null, createdTicket);
        System.assertEquals(createdAttendee.Id, createdTicket.Attendee__c);

        // Verify ticket sent logic
        System.assertEquals(true, createdTicket.TicketSent__c);

        // Verify Earlybird logic
        System.assertEquals('Earlybird', createdTicket.TicketType__c);
    }
}