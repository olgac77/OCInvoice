//Created by ociszek001 on 07.05.2019.



public with sharing class AmountToText {

    public static void showAmountAsText(List<Service__c> ser) {
       Set<Id> invoiceIdList = new Set<Id>();
        for (Service__c s : ser) {
            invoiceIdList.add(s.Invoice__c);
        }
        List<Invoice__c> invoices = [SELECT Id, Gross_Total__c, Amount_in_words__c FROM Invoice__c WHERE Id = :invoiceIdList];
        if(invoices!=null||!invoices.isEmpty()) {
            for (Invoice__C inv : invoices) {
                inv.Amount_in_words__c= Convert(inv.Gross_Total__c);
            }
            update invoices;
        }
    }

    public static String Convert(Decimal amount) {
        List<String> singles = new List <String>{'', 'jeden ', 'dwa ', 'trzy ', 'cztery ',
                'pięć ', 'sześć ', 'siedem ', 'osiem ', 'dziewięć '};

        List<String> teens =new List<String>{
                '', 'jedenaście ', 'dwanaście ', 'trzynaście ',
                'czternaście ', 'piętnaście ', 'szesnaście ', 'siedemnaście ',
                'osiemnaście ', 'dziewiętnaście '};

        List<String> tens =new List<String>{
                '', 'dziesięć ', 'dwadzieścia ',
                'trzydzieści ', 'czterdzieści ', 'pięćdziesiąt ',
                'sześćdziesiąt ', 'siedemdziesiąt ', 'osiemdziesiąt ',
                'dziewięćdziesiąt '};

        List<String> hundreds =new List<String>{
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
        Integer zloty = Integer.valueOf(arr[0]);
        Integer gr = Integer.valueOf(arr[1]);
        String grs = String.valueOf(gr)+'/100';
        while(zloty!=0){
            s = math.mod(zloty, 1000) / 100;
            d = math.mod(zloty,100) / 10;
            j = math.mod(zloty,10);
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
            if (s+d+n+j > 0) {
                inWords = hundreds[(Integer) s] + tens[(Integer) d] + teens[(Integer) n]
                + singles[(Integer) j] + groups[(Integer) g][(Integer) k] + inWords;
            }
            zloty = zloty / 1000;
            g = g + 1;
        }
        String country=UserInfo.getLocale();
        List<Currency_format__mdt> currencyFormat = [SELECT Currency__c, Currency_at_the_end__c FROM Currency_format__mdt WHERE Country__c=:country];
        if(currencyFormat!=null||!currencyFormat.isEmpty()){
            for (Currency_format__mdt cur:currencyFormat) {
                if (cur.Currency_at_the_end__c) {
                    inWords = sign + inWords + ' ' + grs + ' ' + cur.Currency__c;
                    return inWords;
                }
                    inWords = sign + inWords + cur.Currency__c + ' ' + grs;
                    return inWords;
            }
        }
        return inWords;
    }
}