@IsTest
private class AEA_Account_Research_Hardening_Test {
    @IsTest static void startsReportsWithBulkAccountLookup() {
        Account a = new Account(Name='Acme AEA');
        insert a;
        List<String> results = AEA_Account_Research_Flow_Starter.startFlow(new List<Id>{ a.Id });
        System.assertEquals(1, results.size());
        System.assert(results[0].contains('Acme AEA'));
    }
}
