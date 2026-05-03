SELECT b.isbn, b.title
FROM   book AS b
WHERE  b.isbn NOT IN (
    SELECT c.isbn
    FROM   copy AS c
    JOIN   loan AS l ON c.copy_no = l.copy_no
);SELECT b.isbn, b.title
FROM   book AS b
WHERE  b.isbn NOT IN (
    SELECT c.isbn
    FROM   copy AS c
    JOIN   loan AS l ON c.copy_no = l.copy_no
);
