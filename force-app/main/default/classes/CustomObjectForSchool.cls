public class CustomObjectForSchool {
    public static void createNewRecord(){
        Class__c c = new  Class__c();
        c.Name = 'Apex Test class';
        c.Fees__c = 100000;
        c.Course_Duration__c = '6 Month';
        insert c;
        
        Student__c s = new 	Student__c();
        s.Name__c = 'Apex Student';
        s.Entrance_Score__c = 698;
        s.Age__c = 24;
        s.Email__c = 'apex.test@gmail.com';
        s.Class__c = c.Id;
        insert s;
        
        
        
        Instructor__c inst = new Instructor__c();
        inst.Name__c = 'Apex Instructor';
        inst.Salary__c = 10000;
        inst.Rating__c = 4;
        inst.Year_Of_Experience__c = 4;
        insert inst;
        
    }
    
    // We use Record type id dynamically because of record Type/ we can use trigger
    
    
    public static void createStudent(){
        Student__c s = new 	Student__c(Name__c = 'APEX sTUDENT 104', Email__c='apex.student104@gmail.com',  recordTypeId= '012WU0000044d0TYAQ' );
        Student__c s1 = new 	Student__c(Name__c = 'APEX sTUDENT 105', Email__c='apex.student105@gmail.com',  recordTypeId= '012WU0000044d0TYAQ' );
        Student__c s2 = new 	Student__c(Name__c = 'APEX sTUDENT 106', Email__c='apex.student106@gmail.com', Entrance_Score__c = 698);
        Student__c s3 = new 	Student__c(Name__c = 'APEX sTUDENT 107', Email__c='apex.student107@gmail.com',  Entrance_Score__c = 698);
        
        List<Student__c> slist = new List<Student__c>();
        slist.add(s);
        slist.add(s1);
        slist.add(s2);
        slist.add(s3);
        
        insert slist;
    }
    
}