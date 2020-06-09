@isTest
class PaginatedSelectListTest {
    static testMethod void testPaginatedSelectList() {
        PaginatedSelectList myList = new PaginatedSelectList();
        myList.add(new SelectOption('One', 'One'));
        myList.add(new SelectOption('Two', 'Two'));
        System.assertEquals(2, myList.getSize());
        System.assertEquals(2, myList.getSelectList().size());
        System.assertEquals(1, myList.getSubList(1, 1).size());
        System.assertEquals(2, myList.get0().size());
        System.assertEquals(0, myList.get1().size());
        System.assertEquals(0, myList.get2().size());
        System.assertEquals(0, myList.get3().size());
        System.assertEquals(0, myList.get4().size());
        System.assertEquals(0, myList.get5().size());
        System.assertEquals(0, myList.get6().size());
        System.assertEquals(0, myList.get7().size());
        System.assertEquals(0, myList.get8().size());
        System.assertEquals(0, myList.get9().size());
        System.assertEquals(0, myList.get10().size());
        System.assertEquals(0, myList.get11().size());
        System.assertEquals(0, myList.get12().size());
        System.assertEquals(0, myList.get13().size());
        System.assertEquals(0, myList.get14().size());
        System.assertEquals(0, myList.get15().size());
        System.assertEquals(0, myList.get16().size());
        System.assertEquals(0, myList.get17().size());
        System.assertEquals(0, myList.get18().size());
        System.assertEquals(0, myList.get19().size());
        myList.remove(1);
        System.assertEquals(1, myList.getSize());
        myList.clear();
        System.assertEquals(0, myList.getSize());
    }
}
