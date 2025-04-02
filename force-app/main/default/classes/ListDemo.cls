public class ListDemo {
    
    public static void color(){
        
        
        List<String> colour = new List<String>();
        colour.add('green');
        System.debug(colour);
        
        List<String> list2 = new List<String>();
        colour.add(0, 'red');
        list2.add('yellow');
        list2.addAll(colour);
        colour.set(2,'Blue');
        
        System.debug(list2);
        System.debug(colour+' : ' +colour.size());
    } 
}