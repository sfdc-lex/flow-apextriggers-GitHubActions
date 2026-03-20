@isTest
public class AddAttendeeControllerTest {

    @isTest
    static void testCreateAttendeeAndTicket() {

        // 1. Create Venue (IMPORTANT for Location__r.Name)
        Venue__c venue = new Venue__c(
            Name = 'Test Venue'
        );
        insert venue;

        // 2. Create Event with ALL required fields
        Event__c eventRec = new Event__c(
            Name = 'Test Event',
            Location__c = venue.Id,
            TicketPrefix__c = 'TKT-',
            TicketPrice__c = 100,
            EarlybirdTicketPrice__c = 80,
            EarlybirdActive__c = true,
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(1)
        );
        insert eventRec;

        // 3. Prepare wrapper (THIS WAS YOUR MAIN ISSUE)
        AddAttendeeController.InputWrapper wrapper = new AddAttendeeController.InputWrapper();
        wrapper.name = 'John Doe';
        wrapper.email = 'john@test.com';
        wrapper.phone = '1234567890';
        wrapper.jobTitle = 'Engineer';
        wrapper.companyName = 'Test Company';
        wrapper.eventId = eventRec.Id; // 🔥 MUST NOT BE NULL

        Test.startTest();
        AddAttendeeController.addAttendee(wrapper);
        Test.stopTest();

        // 4. Validate Attendee
        List<Attendee__c> attendees = [SELECT Id FROM Attendee__c];
        System.assertEquals(1, attendees.size());

        // 5. Validate Ticket
        List<Ticket__c> tickets = [SELECT Id, TicketSent__c FROM Ticket__c];
        System.assertEquals(1, tickets.size());
        System.assertEquals(true, tickets[0].TicketSent__c);
    }
}