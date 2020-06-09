@isTest
class RunBatchCheckControllerTest {
    @isTest
    static void testScheduledRun() {
        PageReference pageRef = RunBatchCheckController.run();
        System.assert(null != pageRef);
    }
}
