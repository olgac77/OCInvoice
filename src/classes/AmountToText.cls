//Created by ociszek001 on 07.05.2019.



public with sharing class AmountToText {

    public static void showAmountAsText(List<Service__c> ser) {
       Set<Id> invoiceIdList = new Set<Id>();
        for (Service__c s : ser) {
            invoiceIdList.add(s.Invoice__c);
        }
        String[] result = new String[2];
        List<Invoice__c> invoices = [SELECT Id, Gross_Total__c, Amount_in_words__c, Amount_ending__c FROM Invoice__c WHERE Id = :invoiceIdList];
        if(!invoices.isEmpty()||invoices!=null) {
            for (Invoice__C inv : invoices) {
                System.debug('@@gr'+inv.Gross_Total__c);
                result = Convert(inv.Gross_Total__c);
                System.debug(result[0]+' ' +result[1]);
                inv.Amount_in_words__c=result[0];
                System.debug(inv.Amount_in_words__c);
                inv.Amount_ending__c=result[1];
            }
        }
        update invoices;
    }

    public static String[] Convert(Decimal amount) {
        String[] result = new String[2];
        String[] singles = new String[]{'', 'jeden ', 'dwa ', 'trzy ', 'cztery ',
                'pięć ', 'sześć ', 'siedem ', 'osiem ', 'dziewięć '};

        String[] teens =new String[]{
                '', 'jedenaście ', 'dwanaście ', 'trzynaście ',
                'czternaście ', 'piętnaście ', 'szesnaście ', 'siedemnaście ',
                'osiemnaście ', 'dziewiętnaście '};

        String[] tens =new String[]{
                '', 'dziesięć ', 'dwadzieścia ',
                'trzydzieści ', 'czterdzieści ', 'pięćdziesiąt ',
                'sześćdziesiąt ', 'siedemdziesiąt ', 'osiemdziesiąt ',
                'dziewięćdziesiąt '};

        String[] hundreds =new String[]{
                '', 'sto ', 'dwieście ', 'trzysta ', 'czterysta ',
                'pięćset ', 'sześćset ', 'siedemset ', 'osiemset ',
                'dziewięćset '};

        List<List<String>> groups =new List<List<String>>{
                new List<String>{'', '', ''},
                new List<String>{'tysiąc ', 'tysiące ', 'tysięcy '},
                new List<String>{'milion ', 'miliony ', 'milionów '},
                new List<String>{'miliard ', 'miliardy ', 'miliardów '},
                new List<String>{'bilion ', 'biliony ', 'bilionów '},
                new List<String>{'biliard ', 'biliardy ', 'biliardów '},
                new List<String>{'trylion ', 'tryliony ', 'trylionów '}};
        long j = 0, n = 0, d = 0, s = 0, g = 0, k = 0;
        String inWords = '';
        String sign = '';
        if (amount < 0) {
            sign = 'minus ';
            amount = -amount;
        }
        if (amount == 0) {
            sign = 'zero';
        }
        String[] arr=String.valueOf(amount).split('\\.');
        Integer zl = Integer.valueOf(arr[0]);
        Integer gr = Integer.valueOf(arr[1]);
        String grs = String.valueOf(gr)+'/100';
        System.debug(grs);
        while(zl!=0){

            s = math.mod(zl, 1000) / 100;
            d = math.mod(zl,100) / 10;
            j = math.mod(zl,10);

            if (d == 1 & j > 0) {
                n = j;
                d = 0;
                j = 0;
            } else {
                n = 0;
            }
            if (j == 1 & s + d + n == 0) {
                k = 0;

                if (s + d == 0 && g > 0) {
                    j = 0;
                    inWords = groups[(Integer) g][(Integer) k] + inWords;
                }
            } else if (j == 2) {
                k = 1;
            } else if (j == 3) {
                k = 1;
            } else if (j == 4) {
                k = 1;
            } else {
                k = 2;
            }
            System.debug(s+' '+d+' '+j+' '+g+' '+k);
            if (s+d+n+j > 0) {
                inWords = hundreds[(Integer) s] + tens[(Integer) d] + teens[(Integer) n]
                + singles[(Integer) j] + groups[(Integer) g][(Integer) k] + inWords;
            }
            zl = zl / 1000;
            g = g + 1;
        }
        inWords = sign + inWords;
        result[0]=inWords;
        result[1]=(grs);
        System.debug(result);
        return result;
    }
}