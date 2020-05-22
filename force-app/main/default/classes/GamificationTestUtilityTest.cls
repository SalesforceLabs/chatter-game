@isTest
class GamificationTestUtilityTest {
    @isTest
    static void testRandomWord() {
        System.assert(
            GamificationTestUtility.createRandomWord() !=
            GamificationTestUtility.createRandomWord()
        );
    }

    @isTest
    static void testCreateUser() {
        User u = GamificationTestUtility.createTestUser('Standard User');
        System.assert(u.id != null);
    }
}
