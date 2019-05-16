/**
 * Created by ociszek001 on 16.05.2019.
 */

public with sharing class ContentTriggerHandler {
    final List<ContentDocumentLink> newRecords;

    public ContentTriggerHandler(List<ContentDocumentLink> newRecords) {
        this.newRecords = newRecords;
    }

    public void beforeInsert() {
       ContentNumberValidation.validateContentCount(newRecords);
    }
}