-- 1. Identify Users by locations
-- Question: Write a query to find all posts made by users in specific locations such as 'Agra', 'Maharashtra', and 'West Bengal'.

select * from users;
SELECT u.user_id, u.username, p.location
FROM post p
JOIN users u ON p.user_id = u.user_id
ORDER BY u.user_id ASC;

-- 2.Determine the Most Followed Hashtags
-- Question: Write a query to list the top 5 most-followed hashtags on the platform.

SELECT h.hashtag_name, COUNT(hf.user_id) AS follow_count
FROM hashtags h
JOIN hashtag_follow hf ON h.hashtag_id = hf.hashtag_id
GROUP BY h.hashtag_id, h.hashtag_name
ORDER BY follow_count DESC
LIMIT 5;

-- 3. Find the Most Used Hashtags
-- Question: Identify the top 10 most-used hashtags in posts

SELECT h.hashtag_name, COUNT(pt.post_id) AS usage_count
FROM hashtags h
JOIN post_tags pt ON h.hashtag_id = pt.hashtag_id
GROUP BY h.hashtag_id, h.hashtag_name
ORDER BY usage_count DESC
LIMIT 10;

-- 4. Identify the Most Inactive User
-- Question: Write a query to find users who have never made any posts on the platform.

SELECT u.user_id, u.username
FROM users u
WHERE u.user_id NOT IN (
    SELECT p.user_id
    FROM post p);

-- 5. Identify the Posts with the Most Likes
-- Question: Write a query to find the posts that have received the highest number of likes.
SELECT p.post_id, p.caption, COUNT(pl.user_id) AS like_count
FROM post p
JOIN post_likes pl ON p.post_id = pl.post_id
GROUP BY p.post_id, p.caption
ORDER BY like_count DESC
LIMIT 5;

-- 6. Calculate Average Posts per User
-- Question: Write a query to determine the average number of posts made by users.
SELECT AVG(post_count) AS average_posts_per_user
FROM (
    SELECT COUNT(post_id) AS post_count
    FROM post
    GROUP BY user_id
) AS user_post_counts;

-- 7. Track the Number of Logins per User
-- Question: Write a query to track the total number of logins made by each user.
SELECT u.user_id, u.username, COUNT(l.login_id) AS login_count
FROM users u
LEFT JOIN login l ON u.user_id = l.user_id
GROUP BY u.user_id, u.username;

-- 8. Identify a User Who Liked Every Single Post
-- Question: Write a query to find any user who has liked every post on the platform.
SELECT u.user_id, u.username
FROM users u
JOIN (
    SELECT user_id
    FROM post_likes
    GROUP BY user_id
    HAVING COUNT(DISTINCT post_id) = (SELECT COUNT(*) FROM post)
) AS users_who_liked_all_posts
ON u.user_id = users_who_liked_all_posts.user_id;

-- 9. Find Users Who Never Commented
-- Question: Write a query to find users who have never commented on any post.
SELECT u.user_id, u.username
FROM users u
WHERE u.user_id NOT IN (
    SELECT c.user_id
    FROM comments c);


-- 10. Identify a User Who Commented on Every Post 
-- Question:Write a query to find any user who has commented on every post on the platform.
-- Count the total number of posts
WITH total_posts AS (
    SELECT COUNT(*) AS total_count
    FROM post),
-- Count the number of distinct posts commented on by each user
user_comments AS (
    SELECT user_id, COUNT(DISTINCT post_id) AS commented_post_count
    FROM comments
    GROUP BY user_id)
-- Find users who have commented on every post
SELECT u.user_id, u.username
FROM users u
JOIN user_comments uc ON u.user_id = uc.user_id
JOIN total_posts tp
ON uc.commented_post_count = tp.total_count;

-- 11. Identify Users Not Followed by Anyone
-- Question: Write a query to find users who are not followed by any other users.
SELECT u.user_id, u.username
FROM users u
LEFT JOIN follows f ON u.user_id = f.followee_id
WHERE f.followee_id IS NULL;

-- 12. Identify Users Who Are Not Following Anyone
-- Question: Write a query to find users who are not following anyone.
SELECT u.user_id, u.username
FROM users u
LEFT JOIN follows f ON u.user_id = f.follower_id
WHERE f.follower_id IS NULL;

-- 13. Find Users Who Have Posted More than 5 Times
-- Write a query to find users who have made more than five posts.
SELECT u.user_id, u.username, COUNT(p.post_id) AS post_count
FROM users u
JOIN post p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username
HAVING COUNT(p.post_id) > 5;

-- 14. Identify Users with More than 40 Followers
-- Write a query to find users who have more than 40 followers.
SELECT u.user_id, u.username, COUNT(f.follower_id) AS follower_count
FROM users u
JOIN follows f ON u.user_id = f.followee_id
GROUP BY u.user_id, u.username
HAVING COUNT(f.follower_id) > 40;

-- 15. Search for Specific Words in Comments
-- Write a query to find comments containing specific words like "good" or "beautiful."
SELECT comment_id, comment_text
FROM comments
WHERE comment_text REGEXP 'good|beautiful';

-- 16. Identify the Longest Captions in Posts
-- Write a query to find the posts with the longest captions.
SELECT post_id, caption, LENGTH(caption) AS caption_length
FROM post
ORDER BY caption_length DESC
LIMIT 5;




    




