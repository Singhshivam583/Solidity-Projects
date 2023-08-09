// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

contract TweetContract {
    struct Tweet {
        uint id;
        address author;
        bytes content;
        uint createdAt;
    }

    mapping(uint => Tweet) public tweets;
    mapping(address => uint[]) public tweetsOf;

    uint nextId;

    function tweet(bytes memory _content) public {
        tweets[nextId] = Tweet(nextId, msg.sender, _content, block.timestamp);
        tweetsOf[msg.sender].push(nextId);
        nextId++;
    }

    function getLatestTweets(uint startIndex, uint count) public view returns (Tweet[] memory) {
        require(count > 0 && startIndex < nextId, "Invalid start index or count");

        if (startIndex + count > nextId) {
            count = nextId - startIndex;
        }

        Tweet[] memory _tweets = new Tweet[](count);

        for (uint i = 0; i < count; i++) {
            Tweet storage tweet = tweets[startIndex + i];
            _tweets[i] = Tweet(tweet.id, tweet.author, tweet.content, tweet.createdAt);
        }

        return _tweets;
    }
}
