/**
 * Launches the Agentforce_Account_Research_Report_Creator_Flow_AEA for Account records.
 */
public with sharing class AEA_Account_Research_Flow_Starter {
  @InvocableMethod(
    label = 'Start AEA Account Research Report'
    description = 'Enqueues the AEA research Flow for each supplied Account Id.'
  )
  public static List<String> startFlow(List<Id> accountIds) {
    if (accountIds == null || accountIds.isEmpty()) {
      return new List<String>();
    }
    Set<Id> uniqueIds = new Set<Id>();
    for (Id accountId : accountIds) {
      if (accountId != null) uniqueIds.add(accountId);
    }
    Map<Id, Account> accountsById = new Map<Id, Account>([
      SELECT Id, Name
      FROM Account
      WHERE Id IN :uniqueIds
    ]);
    List<String> results = new List<String>();
    for (Id accountId : accountIds) {
      if (accountId == null || !accountsById.containsKey(accountId)) {
        results.add('No account research report was started because the account was not found.');
        continue;
      }
      System.enqueueJob(new AEA_Account_Research_Queueable(accountId));
      results.add('I have successfully started an account research report on ' + accountsById.get(accountId).Name + '. I will notify you when the Agent has finished the research.');
    }
    return results;
  }
}
