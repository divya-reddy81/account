public with sharing class AccountController {
    @AuraEnabled
    public static void updateAccountName(Id accountId, String newName) {
        try {
            Account acc = new Account(
                Id = accountId,
                Name = newName
            );
            update acc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
