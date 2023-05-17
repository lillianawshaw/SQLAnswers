
/* This file can be run against any database on an instance of SQL Server (2012+). It won't change anything,
 * all tables are just table variables.
 * Please provide answers to the questions in the form of comments where appropriate, or SQL code. If example
 * SQL queries demonstrate a bug, then you are free to update them, or write a new query below. Once complete,
 * save the file and return.
 * Please don't modify the table declarations or insertions located before the questions.
 */
DECLARE @Client TABLE ([ClientID] INT NOT NULL, [Name] NVARCHAR(50) NOT NULL, [AddressID] INT NULL)
INSERT @Client
       ([ClientID], [Name]           , [AddressID])
VALUES (         1, 'Zahra Tate'     ,           1)
      ,(         2, 'Sienna Lin'     ,           2)
      ,(         3, 'Charlotte Small',           3)
      ,(         4, 'Tilly Kelly'    ,           3)
      ,(         5, 'Ebony Bowman'   ,           4)
      ,(         6, 'Ellis Moses'    ,        NULL)
      ,(         7, 'William Avila'  ,           2)
      ,(         8, 'Ahmad Slater'   ,           1)
      ,(         9, 'Jesse Dale'     ,           6)
      ,(        10, 'Aidan Lyons'    ,           6)

DECLARE @Address TABLE ([AddressID] INT NOT NULL, [Address] NVARCHAR(100) NOT NULL)
INSERT @Address
       ([AddressID], [Address]         )
VALUES (          1, '1 High Street'   )
     , (          2, '2 Lime Grove'    )
     , (          3, '3 Toad Lane'     )
     , (          4, '4 Frost Crescent')
     , (          5, '5 Cattle Close'  )
     , (          6, '6 Green Lane'    )

DECLARE @Telephone TABLE ([TelephoneID] INT NOT NULL, [Number] VARCHAR(30) NOT NULL)
INSERT @Telephone
       ([TelephoneID], [Number]      )
VALUES (            1, '07700900000' )
     , (            2, '07700900001' )
     , (            3, '07700900002' )
     , (            4, '07700 900003')
     , (            5, '07700 900004')
     , (            6, '07700 900005')
     , (            7, '07700900006' )
     , (            8, '07700900007' )
     , (            9, '07700 900008')
     , (           10, '07700900009' )
     , (           11, '07700900010' )
     , (           12, '07700900011' )
     , (           13, '07700900012' )
     , (           14, '07700 900013')
     , (           15, '07700 900014')
     , (           16, '07700 900015')

DECLARE @ClientTelephone TABLE ([ClientID] INT NOT NULL, [TelephoneID] INT NOT NULL, [Priority] INT NOT NULL)
INSERT @ClientTelephone
       ([ClientID], [TelephoneID], [Priority])
VALUES (         1,             1,          1)
     , (         1,             2,          2)
     , (         2,             3,          1)
     , (         4,             4,          1)
     , (         4,             5,          3)
     , (         4,             6,          4)
     , (         5,             7,          1)
     , (         6,             8,          2)
     , (         7,             9,          1)
     , (         7,            10,          2)
     , (         8,            11,          1)
     , (         9,            12,          1)

DECLARE @AddressTelephone TABLE ([AddressID] INT NOT NULL, [TelephoneID] INT NOT NULL)
INSERT @AddressTelephone
       ([AddressID], [TelephoneID])
VALUES (          2,            13)
     , (          3,            14)
     , (          3,            15)
     , (          4,            16)

--/* 1) The application displays the results of the following query, which should show all clients in
-- *    the database, along with their address. A user has complained that all the data isn't shown.
-- *    a) What is missing from the results?
-- *        - The code below is an inner join. 
-- *        - This means that it returns rows which have a matching value in a given row in both tables.
-- *        - As Ellis Moses has a Null value in address they are not returned.
-- *        - To fix this would be to use a LEFT OUTER JOIN instead as this returns all rows from the left (starting) table. 
-- *        
-- *    b) Why is the data missing?
-- *    c) How could the query be corrected?
-- */

SELECT
    [C].[Name],
    [A].[Address]
FROM
    @Client [C]
LEFT JOIN
    @Address [A]
ON
    [C].[AddressID] = [A].[AddressID];



--/* 2) The query below is supposed to return clients with their highest priority personal telephone number.
-- *    If the client has no personal telephone numbers, then they shouldn't be included in the results.
-- *    However, there is a complaint that a client is missing from the results.
-- *    a) Which client is missing?
-- *        -None. When I run the code below I am returned 7 rows which are the same as all rows with
-- *        - priority 1. 
-- *    b) Why is the client missing?
-- *    c) How could the query be corrected?
-- */
SELECT
    [C].[Name],
    [T1].[Number]
FROM
    @Client [C] JOIN
    @ClientTelephone [CT] ON
        [C].[ClientID] = [CT].[ClientID] AND
        [CT].[Priority] = 1 JOIN
    @Telephone [T1] ON
        [CT].[TelephoneID] = [T1].[TelephoneID]

--/* 3) An incoming telephone call arrives. Define a query which when given the telephone number,
-- *    will bring back the names of clients the call might be from. Note that telephone numbers
-- *    supplied to this query will not contain any whitespace. Note that the call might be from
-- *    a client, but it might also be from a client's home address. We want to know who the call
-- *    might be from in both cases.
-- */

DECLARE @Number VARCHAR(30) = '07700900012' --07700900012


-- this code gets the TelephoneID and assigns it to number
SELECT @Number = [TelephoneID]
FROM @Telephone
WHERE [Number] = @Number;

-- This code retrieves the client name and address associated with a given phone number
-- It performs a full outer join between the @Telephone, @AddressTelephone, @Address, @ClientTelephone, and @Client tables
-- The join is performed on the TelephoneID, AddressID, and ClientID columns
-- The WHERE clause filters the results to only those rows where the TelephoneID matches the @Number variable

SELECT 
    [C].[Name],
    [A].[Address]
FROM
    @Telephone [T]
    FULL OUTER JOIN
    @AddressTelephone [AT] ON
    [T].TelephoneID = [AT].TelephoneID
    FULL OUTER JOIN 
    @Address [A] ON
    [AT].AddressID = [A].AddressID
    FULL OUTER JOIN
    @ClientTelephone [CT] ON
    [T].TelephoneID = [CT].TelephoneID
    FULL OUTER JOIN 
    @Client [C] ON
    [CT].ClientID = [C].ClientID

    WHERE [T].TelephoneID = @Number


--GO
