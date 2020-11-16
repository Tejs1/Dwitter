pragma solidity ^0.6.0;
contract TweetServices  {

    struct Comment {
        address commenter; 
        bytes text; 
    }

    struct Tweet {
        uint256 tweetId;
        uint256 time;
        uint256 commentID;
        address tweeter;
        mapping(uint256 => Comment) comment;
        bytes content;
    }
    

    IdentityRegistry internal identityRegistry;

    mapping (address => mapping(uint256 => Tweet)) public tweets;
    mapping (address => uint256) internal tweetPostedNo;
    
    event NewTweet(address indexed tweetOwner, uint256 indexed tweetId, uint256 indexed tweetTime);
    event CommentTweet(address indexed commenter, address indexed tweetOwner, uint256 indexed tweetId);
   
    
    }
   
    function tweetNewPost(bytes memory content) validUser(ClaimHolder(msg.sender)) public returns(bool) {
        Tweet memory newTweet;
        newTweet.tweetId = tweetPostedNo[msg.sender] + 1;
        newTweet.tweeter = msg.sender;
        newTweet.time = now;
        newTweet.content = content;
        tweets[msg.sender][newTweet.tweetId] = newTweet;
        tweetPostedNo[msg.sender]++;
        emit NewTweet(msg.sender, newTweet.tweetId, now);
        return true;
    }

   
    
    function commentOnTweet(address tweetOwner, uint256 tweetId, bytes memory text) 
            validUser(ClaimHolder(msg.sender)) 
            validTweet(tweetOwner, tweetId)
            public returns(bool) 
    {
        Comment memory newComment;
        newComment.text = text;
        newComment.commenter = msg.sender;
        tweets[tweetOwner][tweetId].comment[tweets[tweetOwner][tweetId].commentID] = newComment;
        tweets[tweetOwner][tweetId].commentID++;
        emit CommentTweet(msg.sender, tweetOwner, tweetId);
        return true;
    }
}