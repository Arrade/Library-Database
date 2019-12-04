DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema()) LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;

CREATE TABLE "users" (
    "userID" int PRIMARY KEY,
    "fullName" text,
    "email" text,
    "bostadsAdress" text,
    "borrowedBooks" int CHECK ("borrowedBooks" >= 0),
    "dateOfBirth" date
);

CREATE TABLE "admins" (
    "userID" int REFERENCES users,
    "department" text,
    "phoneNumber" text,
    "C/O-adress" text,
    "postnr" text,
    "postadress" text,
    "privatePhone" text
);

CREATE TABLE "students" (
    "userID" int REFERENCES users,
    "programme" text
);

CREATE TABLE "books" (
    "mediaID" int PRIMARY KEY,
    "title" text,
    "genre" text,
    "ISBN" text,
    "edition" text,
    "language" text,
    "publisher" text,
    "dateOfPublication" date,
    "pages" int CHECK ("pages" >= 0),
    "prequelID" text,
    "sequelID" text,
    "series" text
);

CREATE TABLE "bookMap" (
    "resourceID" int PRIMARY KEY,
    "mediaID" int  REFERENCES books
);

CREATE TABLE "borrowed" (
    "borrowingID" int PRIMARY KEY,
    "userID" int REFERENCES users,
    "resourceID" int REFERENCES "bookMap",
    "dateOfBorrowing" date NOT NULL, --2.--
    "expireDate" date CHECK ("expireDate" > "dateOfBorrowing"),
    "returnDate" date,
    "timesRenewed" int NOT NULL CHECK ("timesRenewed" >= 0 AND "timesRenewed" < 4) --2.--
);
    

CREATE TABLE "fines" (
    "borrowingID" int REFERENCES borrowed,
    "amount" int CHECK ("amount" >= 0),
    "paid" int CHECK ("paid" >= 0),
    "daysOverExp" int CHECK ("daysOverExp" >= 0)
);

CREATE TABLE "contProducer" (
    "contentProducerID" text PRIMARY KEY,
    "name" text,
    "role" text
);

CREATE TABLE "contProd_map" (
    "mediaID" int REFERENCES books,
    "contentProducerID" text REFERENCES "contProducer"
);

--Fyller databasen--
INSERT INTO books VALUES(1, 'Nineteen Eighty-Four', 'Dystopian', '470015866', 1,'english', 'Secker & Warburg', '1949-06-08', 328, NULL, NULL,NULL);
INSERT INTO books VALUES(2, 'The Fellowship of the Ring', 'Fantasy', '12228601', 1,'english', 'George Allen & Unwin', '1954-06-29', 423, NULL, 3, 'The Lord of the Rings');
INSERT INTO books VALUES(3, 'The Two Towers', 'Fantasy', '936070', 1,'english', 'George Allen & Unwin', '1954-11-11', 352, 2, 4, 'The Lord of the Rings');
INSERT INTO books VALUES(4, 'The Return of the King', 'Fantasy', '933993', 1,'english', 'George Allen & Unwin', '1955-10-20', 416, 3, NULL, 'The Lord of the Rings');
INSERT INTO books VALUES(5, 'Harry Potter and the Prisoner of Azkaban', 'Fantasy', '0747542155', 1,'english', 'Bloomsbury (UK)', '1999-07-08',317, 15, 6, 'Harry Potter');
INSERT INTO books VALUES(6, 'Harry Potter and the Goblet of Fire', 'Fantasy', '074754624X', 1,'english', 'Bloomsbury (UK)', '2000-07-08',636, 5, 7, 'Harry Potter');
INSERT INTO books VALUES(7, 'Harry Potter and the Order of the Pheonix', 'Fantasy', '0747551006', 1,'english', 'Bloomsbury (UK)', '2003-06-21',766, 6, 8, 'Harry Potter');
INSERT INTO books VALUES(8, 'Harry potter and the Half-Blood Prince', 'Fantasy','0747581088', 1,'english', 'Bloomsbury (UK)', '2005-07-16',607, 7, 9, 'Harry Potter');
INSERT INTO books VALUES(9, 'Harry Potter and the Deathly Hallows', 'Fantasy', '0545010225', 1,'english', 'Bloomsbury (UK)', '2007-07-21',607, 8, NULL, 'Harry Potter');
INSERT INTO books VALUES(10, 'Go Set a Watchman', 'Fiction', '9788467260656', 1,'english', 'J. B. Lippincott & Co.', '1960-07-11',278, 11, NULL, 'To Kill a Mockingbird');
INSERT INTO books VALUES(11, 'To Kill a Mockingbird', 'Southern Gothic', '9780062409850', 1,'english', 'HarperCollins', '2015-07-14',281, NULL, 10, 'To Kill a Mockingbird');
INSERT INTO books VALUES(12, 'Calculus', 'Course literature', '9780321781079', 8,'english', 'Pearson Addison Wesley', '2013-09-13',1026, NULL, NULL, NULL);
INSERT INTO books VALUES(13, 'Calculus', 'Course literature', '9780134154367', 9,'english', 'Pearson Addison Wesley', '2016-01-11',1026, NULL, NULL, NULL);
INSERT INTO books VALUES(14, 'Harry Potter and the Philospher`s Stone', 'Fantasy', '0747532699', 1,'english', 'Bloomsbury (UK)', '1998-07-02',223, NULL, 15, 'Harry Potter');
INSERT INTO books VALUES(15, 'Harry Potter and the Chamber of Secrets', 'Fantasy', '0747538492', 1,'english', 'Bloomsbury (UK)', '1998-07-02',251, 14, 5, 'Harry Potter');

--students--
INSERT INTO users VALUES(1, 'Gabriella Noyer', 'gn@lms.se', 'Norrfjäll 93', 0, '1970-12-02');
INSERT INTO users VALUES(2, 'Ida Kästner', 'Iik@lms.se', 'Dadelvägen 48', 0, '1981-04-13');
INSERT INTO users VALUES(3, 'Fouad Caro', 'fc@lms.se', 'Storgatan 61', 0, '1982-04-14');
INSERT INTO users VALUES(4, 'Salomon Ahlgren', 'sa@lms.se', 'Karlsängen 44', 0, '1983-12-29');
INSERT INTO users VALUES(5, 'Titos Wuopio', 'tw@lms.se', 'Kaptensgränd 89', 0, '1984-06-10');
INSERT INTO users VALUES(6, 'Hakim Adolvsson', 'ha@lms.se', 'Eriksbo 16', 0, '1985-08-30');
INSERT INTO users VALUES(7, 'Georgine Stieber', 'gs@lms.se', 'Skärpinge 37', 0, '1986-09-08');
INSERT INTO users VALUES(8, 'Ragnhild Gage', 'rg@lms.se', 'Tuvvägen 60', 0, '1990-12-12');
INSERT INTO users VALUES(9, 'Nima Herrera', 'nh@lms.se', 'Kantorsvägen 6', 0, '1993-02-22');
INSERT INTO users VALUES(10, 'Tove Pallesen', 'tp@lms.se', 'Edeby 80', 0, '1993-05-21');
INSERT INTO users VALUES(11, 'Francesco Svensson', 'fs@lms.se', 'Knektvägen 63', 0, '1994-04-23');
INSERT INTO users VALUES(12, 'Otto Taube', 'ot@lms.se', 'Nybyvägen 44', 0, '2002-02-27');
INSERT INTO users VALUES(13, 'Angelika Boehler', 'ab@lms.se', 'Figgeberg Gårdeby 31', 0, '2008-01-10');
INSERT INTO users VALUES(14, 'Britt Baumbach', 'bb@lms.se', 'Backsippestigen 41', 0, '2008-04-11');
INSERT INTO users VALUES(15, 'Ina Lange', 'il@lms.se', 'Stallstigen 70', 0, '2008-10-18');

--Amins--
INSERT INTO users VALUES(16, 'Gloria Ellis', 'ge@lms.se', 'Kvillevägen 44', 0, '1946-11-16');
INSERT INTO users VALUES(17, 'Wilma Mcdonald', 'wm@lms.se', 'Buanvägen 75', 0, '1948-02-25');
INSERT INTO users VALUES(18, 'Denise Webster', 'dw@lms.se', 'Alsteråvägen 82', 0, '1951-01-23');
INSERT INTO users VALUES(19, 'Nellie Vaughn', 'nv@lms.se', 'Tuvvägen 19', 0, '1955-11-28');
INSERT INTO users VALUES(20, 'Ethel Stone', 'es@lms.se', 'Barrgatan 50', 0, '1962-12-19');
INSERT INTO users VALUES(21, 'Troy Greer', 'tg@lms.se', 'Näsåkersv 65', 0, '1968-04-12');
INSERT INTO users VALUES(22, 'Ray Pope', 'rp@lms.se', 'Nästvattnet 41', 0, '1968-05-06');
INSERT INTO users VALUES(23, 'Martha Ballard', 'mb@lms.se', 'Kaptensgränd 28', 0, '1971-12-29');
INSERT INTO users VALUES(24, 'Kevin Byrd', 'kb@lms.se', 'Edeby 96', 0, '1973-10-27');
INSERT INTO users VALUES(25, 'Jonathon Carroll', 'jc@lms.se', 'Idvägen 67', 0, '1974-04-17');
INSERT INTO users VALUES(26, 'Louis Gregory', 'lg@lms.se', 'Hammarvägen 35', 0, '1987-01-24');
INSERT INTO users VALUES(27, 'Darrin Ramirez', 'dr@lms.se', 'Lemesjö 4', 0, '1989-06-01');
INSERT INTO users VALUES(28, 'Sylvester Brown', 'sb@lms.se', 'Sandlyckan 99', 0, '1990-07-22');
INSERT INTO users VALUES(29, 'Marian Buchanan', 'mb@lms.se', 'Kaptensgränd 98', 0, '1995-06-13');
INSERT INTO users VALUES(30, 'Phyllis Barnes', 'pb@lms.se', 'Hagaskog 66', 0, '1999-11-04');

INSERT INTO students VALUES(1, 'Computer Science');
INSERT INTO students VALUES(2, 'Biotechnology');
INSERT INTO students VALUES(3, 'Biotechnology');
INSERT INTO students VALUES(4, 'Engingeering Chemistry');
INSERT INTO students VALUES(5, 'Engineering Physics');
INSERT INTO students VALUES(6, 'Computer Science');
INSERT INTO students VALUES(7, 'Vehical Engineering');
INSERT INTO students VALUES(8, 'Mechanical Engineering');
INSERT INTO students VALUES(9, 'Vehical Engineering');
INSERT INTO students VALUES(10, 'Engineering Physics');
INSERT INTO students VALUES(11, 'Computer Science');
INSERT INTO students VALUES(12, 'Mechanical Engineering');
INSERT INTO students VALUES(13, 'Biotechnology');
INSERT INTO students VALUES(14, 'Architecture');
INSERT INTO students VALUES(15, 'Computer Science');

INSERT INTO admins VALUES(16, 'Agency of Data Control', '4957732840', 'none', '113345', 'Turegatan 4', '4957732840');
INSERT INTO admins VALUES(17, 'Agency of Telecommunications Hardware Technology', '3557484137', 'none', '113347', 'sveagatan 1', '3557484137');
INSERT INTO admins VALUES(18, 'Branch of On-Line Internet Administration and Intranet Networking', '9824722797', 'none', '113337', 'öresundsgatan 1', '9824722797');
INSERT INTO admins VALUES(19, 'Branch of Wireless Hardware Programming', '7224186750', 'none', '1132245', 'sturegatan 1', '7224186750');
INSERT INTO admins VALUES(20, 'Bureauof Internet Security', '5712665248', 'none', '1132256', 'brovägen 1', '5712665248');
INSERT INTO admins VALUES(21, 'Bureau of Software Administration', '4292539249', 'none', '1132742', 'kalavägen 1', '4292539249');
INSERT INTO admins VALUES(22, 'Bureau of Telecommunications Mainframe Development', '2920735252', 'none', '1132263', 'ringvägen 1', '2920735252');
INSERT INTO admins VALUES(23, 'Department of Code Acquisition and Networking', '8626937767', 'none', '1132456', 'ringgatan 1', '8626937767');
INSERT INTO admins VALUES(24, 'Department of Intranet Backup', '6607649809', 'none', '1132345', 'storegatan 1', '6607649809');
INSERT INTO admins VALUES(25, 'Hardware Security Department', '1370977282', 'none', '1132223', 'klövervägen 1', '1370977282');
INSERT INTO admins VALUES(26, 'Mainframe Intranet Backup Department', '8922841353', 'none', '1132365', 'rotgatan 1', '8922841353');
INSERT INTO admins VALUES(27, 'Mainframe Programming Networking and Multimedia Control Team', '7276541006', 'none', '1132224', 'musikvägen 1', '7276541006');
INSERT INTO admins VALUES(28, 'Object-Oriented Data Implementation and Analytical Software Programm', '5040445061', 'none', '1132567', 'norrholmsvägen 1', '5040445061');
INSERT INTO admins VALUES(29, 'Portable Database Security and Application Implementation Division', '5661533246', 'none', '1132789', 'norrvägen 1', '5661533246');
INSERT INTO admins VALUES(30, 'Software Implementation Department', '3952497320', 'none', '1132789', 'rungarvägen 1', '3952497320');

--Extra saker som ska finnas i databasen--
--maping books to mediaID--
INSERT INTO "bookMap" VALUES(1, 1);
INSERT INTO "bookMap" VALUES(2, 2);
INSERT INTO "bookMap" VALUES(3, 3);
INSERT INTO "bookMap" VALUES(4, 4);
INSERT INTO "bookMap" VALUES(5, 5);
INSERT INTO "bookMap" VALUES(6, 6);
INSERT INTO "bookMap" VALUES(7, 7);
INSERT INTO "bookMap" VALUES(8, 8);
INSERT INTO "bookMap" VALUES(9, 9);
INSERT INTO "bookMap" VALUES(10, 10);
INSERT INTO "bookMap" VALUES(11, 11);
INSERT INTO "bookMap" VALUES(12, 12);
INSERT INTO "bookMap" VALUES(13, 13);
INSERT INTO "bookMap" VALUES(29, 14);
INSERT INTO "bookMap" VALUES(30, 15);

--3 copies of 5 book--
INSERT INTO "bookMap" VALUES(14, 1);
INSERT INTO "bookMap" VALUES(15, 1);
INSERT INTO "bookMap" VALUES(16, 1);
INSERT INTO "bookMap" VALUES(17, 2);
INSERT INTO "bookMap" VALUES(18, 2);
INSERT INTO "bookMap" VALUES(19, 2);
INSERT INTO "bookMap" VALUES(20, 3);
INSERT INTO "bookMap" VALUES(21, 3);
INSERT INTO "bookMap" VALUES(22, 3);
INSERT INTO "bookMap" VALUES(23, 4);
INSERT INTO "bookMap" VALUES(24, 4);
INSERT INTO "bookMap" VALUES(25, 4);
INSERT INTO "bookMap" VALUES(26, 5);
INSERT INTO "bookMap" VALUES(27, 5);
INSERT INTO "bookMap" VALUES(28, 5);

--lånade böcker just nu  "borrowingID", "userID", "resourceID", "dateOfBorrowing", "expireDate",  "returnDate" --
--Students--
INSERT INTO borrowed VALUES(12, 2, 2, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(11, 1, 1, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(13, 3, 3, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(14, 4, 4, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(15, 5, 5, '2019-10-18', '2019-11-18', NULL, 0);
--fler lånade böcker av en student--
INSERT INTO borrowed VALUES(25, 1, 11, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(26, 1, 12, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(27, 1, 13, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(28, 1, 14, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(29, 1, 15, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(30, 1, 16, '2019-10-18', '2019-11-18', NULL, 0);

--Admins--
INSERT INTO borrowed VALUES(16, 16, 6, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(17, 17, 7, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(18, 18, 8, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(19, 19, 9, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(20, 20, 10, '2019-10-18', '2019-11-18', NULL, 0);
--Fler låndade böcker av en admin--
INSERT INTO borrowed VALUES(31, 17, 17, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(32, 17, 18, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(33, 17, 19, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(34, 17, 20, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(35, 17, 21, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(36, 17, 22, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(37, 17, 23, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(38, 17, 24, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(39, 17, 25, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(40, 17, 26, '2019-10-18', '2019-11-18', NULL, 0);
INSERT INTO borrowed VALUES(41, 17, 27, '2019-10-18', '2019-11-18', NULL, 0);


--lånade vid ett annat tillfälle, 5 som retunerades sent--
INSERT INTO borrowed VALUES(1, 1, 1, '2019-01-04', '2019-01-11', '2019-01-05', 0);
INSERT INTO borrowed VALUES(2, 2, 2, '2019-01-05', '2019-01-12', '2019-01-10', 0);
INSERT INTO borrowed VALUES(3, 3, 3, '2019-01-06', '2019-01-13', '2019-01-10', 0);
INSERT INTO borrowed VALUES(4, 4, 4, '2019-01-08', '2019-01-15', '2019-01-15', 0);
INSERT INTO borrowed VALUES(5, 5, 5, '2019-01-15', '2019-01-22', '2019-01-20', 0);

--Dem sena--
INSERT INTO borrowed VALUES(6, 6, 6, '2019-01-23', '2019-01-30', '2019-02-04', 0); -- ska in v.5
INSERT INTO borrowed VALUES(7, 7, 7, '2019-01-15', '2019-01-12', '2019-01-18', 0); -- ska in v.2
INSERT INTO borrowed VALUES(8, 8, 8, '2019-01-19', '2019-01-26', '2019-01-29', 0); -- ska in v.4
INSERT INTO borrowed VALUES(9, 4, 9, '2019-01-16', '2019-01-23', '2019-01-28', 0); -- ska in v.4
INSERT INTO borrowed VALUES(10, 5, 10, '2019-01-09', '2019-01-25', '2019-01-29', 0); --ska in v.4

--lånade och försenade--
INSERT INTO borrowed VALUES(21, 9, 11, '2019-02-03', '2019-02-12', NULL, 0); -- ska in 7, 
INSERT INTO borrowed VALUES(22, 10, 12, '2019-01-6', '2019-01-12', '2019-01-14', 0); --ska in v.2

--test for favorite genre--
INSERT INTO borrowed VALUES(23, 4, 13, '2019-03-18', '2019-04-18', '2019-04-17', 0);
INSERT INTO borrowed VALUES(24, 2, 12, '2019-03-18', '2019-04-18', '2019-04-17', 0);


INSERT INTO "contProducer" VALUES(1, 'George Orwell', 'author');
INSERT INTO "contProducer" VALUES(2, 'J. R. R. Tolkien', 'author');
INSERT INTO "contProducer" VALUES(3, 'J. K. Rowling', 'author');
INSERT INTO "contProducer" VALUES(4, 'Harper Lee', 'author'); 
INSERT INTO "contProducer" VALUES(5, 'Adams, Robert A', 'author');

--Content Producers-- 
INSERT INTO "contProd_map" VALUES(1, 1);
INSERT INTO "contProd_map" VALUES(2, 2);
INSERT INTO "contProd_map" VALUES(3, 2);
INSERT INTO "contProd_map" VALUES(4, 2);
INSERT INTO "contProd_map" VALUES(5, 3);
INSERT INTO "contProd_map" VALUES(6, 3);
INSERT INTO "contProd_map" VALUES(7, 3);
INSERT INTO "contProd_map" VALUES(8, 3);
INSERT INTO "contProd_map" VALUES(9, 3);
INSERT INTO "contProd_map" VALUES(10, 4);
INSERT INTO "contProd_map" VALUES(11, 4);
INSERT INTO "contProd_map" VALUES(12, 5);
INSERT INTO "contProd_map" VALUES(13, 5);
INSERT INTO "contProd_map" VALUES(14, 1);
INSERT INTO "contProd_map" VALUES(15, 2);
--INSERT INTO "contProd_map" VALUES(16, 2);
--INSERT INTO "contProd_map" VALUES(17, 2);
--INSERT INTO "contProd_map" VALUES(18, 3);

INSERT INTO fines VALUES(22, 30, '0',10);
INSERT INTO fines VALUES(21, 50, '0',6);
INSERT INTO fines VALUES(10, 20, '1',2);
INSERT INTO fines VALUES(5, 20, '1',5);
INSERT INTO fines VALUES(9, 20, '1',6);

GRANT ALL PRIVILEGES ON TABLE "contProducer" TO danker;
GRANT ALL PRIVILEGES ON TABLE "contProd_map" TO danker;
GRANT ALL PRIVILEGES ON TABLE "books" TO danker;
GRANT ALL PRIVILEGES ON TABLE "bookMap" TO danker;
GRANT ALL PRIVILEGES ON TABLE "fines" TO danker;
GRANT ALL PRIVILEGES ON TABLE "borrowed" TO danker;
GRANT ALL PRIVILEGES ON TABLE "students" TO danker;
GRANT ALL PRIVILEGES ON TABLE "admins" TO danker;
GRANT ALL PRIVILEGES ON TABLE "users" TO danker;

--Triggers--

CREATE OR REPLACE FUNCTION check_number_of_books()
RETURNS TRIGGER AS
$body$
BEGIN

    --1.1--
    IF ((SELECT "Nummber of Borrowed" FROM( 
        SELECT "userID", count("userID") AS "Nummber of Borrowed" 
        FROM "borrowed" NATURAL JOIN "students" 
        WHERE NEW."returnDate" IS NULL AND "userID" = NEW."userID"
        GROUP BY "userID") AS final) > 7)
    THEN 
        RAISE EXCEPTION 'INSERT statement exceeding maximum number of 7 books for this student';
    END IF;

    --1.2--
    IF ((SELECT "Nummber of Borrowed" FROM( 
        SELECT "userID", count("userID") AS "Nummber of Borrowed" 
        FROM "borrowed" NATURAL JOIN "admins" 
        WHERE NEW."returnDate" IS NULL AND "userID" = NEW."userID"
        GROUP BY "userID") AS final) >= 12)
    THEN 
        RAISE EXCEPTION 'INSERT statement exceeding maximum number of 12 books for this admin';
    END IF;

    --1.3--
    IF (NEW."timesRenewed" >= 3) THEN
        RAISE EXCEPTION 'You can not borrow a book more then 3 times';

    ELSIF (TG_OP = 'UPDATE' AND NEW."dateOfBorrowing" != OLD."dateOfBorrowing") THEN
        NEW."timesRenewed" = OLD."timesRenewed" + 1;
    END IF;

    --student 3.w--
    IF ((TG_OP = 'UPDATE' OR TG_OP = 'INSERT') AND 
    ((SELECT count("userID") from "users" NATURAL JOIN "admins" WHERE "userID" = NEW."userID") = 0)) THEN
        NEW."expireDate" =  NEW."dateOfBorrowing" + 21;
    --1.4--
    --admins 5.w--
    ELSIF((TG_OP = 'UPDATE' OR TG_OP = 'INSERT') AND 
    ((SELECT count("userID") from "users" NATURAL JOIN "students" WHERE "userID" = NEW."userID") = 0)) THEN
        NEW."expireDate" =  NEW."dateOfBorrowing" + 35;
    END IF;

    RETURN NEW;
END;
$body$
LANGUAGE plpgsql;

CREATE TRIGGER tr_check_number_of_books
BEFORE INSERT OR UPDATE ON "borrowed"
FOR EACH ROW EXECUTE PROCEDURE check_number_of_books();


