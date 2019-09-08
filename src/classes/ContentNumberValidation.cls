/**
 * Created by ociszek001 on 15.05.2019.
 */

public with sharing class ContentNumberValidation {
/*
    public static void validateContentCount(List<ContentDocumentLink> cdlList) {
        Set<Id> sellerIdList = new Set<Id>();
        for (ContentDocumentLink cdl : cdlList) {
            if('V'.Equals(cdl.ShareType))
                sellerIdList.add(cdl.LinkedEntityId);
        }
        for (Id sId : sellerIdList) {
            for (AggregateResult ar : [SELECT COUNT(ContentDocumentId) cdlcount from ContentDocumentLink WHERE LinkedEntityId = :sId]) {
                if (Integer.valueOf(ar.get('cdlcount')) == 1) {
                    throw new OCInvoiceException('Cannot add file');
                }
            }
        }
    }
}
*/
}