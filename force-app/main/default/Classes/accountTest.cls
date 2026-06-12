@isTest
private class AccountControllerTest {
    @isTest
    static void testUpdateAccountName() {
        // Create test data
        Account testAcc = new Account(Name = 'Test Intelligence Corp');
        insert testAcc;

        // Execute target method
        Test.startTest();
        AccountController.updateAccountName(testAcc.Id);
        Test.stopTest();

        // Verify the update took place
        Account updatedAcc = [SELECT Name FROM Account WHERE Id = :testAcc.Id];
        System.assertEquals('Test Intelligence Corp-Updated', updatedAcc.Name, 'The account name should have the suffix appended.');
    }

    @isTest
    static void testUpdateAccountNameException() {
        // Execute method with an invalid ID to trigger exception block
        Test.startTest();
        try {
            AccountController.updateAccountName(null);
            System.assert(false, 'An exception should have been thrown.');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage() != null, 'Exception message should not be empty.');
        }
        Test.stopTest();
    }
}
