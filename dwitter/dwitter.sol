pragma solidity ^0.7.0;
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
    
    struct Tag {
        bytes tag;
    }

    
    mapping (address => mapping(uint256 => Tweet)) public tweets;
    mapping (address => uint256) internal tweetPostedNo;
    
    event NewTweet(address indexed tweetOwner, uint256 indexed tweetId, uint256 indexed tweetTime);
    event CommentTweet(address indexed commenter, address indexed tweetOwner, uint256 indexed tweetId);
    event TagTweet(uint256 indexed tweetId);
    
    }
   
    function tweetNewPost(bytes memory content) validUser(ClaimHolder(msg.sender)) public returns(bool) {
        Tweet memory newTweet;
        newTweet.tweetId = tweetPostedNo[msg.sender] + 1;
        newTweet.tweeteime r = msg.sender;
        newTweet.t= now;
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

    function tagofTweet(uint256 tweetId, bytes memory tag)
            validUser(ClaimHolder(msg.sender)) 
            validTweet(tweetOwner, tweetId)
            public returns(bool)
    {
        Tag memory newTag;
        newTag.text = text;
        emit TagTweet(tweetId);
        return true;
    }
}