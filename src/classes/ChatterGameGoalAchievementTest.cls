/*
Copyright (c) 2011 salesforce.com, inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

By: Chris Kemp <ckemp@salesforce.com>
*/

@isTest
private class ChatterGameGoalAchievementTest {

    static User user1 = null;
    static User user2 = null;
    
    static testMethod void buildUp() {
        
        if (user1 == null) {
            ChatterGameGoalAchievementTest.user1 = GamificationTestUtility.createTestUser('System Administrator');
        }
        if (user2 == null) {
            ChatterGameGoalAchievementTest.user2 = GamificationTestUtility.createTestUser('Chatter Free User');
        }
    }   

    static testMethod void testGetOptions() {
        ChatterGameGoalSetupWizardController controller = new ChatterGameGoalSetupWizardController();

        // Check that options are populating
        System.assert(0 < controller.getStep1Options().size());
        System.assert(0 < controller.getStatusOptions().size());
    }
    
    static testMethod void testAnyPost() {

        buildUp();

        System.runAs(ChatterGameGoalAchievementTest.user1) {

            PageReference pageRef = Page.ChatterGameGoalSetupWizard;
            Test.setCurrentPage(pageRef);
          
            ChatterGameGoalSetupWizardController controller = new ChatterGameGoalSetupWizardController();
    
            controller.step1 = 'Post';
            controller.setUsersSelected(new String[]{ChatterGameGoalAchievementTest.user1.Id, 
                ChatterGameGoalAchievementTest.user2.Id});

            Set<String> selectedUsers = new Set<String>{};
            selectedUsers.addAll(controller.getUsersSelected());
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user1.Id));
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user2.Id));
    
            controller.name = 'Goal for Any Post';
            controller.description = 'This is a test Goal which gives points for adding any type of post in Chatter.';
            controller.rewardAmount = '111';
            controller.status = 'Active';
            String nextPage = controller.action().getUrl();
    
            // Verify that the success page displays  
            System.assert(nextPage == '/apex/ChatterGameGoalSetupSuccess' || 
                nextPage == '/apex/chattergame__ChatterGameGoalSetupSuccess');
    
            // Verify rules were added
            System.assertEquals(2, [select count() from Goal_Participant__c where CreatedById = :user1.Id]);

            // Create a status update feed item
            Test.startTest();
            FeedItem testFeedItem = new FeedItem();
            testFeedItem.Type = 'TextPost';
            testFeedItem.Body = 'Test post 1';
            testFeedItem.ParentId = ChatterGameGoalAchievementTest.user1.Id;
            insert testFeedItem;

            // Check that reward was given
            Test.stopTest();
            System.assert(0 < [select count() from Achievement__c 
                where User__c = :ChatterGameGoalAchievementTest.user1.Id AND Points_Awarded__c = 111]);
        }      
    }

    static testMethod void testPostFile() {

        buildUp();

        System.runAs(ChatterGameGoalAchievementTest.user1) {

            PageReference pageRef = Page.ChatterGameGoalSetupWizard;
            Test.setCurrentPage(pageRef);
          
            ChatterGameGoalSetupWizardController controller = new ChatterGameGoalSetupWizardController();
    
            controller.step1 = 'PostFile';
            controller.setUsersSelected(new String[]{ChatterGameGoalAchievementTest.user1.Id, 
                ChatterGameGoalAchievementTest.user2.Id});

            Set<String> selectedUsers = new Set<String>{};
            selectedUsers.addAll(controller.getUsersSelected());
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user1.Id));
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user2.Id));
    
            controller.name = 'Goal for Posting Files';
            controller.description = 'This is a test Goal which gives pointsfor creating a post with a file attachment.';
            controller.rewardAmount = '222';
            controller.status = 'Active';
            String nextPage = controller.action().getUrl();
    
            // Verify that the success page displays  
            System.assert(nextPage == '/apex/ChatterGameGoalSetupSuccess' || 
                nextPage == '/apex/chattergame__ChatterGameGoalSetupSuccess');
    
            // Verify rules were added
            System.assertEquals(2, [select count() from Goal_Participant__c where CreatedById = :user1.Id]);

            // Create a post
            Test.startTest();
            FeedItem goodFeedItem = new FeedItem();
            goodFeedItem.Type = 'ContentPost';
            goodFeedItem.ContentFileName = 'Test_file.txt';
            goodFeedItem.ContentData = Crypto.generateDigest('SHA1',Blob.valueOf('Test post 3 (positive)'));
            goodFeedItem.ParentId = ChatterGameGoalAchievementTest.user1.Id;
            insert goodFeedItem;
 
            // Check that reward was given
            Test.stopTest();
            System.assert(0 < [select count() from Achievement__c 
                where User__c = :ChatterGameGoalAchievementTest.user1.Id AND Points_Awarded__c = 222]);
        }      
    }


    static testMethod void testPostLink() {

        buildUp();

        System.runAs(ChatterGameGoalAchievementTest.user1) {

            PageReference pageRef = Page.ChatterGameGoalSetupWizard;
            Test.setCurrentPage(pageRef);
          
            ChatterGameGoalSetupWizardController controller = new ChatterGameGoalSetupWizardController();
    
            controller.step1 = 'PostLink';
            controller.setUsersSelected(new String[]{ChatterGameGoalAchievementTest.user1.Id, 
                ChatterGameGoalAchievementTest.user2.Id});

            Set<String> selectedUsers = new Set<String>{};
            selectedUsers.addAll(controller.getUsersSelected());
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user1.Id));
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user2.Id));
    
            controller.name = 'Goal for Posting Links';
            controller.description = 'This is a test Goal which gives pointsfor creating a post and attaching a link.';
            controller.rewardAmount = '333';
            controller.status = 'Active';
            String nextPage = controller.action().getUrl();
    
            // Verify that the success page displays  
            System.assert(nextPage == '/apex/ChatterGameGoalSetupSuccess' || 
                nextPage == '/apex/chattergame__ChatterGameGoalSetupSuccess');
    
            // Verify rules were added
            System.assertEquals(2, [select count() from Goal_Participant__c where CreatedById = :user1.Id]);

            // Create a post
            Test.startTest();
            FeedItem goodFeedItem = new FeedItem();
            goodFeedItem.Type = 'LinkPost';
            goodFeedItem.LinkUrl = 'http://www.salesforce.com';
            goodFeedItem.Title = 'Salesforce.com web site';
            goodFeedItem.ParentId = ChatterGameGoalAchievementTest.user1.Id;
            insert goodFeedItem;
 
            // Check that reward was given
            Test.stopTest();
            System.assert(0 < [select count() from Achievement__c 
                where User__c = :ChatterGameGoalAchievementTest.user1.Id AND Points_Awarded__c = 333]);
        }      
    }


    static testMethod void testPostComment() {

        buildUp();

        System.runAs(ChatterGameGoalAchievementTest.user1) {

            PageReference pageRef = Page.ChatterGameGoalSetupWizard;
            Test.setCurrentPage(pageRef);
          
            ChatterGameGoalSetupWizardController controller = new ChatterGameGoalSetupWizardController();
    
            controller.step1 = 'Comment';
            controller.setUsersSelected(new String[]{ChatterGameGoalAchievementTest.user1.Id, 
                ChatterGameGoalAchievementTest.user2.Id});

            Set<String> selectedUsers = new Set<String>{};
            selectedUsers.addAll(controller.getUsersSelected());
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user1.Id));
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user2.Id));
    
            controller.name = 'Goal for Posting Comments';
            controller.description = 'This is a test Goal which gives pointsfor creating a comment on a post.';
            controller.rewardAmount = '444';
            controller.status = 'Active';
            String nextPage = controller.action().getUrl();
    
            // Verify that the success page displays  
            System.assert(nextPage == '/apex/ChatterGameGoalSetupSuccess' || 
                nextPage == '/apex/chattergame__ChatterGameGoalSetupSuccess');
    
            // Verify rules were added
            System.assertEquals(2, [select count() from Goal_Participant__c where CreatedById = :user1.Id]);

            // Create a post
            Test.startTest();
            FeedItem feedItem = new FeedItem();
            feedItem.Type = 'TextPost';
            feedItem.Body = 'Test post 1';
            feedItem.ParentId = ChatterGameGoalAchievementTest.user1.Id;
            insert feedItem;

            FeedComment feedComment = new FeedComment();
            feedComment.FeedItemId = feedItem.Id;
            feedComment.CommentBody = 'This is a feed comment';
            insert feedComment;
            
            // Check that reward was given
            Test.stopTest();
            System.assert(0 < [select count() from Achievement__c 
                where User__c = :ChatterGameGoalAchievementTest.user1.Id AND Points_Awarded__c = 444]);
            }      
    }


    static testMethod void testPostLike() {

        buildUp();

        System.runAs(ChatterGameGoalAchievementTest.user1) {

            PageReference pageRef = Page.ChatterGameGoalSetupWizard;
            Test.setCurrentPage(pageRef);
          
            ChatterGameGoalSetupWizardController controller = new ChatterGameGoalSetupWizardController();
    
            controller.step1 = 'Likes';
            controller.setUsersSelected(new String[]{ChatterGameGoalAchievementTest.user1.Id, 
                ChatterGameGoalAchievementTest.user2.Id});

            Set<String> selectedUsers = new Set<String>{};
            selectedUsers.addAll(controller.getUsersSelected());
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user1.Id));
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user2.Id));
    
            controller.name = 'Goal for Having Posts Liked';
            controller.description = 'This is a test Goal which gives points for creating a comment on a post.';
            controller.rewardAmount = '555';
            controller.status = 'Active';
            String nextPage = controller.action().getUrl();
    
            // Verify that the success page displays  
            System.assert(nextPage == '/apex/ChatterGameGoalSetupSuccess' || 
                nextPage == '/apex/chattergame__ChatterGameGoalSetupSuccess');
    
            // Verify rules were added
            System.assertEquals(2, [select count() from Goal_Participant__c where CreatedById = :user1.Id]);
        }

        FeedItem feedItem;
        System.runAs(ChatterGameGoalAchievementTest.user1) {
            // Create a post
            feedItem = new FeedItem();
            feedItem.Type = 'TextPost';
            feedItem.Body = 'Test post 1';
            feedItem.ParentId = ChatterGameGoalAchievementTest.user1.Id;
            insert feedItem;
        }      

        System.runAs(ChatterGameGoalAchievementTest.user2) {
            // Create a like on the post
            FeedLike feedLike = new FeedLike();
            feedLike.FeedItemId = feedItem.Id;
            insert feedLike;
        }
        
        System.runAs(ChatterGameGoalAchievementTest.user1) {
            Test.startTest();
            ChatterGameGoalAchievement.checkLikes();
 
            // Check that reward was given
            Test.stopTest();
            System.assert(0 < [select count() from Achievement__c 
                where User__c = :ChatterGameGoalAchievementTest.user1.Id AND Points_Awarded__c = 555]);
        }
    }


    static testMethod void testFollowUser() {

        buildUp();

        System.runAs(ChatterGameGoalAchievementTest.user1) {

            PageReference pageRef = Page.ChatterGameGoalSetupWizard;
            Test.setCurrentPage(pageRef);
          
            ChatterGameGoalSetupWizardController controller = new ChatterGameGoalSetupWizardController();
    
            controller.step1 = 'FollowUser';
            controller.setUsersSelected(new String[]{ChatterGameGoalAchievementTest.user1.Id, 
                ChatterGameGoalAchievementTest.user2.Id});

            Set<String> selectedUsers = new Set<String>{};
            selectedUsers.addAll(controller.getUsersSelected());
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user1.Id));
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user2.Id));
    
            controller.name = 'Goal for Following Users';
            controller.description = 'This is a test Goal which gives points for following other users.';
            controller.rewardAmount = '666';
            controller.status = 'Active';
            String nextPage = controller.action().getUrl();
    
            // Verify that the success page displays  
            System.assert(nextPage == '/apex/ChatterGameGoalSetupSuccess' || 
                nextPage == '/apex/chattergame__ChatterGameGoalSetupSuccess');
    
            // Verify rules were added
            System.assertEquals(2, [select count() from Goal_Participant__c where CreatedById = :user1.Id]);
        }

        System.runAs(ChatterGameGoalAchievementTest.user1) {

            // Follow other user
            EntitySubscription goodFollow = new EntitySubscription();
            goodFollow.ParentId = ChatterGameGoalAchievementTest.user2.Id;
            goodFollow.SubscriberId = ChatterGameGoalAchievementTest.user1.Id;
            insert goodFollow;

            Test.startTest();
            ChatterGameGoalAchievement.checkFollows();
 
            // Check that reward was given
            Test.stopTest();
            System.assert(0 < [select count() from Achievement__c 
                where User__c = :ChatterGameGoalAchievementTest.user1.Id AND Points_Awarded__c = 666]);
        }      
    }


    static testMethod void testFollowItem() {

        buildUp();

        System.runAs(ChatterGameGoalAchievementTest.user1) {

            PageReference pageRef = Page.ChatterGameGoalSetupWizard;
            Test.setCurrentPage(pageRef);
          
            ChatterGameGoalSetupWizardController controller = new ChatterGameGoalSetupWizardController();
    
            controller.step1 = 'FollowItem';
            controller.setUsersSelected(new String[]{ChatterGameGoalAchievementTest.user1.Id, 
                ChatterGameGoalAchievementTest.user2.Id});

            Set<String> selectedUsers = new Set<String>{};
            selectedUsers.addAll(controller.getUsersSelected());
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user1.Id));
            System.assert(selectedUsers.contains(ChatterGameGoalAchievementTest.user2.Id));
    
            controller.name = 'Goal for Following Items';
            controller.description = 'This is a test Goal which gives points for following other non-user records.';
            controller.rewardAmount = '777';
            controller.status = 'Active';
            String nextPage = controller.action().getUrl();
    
            // Verify that the success page displays  
            System.assert(nextPage == '/apex/ChatterGameGoalSetupSuccess' || 
                nextPage == '/apex/chattergame__ChatterGameGoalSetupSuccess');
    
            // Verify rules were added
            System.assertEquals(2, [select count() from Goal_Participant__c where CreatedById = :user1.Id]);
        }
        
        Goal__c newGoal;
        System.runAs(ChatterGameGoalAchievementTest.user1) {

            // Create a non-user record to follow
            newGoal = new Goal__c();
            newGoal.Name = 'My test goal';
            newGoal.Reward_Amount__c = 123;
            newGoal.Status__c = 'Active';
            insert newGoal;

            // Follow a non-user record
            EntitySubscription goodFollow = new EntitySubscription();
            goodFollow.ParentId = newGoal.Id;
            goodFollow.SubscriberId = ChatterGameGoalAchievementTest.user1.Id;
            insert goodFollow;
        
            ChatterGameGoalAchievement.checkFollows();
            Test.startTest();

            // Check that reward was given
            Test.stopTest();
            System.assert(0 < [select count() from Achievement__c 
                where User__c = :ChatterGameGoalAchievementTest.user1.Id AND Points_Awarded__c = 777]);
        }      
    }
}