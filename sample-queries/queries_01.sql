 --http://www.dpriver.com/pp/sqlformat.htm 
--Finding the 5 oldest users
SELECT username,
       created_at
FROM   users
ORDER  BY created_at DESC
LIMIT  5;

--what day of the week do most users register on? We could use this to generate ads
SELECT Dayname(created_at) AS "day",
       Count(*)            AS total
FROM   users
GROUP  BY day
ORDER  BY total DESC;

--find the users that are inactive so we can send them an ad campaign
SELECT *
FROM   users
       LEFT JOIN photos
              ON users.id = photos.user_id
WHERE  image_url IS NULL;

--Most liked photos
SELECT username,
       photos.id,
       photos.image_url,
       Count(*) AS total
FROM   photos
       INNER JOIN likes
               ON likes.photo_id = photos.id
       INNER JOIN users
               ON photos.user_id = users.id
GROUP  BY photos.id
ORDER  BY total DESC
LIMIT  1;

--average number of photos per user | 257 photos divided by 100 users
SELECT (SELECT Count(*)
        FROM   photos) / (SELECT Count(*)
                          FROM   users) AS avg;

--top 5 most commonly used hashtags
SELECT photo_tags.photo_id,
       tags.tag_name,
       Count(*) AS "total"
FROM   photo_tags
       JOIN tags
         ON tag_id = tags.id
GROUP  BY tag_id
ORDER  BY total DESC;

--find users/bots who have liked every single photo on the site
--the purpose of the subquery is to detect the total number of photos w/out hard coding the actual number
SELECT username,
       Count(*) AS num_likes
FROM   users
       INNER JOIN likes
               ON users.id = likes.user_id
GROUP  BY likes.user_id
HAVING num_likes = (SELECT Count(*)
                    FROM   photos);  